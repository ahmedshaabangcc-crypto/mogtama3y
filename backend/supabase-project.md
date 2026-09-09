# مشروع Supabase — مُجتمعي

## بيانات المشروع
- **اسم المنظمة (Organization):** Mojtama3y
- **اسم المشروع:** mojtama3y
- **المنطقة (Region):** Central EU (Frankfurt) — eu-central-1 (أقرب نقطة أوروبية لمصر/الشرق الأوسط)
- **الخطة:** Free ($0/شهر)
- **رابط لوحة التحكم:** https://supabase.com/dashboard/project/pxiabifybakbsqlycffc

## مفاتيح الربط (تُستخدم في تطبيق Flutter)
```
SUPABASE_URL=https://pxiabifybakbsqlycffc.supabase.co
SUPABASE_PUBLISHABLE_KEY=sb_publishable_3QS4C4PPUUCZuvjUi8Ifmg_EJ44uxhE
```

هذان القيمتان آمنتان للاستخدام داخل تطبيق العميل (Flutter) طالما Row Level Security (RLS) مفعّل على كل الجداول.

## إعدادات الأمان المفعّلة عند الإنشاء
- **Enable Data API:** مفعّل (لتوليد REST API تلقائي)
- **Automatically expose new tables:** **معطّل عمداً** — يعني أي جدول جديد مايبقاش متاح للـ API إلا لو سمحنا له صراحةً. مهم جداً في تطبيق فيه بيانات مالية.
- **Enable automatic RLS:** **مفعّل** — أي جدول جديد يتفعّل عليه Row Level Security تلقائياً، فمايبقاش مكشوف بالغلط قبل ما نكتب الـ policies بتاعته.

## ملاحظات أمان مهمة
- الـ **Secret key** (sb_secret_...) **لا يوضع أبداً داخل كود Flutter أو أي كود عميل**. يُستخدم فقط في Edge Functions أو سكريبتات سيرفر منفصلة (مثلاً معالجة Escrow، أو Webhooks من بوابة الدفع).
- كلمة مرور قاعدة البيانات (DB password) تم توليدها تلقائياً بواسطة Supabase عند الإنشاء ومحفوظة في نظامهم — لو احتجنا نتصل مباشرة بـ Postgres (psql / migrations CLI) لاحقاً، يمكن إعادة تعيينها من: Project Settings → Database.
- هذا الملف يحتوي على مفتاح publishable فقط (آمن للمشاركة)، لكن يُفضّل عدم رفعه لأي مستودع Git عام لاحقاً لتفادي أي التباس — الأفضل نقل هذه القيم لملف `.env` محلي غير متتبَّع (untracked) بمجرد ما نبدأ مشروع Flutter الفعلي.

## الخطوة التالية
بناء هيكلة قاعدة البيانات (الجداول والعلاقات) بناءً على الشاشات المستلمة من Stitch:
اتحاد الملاك، المستخدمين والوحدات السكنية، المحفظة والمعاملات المالية (Escrow)، سوق المستعمل، سوق الفنيين، البيكيا، الوظائف، التصويت والجمعية العمومية، المفقودات، الأمان (QR Pass)، المحلات.
