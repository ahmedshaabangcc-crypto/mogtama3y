import 'package:intl/intl.dart' hide TextDirection;
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/geo/money.dart';
import '../../core/geo/phones.dart';
import '../../core/shops/store_service.dart';
import 'admin/admin_common.dart';

/// Printable invoices / packing slips and the orders CSV of متجري. Pure
/// string builders (tested); printing / downloading goes through
/// web/print-card.js.

String _esc(Object? v) => (v ?? '')
    .toString()
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');

/// Only http(s) images get into the document.
String? _safeUrl(Object? v) {
  final s = v is String ? v.trim() : null;
  if (s == null || s.isEmpty) return null;
  final u = Uri.tryParse(s);
  return u != null && (u.scheme == 'https' || u.scheme == 'http') ? s : null;
}

/// An inline SVG QR code of [data].
String qrSvg(String data, {double size = 96}) {
  final image = QrImage(QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.M));
  final n = image.moduleCount;
  final b = StringBuffer();
  for (var r = 0; r < n; r++) {
    for (var c = 0; c < n; c++) {
      if (image.isDark(r, c)) b.write('M${c + 2},${r + 2}h1v1h-1z');
    }
  }
  final v = n + 4;
  return '<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" viewBox="0 0 $v $v" shape-rendering="crispEdges">'
      '<rect width="$v" height="$v" fill="#fff"/><path fill="#0E1220" d="$b"/></svg>';
}

String _date(Object? iso) {
  final d = DateTime.tryParse(iso as String? ?? '')?.toLocal();
  return d == null ? '' : DateFormat('d/M/yyyy – h:mm a').format(d);
}

num _n(Object? v) => (v as num?) ?? 0;

/// One HTML document with an invoice (or, [packingSlip], a packing slip
/// without prices) per order — A5 pages. [orders] are merchant_orders /
/// merchant_order rows (snapshot lines).
String ordersPrintHtml({required Map<String, dynamic> shop, required List<Map<String, dynamic>> orders, bool packingSlip = false}) {
  final logo = _safeUrl(shop['logo_url']);
  final shopName = shop['name'] as String? ?? '';
  final docs = StringBuffer();
  for (final o in orders) {
    final cur = (o['currency'] as String?) ?? currencyOf(shop);
    String m(num v) => _esc(money(v, cur));
    final items = List<Map<String, dynamic>>.from((o['items'] as List? ?? const []).map((i) => Map<String, dynamic>.from(i as Map)));
    final delivery = _n(o['delivery_fee']);
    final total = _n(o['total_amount']);
    final subtotal = total - delivery;
    final code = o['order_code'] as String?;
    final rows = StringBuffer();
    for (final i in items) {
      final qty = _n(i['quantity']);
      final price = _n(i['unit_price']);
      final img = _safeUrl(i['image_url']);
      final variant = (i['variant_label'] as String?)?.trim();
      rows.write('<tr><td class="p">');
      if (img != null) rows.write('<img class="thumb" src="${_esc(img)}" alt="">');
      rows.write('<div><b>${_esc(i['product_name'])}</b>');
      if (variant != null && variant.isNotEmpty) rows.write('<div class="muted">${_esc(variant)}</div>');
      rows.write('</div></td><td class="c">${_esc(qty)}</td>');
      if (packingSlip) {
        rows.write('<td class="c"><span class="box"></span></td>');
      } else {
        rows.write('<td class="n">${m(price)}</td><td class="n">${m(price * qty)}</td>');
      }
      rows.write('</tr>');
    }
    final phone = o['customer_phone'] as String?;
    docs.write('<section class="doc">');
    docs.write('<header><div class="shop">');
    if (logo != null) docs.write('<img class="logo" src="${_esc(logo)}" alt="">');
    docs.write('<div><div class="shop-name">${_esc(shopName)}</div>');
    final contact = [if (shop['address'] != null) shop['address'], if (shop['whatsapp'] != null) displayPhone(shop['whatsapp'] as String)].join(' • ');
    if (contact.isNotEmpty) docs.write('<div class="muted">${_esc(contact)}</div>');
    docs.write('</div></div><div class="title"><div class="kind">${packingSlip ? 'قائمة تجهيز' : 'فاتورة'}</div>');
    docs.write('<div class="code" dir="ltr">${_esc(code ?? '')}</div><div class="muted">${_esc(_date(o['created_at']))}</div></div></header>');

    docs.write('<div class="cols"><div class="box-info"><div class="label">الزبون</div><b>${_esc(o['customer_name'] ?? '—')}</b>');
    if (phone != null) docs.write('<div dir="ltr" class="phone">${_esc(displayPhone(phone))}</div>');
    docs.write('</div><div class="box-info grow"><div class="label">عنوان التوصيل</div><div class="addr">${_esc(o['delivery_address'] ?? '—')}</div></div></div>');

    docs.write('<table><thead><tr><th>المنتج</th><th class="c">الكمية</th>');
    docs.write(packingSlip ? '<th class="c">✓</th>' : '<th class="n">السعر</th><th class="n">الإجمالي</th>');
    docs.write('</tr></thead><tbody>$rows</tbody></table>');

    docs.write('<div class="foot"><div class="qr">');
    if (code != null) docs.write('${qrSvg(StoreService.trackUrl(code), size: 84)}<div class="muted">امسح وتابع طلبك</div>');
    docs.write('</div>');
    if (!packingSlip) {
      docs.write('<table class="totals"><tr><td>المنتجات</td><td class="n">${m(subtotal)}</td></tr>'
          '<tr><td>التوصيل</td><td class="n">${delivery == 0 ? 'مجاني' : m(delivery)}</td></tr>'
          '<tr class="grand"><td>الإجمالي</td><td class="n">${m(total)}</td></tr>'
          '<tr><td colspan="2" class="muted">الدفع: كاش عند الاستلام</td></tr></table>');
    } else {
      final pieces = items.fold<num>(0, (a, i) => a + _n(i['quantity']));
      docs.write('<div class="pieces">عدد القطع: <b>${_esc(pieces)}</b></div>');
    }
    docs.write('</div>');
    final note = (o['note'] as String?)?.trim();
    if (note != null && note.isNotEmpty) docs.write('<div class="note"><b>ملاحظة الزبون:</b> ${_esc(note)}</div>');
    docs.write('<div class="thanks">شكراً لطلبك من ${_esc(shopName)} 🌷</div>');
    docs.write('</section>');
  }
  final title = packingSlip ? 'قائمة تجهيز' : 'فاتورة';
  return '<!doctype html><html lang="ar" dir="rtl"><head><meta charset="utf-8"><title>${_esc(title)}</title><style>'
      '@page{size:A5 portrait;margin:9mm}'
      '*{box-sizing:border-box}body{margin:0;font-family:Tahoma,"Segoe UI",Arial,sans-serif;color:#0B0E12;font-size:12px;background:#fff}'
      '.doc{page-break-after:always;break-after:page;padding:2mm 0}.doc:last-child{page-break-after:auto;break-after:auto}'
      'header{display:flex;justify-content:space-between;align-items:flex-start;gap:12px;border-bottom:2px solid #1B3A6E;padding-bottom:8px;margin-bottom:10px}'
      '.shop{display:flex;gap:10px;align-items:center}.logo{width:46px;height:46px;border-radius:10px;object-fit:cover}'
      '.shop-name{font-size:16px;font-weight:800}.title{text-align:left}.kind{font-size:18px;font-weight:800;color:#1B3A6E}'
      '.code{font-weight:800;font-size:14px;letter-spacing:1px}.muted{color:#6B7085;font-size:10.5px}'
      '.cols{display:flex;gap:8px;margin-bottom:10px}.box-info{border:1px solid #E3E6EF;border-radius:8px;padding:6px 8px;min-width:30%}.grow{flex:1}'
      '.label{color:#6B7085;font-size:10px;margin-bottom:2px}.addr{white-space:pre-line;line-height:1.5}.phone{text-align:right}'
      'table{width:100%;border-collapse:collapse}th{background:#EEF1F8;font-size:11px;padding:6px;text-align:right}'
      'td{padding:6px;border-bottom:1px solid #EEF1F8;vertical-align:middle}.c{text-align:center}.n{text-align:left;white-space:nowrap}'
      'td.p{display:flex;gap:8px;align-items:center}.thumb{width:34px;height:34px;border-radius:6px;object-fit:cover}'
      '.box{display:inline-block;width:14px;height:14px;border:1.5px solid #0B0E12;border-radius:3px}'
      '.foot{display:flex;justify-content:space-between;align-items:flex-start;gap:12px;margin-top:10px}.qr{text-align:center}'
      '.totals{width:auto;min-width:46%}.totals td{border:0;padding:3px 6px}.grand td{font-size:14px;font-weight:800;border-top:1.5px solid #0B0E12}'
      '.pieces{font-size:13px}.note{margin-top:10px;padding:6px 8px;background:#FFF7EA;border-radius:8px}'
      '.thanks{margin-top:12px;text-align:center;color:#6B7085;font-size:11px}'
      '@media screen{body{background:#eee}.doc{background:#fff;width:148mm;min-height:200mm;margin:12px auto;padding:9mm;box-shadow:0 2px 14px rgba(0,0,0,.15)}}'
      '</style></head><body>$docs</body></html>';
}

/// The CSV of [orders] (UTF-8 with a BOM so Excel reads the Arabic).
String ordersCsv(List<Map<String, dynamic>> orders, {String? currency}) {
  String cell(Object? v) {
    var s = (v ?? '').toString().replaceAll('\r', ' ');
    // Formula injection: a cell never starts a formula in Excel.
    if (s.isNotEmpty && '=+-@\t'.contains(s[0])) s = "'$s";
    return '"${s.replaceAll('"', '""')}"';
  }

  const header = ['الكود', 'التاريخ', 'الحالة', 'الزبون', 'الموبايل', 'العنوان', 'المنتجات', 'عدد القطع', 'التوصيل', 'الإجمالي', 'العملة', 'الدفع', 'ملاحظة الزبون', 'ملاحظة داخلية', 'سبب الإلغاء'];
  final b = StringBuffer('﻿')..write(header.map(cell).join(','))..write('\r\n');
  for (final o in orders) {
    final items = (o['items'] as List? ?? const []).map((i) => Map<String, dynamic>.from(i as Map)).toList();
    final lines = items.map((i) {
      final v = (i['variant_label'] as String?)?.trim();
      return '${i['product_name']}${v != null && v.isNotEmpty ? ' ($v)' : ''} × ${i['quantity']}';
    }).join(' | ');
    final created = DateTime.tryParse(o['created_at'] as String? ?? '')?.toLocal();
    final phone = o['customer_phone'] as String?;
    b
      ..write([
        o['order_code'],
        created == null ? '' : DateFormat('yyyy-MM-dd HH:mm').format(created),
        orderStatusLabels[o['status']] ?? o['status'],
        o['customer_name'],
        // LRM: Excel keeps «+966…» as text, left-to-right.
        phone == null ? '' : '‎${displayPhone(phone)}',
        o['delivery_address'],
        lines,
        items.fold<num>(0, (a, i) => a + _n(i['quantity'])),
        _n(o['delivery_fee']),
        _n(o['total_amount']),
        o['currency'] ?? currency ?? '',
        'كاش عند الاستلام',
        o['note'],
        o['internal_note'],
        o['cancel_reason'],
      ].map(cell).join(','))
      ..write('\r\n');
  }
  return b.toString();
}
