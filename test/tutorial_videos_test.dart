import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/tutorials/tutorial_service.dart';

void main() {
  const id = 'dQw4w9WgXcQ';

  group('extractYoutubeId', () {
    test('raw 11-char IDs (with _ and -)', () {
      expect(extractYoutubeId(id), id);
      expect(extractYoutubeId('  $id  '), id);
      expect(extractYoutubeId('a_b-C1d2E3f'), 'a_b-C1d2E3f');
    });

    test('every common URL shape', () {
      for (final url in [
        'https://www.youtube.com/shorts/$id',
        'https://youtube.com/shorts/$id?feature=share',
        'youtube.com/shorts/$id',
        'https://m.youtube.com/shorts/$id',
        'https://youtu.be/$id',
        'https://youtu.be/$id?si=abcDEF123',
        'youtu.be/$id',
        'https://www.youtube.com/watch?v=$id',
        'https://www.youtube.com/watch?feature=share&v=$id&t=10s',
        'https://m.youtube.com/watch?v=$id',
        'https://music.youtube.com/watch?v=$id',
        'https://www.youtube.com/embed/$id',
        'https://www.youtube-nocookie.com/embed/$id?rel=0',
        'https://www.youtube.com/live/$id',
        'http://www.youtube.com/v/$id',
      ]) {
        expect(extractYoutubeId(url), id, reason: url);
      }
    });

    test('invalid input gives null', () {
      for (final bad in [
        '',
        '   ',
        'short',
        'dQw4w9WgXcQX', // 12 chars
        'dQw4w9WgXc!',
        'https://vimeo.com/$id',
        'https://evil.com/shorts/$id',
        'https://youtube.com.evil.com/watch?v=$id',
        'https://www.youtube.com/watch?v=short',
        'https://www.youtube.com/watch',
        'https://www.youtube.com/channel/UCabcdefghijklmnop',
        'https://youtu.be/',
        'not a url at all',
      ]) {
        expect(extractYoutubeId(bad), isNull, reason: bad);
      }
    });
  });

  test('URLs built from an ID', () {
    expect(youtubeThumbnail(id), 'https://i.ytimg.com/vi/$id/hqdefault.jpg');
    expect(youtubeEmbedUrl(id), 'https://www.youtube-nocookie.com/embed/$id?rel=0&playsinline=1&modestbranding=1');
  });

  test('screen keys', () {
    expect(isValidScreenKey('visitor_pass'), isTrue);
    expect(isValidScreenKey('add_product2'), isTrue);
    expect(isValidScreenKey('Bad Key'), isFalse);
    expect(isValidScreenKey('1abc'), isFalse);
    expect(isValidScreenKey(''), isFalse);
  });
}
