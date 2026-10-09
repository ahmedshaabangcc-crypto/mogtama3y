import 'dart:typed_data';

/// A small pure-Dart gzip/DEFLATE decoder (RFC 1951/1952, after zlib's
/// `puff`). Used on browsers without `DecompressionStream`; the fast path
/// is the browser's own decoder (see platform/gunzip_web.dart).
Uint8List gunzipBytes(Uint8List data) {
  if (data.length < 18 || data[0] != 0x1f || data[1] != 0x8b || data[2] != 8) {
    throw const FormatException('not a gzip stream');
  }
  final flg = data[3];
  var pos = 10;
  if (flg & 4 != 0) pos += 2 + (data[pos] | data[pos + 1] << 8);
  if (flg & 8 != 0) {
    while (data[pos++] != 0) {}
  }
  if (flg & 16 != 0) {
    while (data[pos++] != 0) {}
  }
  if (flg & 2 != 0) pos += 2;
  final n = data.length;
  final size = data[n - 4] | data[n - 3] << 8 | data[n - 2] << 16 | data[n - 1] << 24;
  return _Inflater(data, pos, size).run();
}

class _Huffman {
  _Huffman(int n) : symbol = Int16List(n);
  final count = Int16List(16);
  final Int16List symbol;
}

const _lBase = [3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258];
const _lExt = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0];
const _dBase = [1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577];
const _dExt = [0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13];
const _order = [16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15];

class _Inflater {
  _Inflater(this.src, this.pos, int sizeHint) : out = Uint8List(sizeHint > 0 ? sizeHint : 1 << 16);

  final Uint8List src;
  int pos;
  Uint8List out;
  int outLen = 0;
  int bitBuf = 0;
  int bitCnt = 0;

  int bits(int need) {
    var val = bitBuf;
    while (bitCnt < need) {
      if (pos >= src.length) throw const FormatException('truncated deflate stream');
      val |= src[pos++] << bitCnt;
      bitCnt += 8;
    }
    bitBuf = val >> need;
    bitCnt -= need;
    return val & ((1 << need) - 1);
  }

  void _put(int b) {
    if (outLen == out.length) {
      final bigger = Uint8List(out.length * 2);
      bigger.setRange(0, outLen, out);
      out = bigger;
    }
    out[outLen++] = b;
  }

  static void _build(_Huffman h, List<int> lengths, int start, int n) {
    for (var i = 0; i < 16; i++) {
      h.count[i] = 0;
    }
    for (var s = 0; s < n; s++) {
      h.count[lengths[start + s]]++;
    }
    final offs = List<int>.filled(16, 0);
    for (var len = 1; len < 15; len++) {
      offs[len + 1] = offs[len] + h.count[len];
    }
    for (var s = 0; s < n; s++) {
      final l = lengths[start + s];
      if (l != 0) h.symbol[offs[l]++] = s;
    }
  }

  int decode(_Huffman h) {
    var code = 0, first = 0, index = 0;
    for (var len = 1; len < 16; len++) {
      code |= bits(1);
      final count = h.count[len];
      if (code - count < first) return h.symbol[index + (code - first)];
      index += count;
      first += count;
      first <<= 1;
      code <<= 1;
    }
    throw const FormatException('bad huffman code');
  }

  void codes(_Huffman lencode, _Huffman distcode) {
    while (true) {
      var symbol = decode(lencode);
      if (symbol < 256) {
        _put(symbol);
      } else if (symbol == 256) {
        return;
      } else {
        symbol -= 257;
        if (symbol >= 29) throw const FormatException('bad length symbol');
        final len = _lBase[symbol] + bits(_lExt[symbol]);
        final ds = decode(distcode);
        final dist = _dBase[ds] + bits(_dExt[ds]);
        if (dist > outLen) throw const FormatException('distance too far back');
        for (var i = 0; i < len; i++) {
          _put(out[outLen - dist]);
        }
      }
    }
  }

  Uint8List run() {
    late final _Huffman fixedLen, fixedDist;
    var fixedBuilt = false;
    int last;
    do {
      last = bits(1);
      final type = bits(2);
      if (type == 0) {
        bitBuf = 0;
        bitCnt = 0;
        final len = src[pos] | src[pos + 1] << 8;
        pos += 4;
        for (var i = 0; i < len; i++) {
          _put(src[pos++]);
        }
      } else if (type == 1) {
        if (!fixedBuilt) {
          final lengths = List<int>.filled(288 + 30, 0);
          for (var s = 0; s < 144; s++) {
            lengths[s] = 8;
          }
          for (var s = 144; s < 256; s++) {
            lengths[s] = 9;
          }
          for (var s = 256; s < 280; s++) {
            lengths[s] = 7;
          }
          for (var s = 280; s < 288; s++) {
            lengths[s] = 8;
          }
          for (var s = 288; s < 318; s++) {
            lengths[s] = 5;
          }
          fixedLen = _Huffman(288);
          fixedDist = _Huffman(30);
          _build(fixedLen, lengths, 0, 288);
          _build(fixedDist, lengths, 288, 30);
          fixedBuilt = true;
        }
        codes(fixedLen, fixedDist);
      } else if (type == 2) {
        final nlen = bits(5) + 257;
        final ndist = bits(5) + 1;
        final ncode = bits(4) + 4;
        final lengths = List<int>.filled(320, 0);
        for (var i = 0; i < ncode; i++) {
          lengths[_order[i]] = bits(3);
        }
        final lencode = _Huffman(288);
        final distcode = _Huffman(30);
        _build(lencode, lengths, 0, 19);
        var index = 0;
        while (index < nlen + ndist) {
          var symbol = decode(lencode);
          if (symbol < 16) {
            lengths[index++] = symbol;
          } else {
            var len = 0;
            if (symbol == 16) {
              if (index == 0) throw const FormatException('repeat with no first length');
              len = lengths[index - 1];
              symbol = 3 + bits(2);
            } else if (symbol == 17) {
              symbol = 3 + bits(3);
            } else {
              symbol = 11 + bits(7);
            }
            if (index + symbol > nlen + ndist) throw const FormatException('too many lengths');
            while (symbol-- > 0) {
              lengths[index++] = len;
            }
          }
        }
        _build(lencode, lengths, 0, nlen);
        _build(distcode, lengths, nlen, ndist);
        codes(lencode, distcode);
      } else {
        throw const FormatException('bad block type');
      }
    } while (last == 0);
    return out.length == outLen ? out : Uint8List.sublistView(out, 0, outLen);
  }
}
