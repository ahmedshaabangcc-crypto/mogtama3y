/// Ready-made products per shop activity: a new merchant adds them in one
/// tap and only fills in the prices (and photos when they like). Products
/// are added hidden with price 0 until the merchant prices them.
class StarterProduct {
  const StarterProduct(this.name, this.section, this.description, {this.highlights = const [], this.sizes = const [], this.image});
  final String name;
  final String section;
  final String description;
  final List<String> highlights;
  final List<String> sizes;

  /// Photo slug under web/catalog/ (free-licence CC0 / public-domain photos,
  /// credits in web/catalog/CREDITS.json). Served from the main site so every
  /// flavour (مُجتمعي / تاجر) can show it.
  final String? image;

  String? get imageUrl => image == null ? null : 'https://mogtama3y.com/catalog/$image.jpg';

  Map<String, dynamic> toRow(String shopId) => {
        'shop_id': shopId,
        'name': name,
        'category': section,
        'description': description,
        'highlights': highlights,
        'images': [?imageUrl],
        'image_url': imageUrl,
        'options': [
          if (sizes.isNotEmpty) {'name': 'الحجم', 'values': sizes},
        ],
        'price': 0,
        'is_available': false,
      };
}

const starterCatalog = <String, List<StarterProduct>>{
  'ألبان وأجبان': [
    StarterProduct('لبن كامل الدسم', 'ألبان', 'لبن طازة كامل الدسم، مناسب للشرب والطبخ والحلويات.', highlights: ['طازة يومياً', 'كامل الدسم'], sizes: ['½ لتر', '1 لتر'], image: 'milk'),
    StarterProduct('لبن خالي الدسم', 'ألبان', 'لبن خفيف خالي الدسم للي بيتبع رجيم.', highlights: ['خالي الدسم'], sizes: ['1 لتر'], image: 'skim-milk'),
    StarterProduct('زبادي طبيعي', 'ألبان', 'زبادي طبيعي كريمي، مفيد للهضم ومناسب للسلطات والصوصات.', highlights: ['قوام كريمي'], sizes: ['علبة', '6 علب'], image: 'yogurt'),
    StarterProduct('رايب', 'ألبان', 'رايب بلدي منعش، يتشرب ساقع.', sizes: ['½ لتر', '1 لتر'], image: 'buttermilk'),
    StarterProduct('جبنة بيضاء (فيتا)', 'أجبان', 'جبنة بيضاء طرية بطعم معتدل الملوحة، مثالية للفطار.', highlights: ['طرية', 'ملح معتدل'], sizes: ['¼ ك', '½ ك', '1 ك'], image: 'feta'),
    StarterProduct('جبنة إسطنبولي', 'أجبان', 'جبنة إسطنبولي بالشطة الخفيفة، طعمها مميز مع الطماطم.', sizes: ['¼ ك', '½ ك'], image: 'spicy-feta'),
    StarterProduct('جبنة قديمة (مش)', 'أجبان', 'جبنة قديمة معتّقة بطعم قوي للي بيحب الطعم البلدي.', sizes: ['¼ ك', '½ ك'], image: 'aged-cheese'),
    StarterProduct('جبنة رومي', 'أجبان', 'جبنة رومي ناشفة بطعم غني، تتقطع شرايح أو تتبشر.', highlights: ['معتّقة'], sizes: ['¼ ك', '½ ك'], image: 'roumy'),
    StarterProduct('جبنة شيدر', 'أجبان', 'شيدر بتسيح بسهولة، مناسبة للسندوتشات والبيتزا.', sizes: ['¼ ك', '½ ك'], image: 'cheddar'),
    StarterProduct('جبنة موتزاريلا', 'أجبان', 'موتزاريلا مبشورة للبيتزا والمكرونة بالفرن.', highlights: ['بتسيح بسهولة'], sizes: ['¼ ك', '½ ك'], image: 'mozzarella'),
    StarterProduct('جبنة نستو / مثلثات', 'أجبان', 'جبنة مثلثات كريمي للسندوتشات وشنطة المدرسة.', sizes: ['8 قطع', '16 قطعة'], image: 'cheese-triangles'),
    StarterProduct('قشطة', 'ألبان', 'قشطة طازة للفطار مع العسل أو للحلويات.', sizes: ['علبة صغيرة', 'علبة كبيرة'], image: 'cream'),
    StarterProduct('زبدة بلدي', 'ألبان', 'زبدة بلدي طبيعية للطبخ والفطير.', sizes: ['¼ ك', '½ ك'], image: 'butter'),
    StarterProduct('سمنة بلدي', 'ألبان', 'سمنة بلدي ريحتها حلوة للأكلات المصري.', sizes: ['½ ك', '1 ك'], image: 'ghee'),
    StarterProduct('بيض بلدي', 'بيض', 'بيض بلدي طازة.', sizes: ['10 بيضات', 'طبق 30'], image: 'brown-eggs'),
    StarterProduct('بيض أبيض', 'بيض', 'بيض أبيض طازة مقاسات متوسطة.', sizes: ['10 بيضات', 'طبق 30'], image: 'white-eggs'),
  ],
  'سوبر ماركت / بقالة': [
    StarterProduct('أرز مصري', 'بقالة', 'أرز مصري حبة متوسطة، بيطلع مفلفل.', sizes: ['1 ك', '5 ك'], image: 'rice'),
    StarterProduct('سكر أبيض', 'بقالة', 'سكر أبيض ناعم.', sizes: ['1 ك', '5 ك'], image: 'sugar'),
    StarterProduct('مكرونة', 'بقالة', 'مكرونة من دقيق القمح الصلب، أشكال مختلفة.', sizes: ['400 جم', '1 ك'], image: 'pasta'),
    StarterProduct('زيت عباد الشمس', 'بقالة', 'زيت طعام خفيف للطبخ والقلي.', sizes: ['1 لتر', '2.2 لتر'], image: 'oil'),
    StarterProduct('عدس أصفر', 'بقالة', 'عدس أصفر مقشور لشوربة العدس.', sizes: ['½ ك', '1 ك'], image: 'lentils'),
    StarterProduct('فول مدمس معلب', 'معلبات', 'فول مدمس جاهز للفطار.', sizes: ['علبة'], image: 'fava'),
    StarterProduct('تونة', 'معلبات', 'تونة قطع في زيت.', sizes: ['علبة'], image: 'tuna'),
    StarterProduct('صلصة طماطم', 'معلبات', 'صلصة طماطم مركزة للطبخ.', sizes: ['علبة صغيرة', 'علبة كبيرة'], image: 'tomato-paste'),
    StarterProduct('شاي أسود', 'مشروبات', 'شاي أسود ناعم بطعم مظبوط.', sizes: ['40 فتلة', '250 جم'], image: 'tea'),
    StarterProduct('بن قهوة', 'مشروبات', 'بن محوّج أو سادة.', sizes: ['100 جم', '250 جم'], image: 'coffee'),
    StarterProduct('مياه معدنية', 'مشروبات', 'مياه معدنية طبيعية.', sizes: ['½ لتر', '1.5 لتر', 'كرتونة'], image: 'water'),
    StarterProduct('مسحوق غسيل', 'منظفات', 'مسحوق غسيل للأوتوماتيك والعادي.', sizes: ['1 ك', '3 ك'], image: 'detergent'),
    StarterProduct('سائل أطباق', 'منظفات', 'سائل غسيل أطباق بيشيل الدهون.', sizes: ['½ لتر', '1 لتر'], image: 'dish-soap'),
    StarterProduct('مناديل', 'منزلية', 'مناديل ناعمة.', sizes: ['علبة', 'باكت 6'], image: 'tissues'),
  ],
  'لحوم ودواجن': [
    StarterProduct('لحمة بلدي (كندوز)', 'لحوم', 'لحمة كندوز طازة للطبخ والشوي.', highlights: ['دبيحة يومية'], sizes: ['½ ك', '1 ك'], image: 'beef'),
    StarterProduct('لحمة مفرومة', 'لحوم', 'لحمة مفرومة طازة للكفتة والمكرونة بالبشاميل.', sizes: ['½ ك', '1 ك'], image: 'minced-meat'),
    StarterProduct('كبدة', 'لحوم', 'كبدة طازة للإسكندراني.', sizes: ['½ ك', '1 ك'], image: 'liver'),
    StarterProduct('فراخ بيضاء كاملة', 'دواجن', 'فرخة بيضاء طازة متنضفة.', sizes: ['فرخة'], image: 'chicken'),
    StarterProduct('صدور فراخ', 'دواجن', 'صدور فراخ من غير عضم للبانيه والشيش.', sizes: ['½ ك', '1 ك'], image: 'chicken-breast'),
    StarterProduct('أوراك فراخ', 'دواجن', 'أوراك فراخ للشوي والفرن.', sizes: ['1 ك'], image: 'chicken-thighs'),
    StarterProduct('سجق بلدي', 'مصنعات', 'سجق بلدي متبّل.', sizes: ['½ ك', '1 ك'], image: 'sausage'),
    StarterProduct('برجر', 'مصنعات', 'برجر لحمة جاهز للشوي.', sizes: ['4 قطع', '8 قطع'], image: 'burger'),
  ],
  'عطارة / خضار وفاكهة': [
    StarterProduct('طماطم', 'خضار', 'طماطم طازة.', sizes: ['1 ك'], image: 'tomatoes'),
    StarterProduct('بطاطس', 'خضار', 'بطاطس للقلي والطبخ.', sizes: ['1 ك'], image: 'potatoes'),
    StarterProduct('بصل أحمر', 'خضار', 'بصل أحمر.', sizes: ['1 ك'], image: 'onions'),
    StarterProduct('خيار', 'خضار', 'خيار بلدي.', sizes: ['1 ك'], image: 'cucumbers'),
    StarterProduct('ليمون', 'خضار', 'ليمون بلدي.', sizes: ['½ ك', '1 ك'], image: 'lemons'),
    StarterProduct('موز', 'فاكهة', 'موز بلدي مستوي.', sizes: ['1 ك'], image: 'bananas'),
    StarterProduct('برتقال', 'فاكهة', 'برتقال للعصير والأكل.', sizes: ['1 ك'], image: 'oranges'),
    StarterProduct('تفاح', 'فاكهة', 'تفاح أحمر.', sizes: ['1 ك'], image: 'apples'),
    StarterProduct('كمون', 'عطارة', 'كمون مطحون.', sizes: ['50 جم', '100 جم'], image: 'cumin'),
    StarterProduct('فلفل أسود', 'عطارة', 'فلفل أسود مطحون.', sizes: ['50 جم', '100 جم'], image: 'pepper'),
    StarterProduct('بهارات مشكلة', 'عطارة', 'خلطة بهارات للطبيخ.', sizes: ['50 جم', '100 جم'], image: 'spices'),
  ],
  'حلويات ومخبوزات': [
    StarterProduct('عيش بلدي', 'مخبوزات', 'عيش بلدي طازة من الفرن.', sizes: ['5 أرغفة', '10 أرغفة'], image: 'baladi-bread'),
    StarterProduct('عيش فينو', 'مخبوزات', 'عيش فينو طري للسندوتشات.', sizes: ['5', '10'], image: 'fino'),
    StarterProduct('كرواسون', 'مخبوزات', 'كرواسون زبدة هش.', sizes: ['قطعة', '6 قطع'], image: 'croissant'),
    StarterProduct('بسبوسة', 'حلويات', 'بسبوسة بالسمنة والقطر.', sizes: ['¼ ك', '½ ك', '1 ك'], image: 'basbousa'),
    StarterProduct('كنافة', 'حلويات', 'كنافة بالمكسرات أو القشطة.', sizes: ['¼ ك', '½ ك', '1 ك'], image: 'kunafa'),
    StarterProduct('جاتوه', 'حلويات', 'قطع جاتوه بنكهات مختلفة.', sizes: ['قطعة', 'علبة 6'], image: 'pastry'),
    StarterProduct('تورتة', 'حلويات', 'تورتة للمناسبات حسب الطلب.', sizes: ['صغيرة', 'وسط', 'كبيرة'], image: 'cake'),
  ],
  'صيدلية / مستحضرات': [
    StarterProduct('مسكّن للصداع', 'أدوية بدون روشتة', 'مسكّن للصداع وآلام الجسم.', sizes: ['شريط'], image: 'painkiller'),
    StarterProduct('كمامات طبية', 'مستلزمات', 'كمامات طبية 3 طبقات.', sizes: ['10 قطع', 'علبة 50'], image: 'masks'),
    StarterProduct('كحول طبي', 'مستلزمات', 'كحول طبي للتعقيم.', sizes: ['125 مل', '500 مل'], image: 'alcohol'),
    StarterProduct('شاش ولاصق طبي', 'مستلزمات', 'شاش ولاصق للإسعافات الأولية.', image: 'bandage'),
    StarterProduct('كريم مرطب', 'عناية', 'كريم مرطب للبشرة الجافة.', sizes: ['صغير', 'كبير'], image: 'moisturizer'),
    StarterProduct('واقي شمس', 'عناية', 'واقي شمس للوجه.', sizes: ['50 مل'], image: 'sunscreen'),
    StarterProduct('حفاضات أطفال', 'أطفال', 'حفاضات بمقاسات مختلفة.', sizes: ['مقاس 3', 'مقاس 4', 'مقاس 5'], image: 'diapers'),
  ],
  'ملابس وأحذية': [
    StarterProduct('تيشيرت قطن', 'رجالي', 'تيشيرت قطن مريح للخروج والبيت.', highlights: ['قطن'], sizes: ['M', 'L', 'XL', 'XXL'], image: 'tshirt'),
    StarterProduct('بنطلون جينز', 'رجالي', 'جينز قصة مستقيمة.', sizes: ['30', '32', '34', '36'], image: 'jeans'),
    StarterProduct('قميص', 'رجالي', 'قميص كاجوال.', sizes: ['M', 'L', 'XL'], image: 'shirt'),
    StarterProduct('بلوزة', 'حريمي', 'بلوزة خفيفة.', sizes: ['S', 'M', 'L', 'XL'], image: 'blouse'),
    StarterProduct('عباية', 'حريمي', 'عباية خامة مريحة.', sizes: ['52', '54', '56', '58'], image: 'abaya'),
    StarterProduct('طقم أطفال', 'أطفال', 'طقم قطن للأطفال.', sizes: ['2 سنة', '4 سنين', '6 سنين'], image: 'kids-outfit'),
    StarterProduct('كوتشي', 'أحذية', 'كوتشي مريح للمشي.', sizes: ['40', '41', '42', '43', '44'], image: 'sneakers'),
    StarterProduct('شبشب', 'أحذية', 'شبشب للبيت.', sizes: ['40', '42', '44'], image: 'slippers'),
  ],
  'موبايلات وإكسسوارات': [
    StarterProduct('شاحن سريع', 'شواحن', 'شاحن سريع مع كابل.', sizes: ['Type-C', 'Lightning'], image: 'charger'),
    StarterProduct('كابل شحن', 'شواحن', 'كابل شحن قوي.', sizes: ['Type-C', 'Lightning', 'Micro USB'], image: 'cable'),
    StarterProduct('باور بانك', 'شواحن', 'باور بانك للطوارئ.', sizes: ['10000 مللي', '20000 مللي'], image: 'powerbank'),
    StarterProduct('سماعة بلوتوث', 'سماعات', 'سماعة لاسلكي بصوت واضح.', image: 'earbuds'),
    StarterProduct('سماعة سلك', 'سماعات', 'سماعة سلك بمايك.', image: 'earphones'),
    StarterProduct('جراب موبايل', 'حماية', 'جراب حماية للموبايل.', sizes: ['حسب الموديل'], image: 'phone-case'),
    StarterProduct('اسكرينة زجاج', 'حماية', 'اسكرينة زجاج ضد الكسر.', sizes: ['حسب الموديل'], image: 'screen-protector'),
  ],
  'مطعم / كافيه': [
    StarterProduct('ساندوتش فول', 'فطار', 'فول بالزيت والليمون في عيش بلدي.', image: 'ful-sandwich'),
    StarterProduct('ساندوتش طعمية', 'فطار', 'طعمية سخنة بالسلطة والطحينة.', image: 'falafel'),
    StarterProduct('طبق كشري', 'وجبات', 'كشري بالصلصة والدقة والتقلية.', sizes: ['صغير', 'وسط', 'كبير'], image: 'koshari'),
    StarterProduct('ساندوتش شاورما فراخ', 'وجبات', 'شاورما فراخ بالثومية.', sizes: ['عادي', 'كبير'], image: 'shawarma'),
    StarterProduct('وجبة فراخ مشوية', 'وجبات', 'ربع أو نص فرخة مشوية بالأرز والسلطة.', sizes: ['ربع', 'نص'], image: 'grilled-chicken'),
    StarterProduct('قهوة', 'مشروبات', 'قهوة تركي سادة أو مظبوط.', sizes: ['سادة', 'مظبوط', 'زيادة'], image: 'turkish-coffee'),
    StarterProduct('شاي', 'مشروبات', 'شاي بالنعناع أو سادة.', image: 'tea-cup'),
    StarterProduct('عصير فريش', 'مشروبات', 'عصير فاكهة طازة.', sizes: ['برتقال', 'مانجا', 'فراولة'], image: 'juice'),
  ],
  'أدوات منزلية': [
    StarterProduct('طقم حلل', 'مطبخ', 'طقم حلل للطبخ.', sizes: ['5 قطع', '7 قطع'], image: 'cookware'),
    StarterProduct('طاسة تيفال', 'مطبخ', 'طاسة مانعة للالتصاق.', sizes: ['24 سم', '28 سم'], image: 'frying-pan'),
    StarterProduct('طقم كوبايات', 'مطبخ', 'كوبايات زجاج.', sizes: ['6 قطع'], image: 'glasses'),
    StarterProduct('مكنسة وجاروف', 'تنظيف', 'مكنسة بيد طويلة وجاروف.', image: 'broom'),
    StarterProduct('مساحة أرضيات', 'تنظيف', 'مساحة بممسحة قطن.', image: 'mop'),
    StarterProduct('سلة غسيل', 'تخزين', 'سلة بلاستيك للغسيل.', image: 'laundry-basket'),
  ],
  'منظفات': [
    StarterProduct('مسحوق غسيل أوتوماتيك', 'غسيل', 'مسحوق للغسالات الأوتوماتيك.', sizes: ['1 ك', '3 ك', '6 ك'], image: 'detergent'),
    StarterProduct('منعم ملابس', 'غسيل', 'منعم بريحة حلوة.', sizes: ['1 لتر', '3 لتر'], image: 'softener'),
    StarterProduct('كلور', 'تنظيف', 'كلور للتطهير.', sizes: ['1 لتر', '3 لتر'], image: 'bleach'),
    StarterProduct('سائل أرضيات', 'تنظيف', 'منظف أرضيات معطّر.', sizes: ['1 لتر', '3 لتر'], image: 'floor-cleaner'),
    StarterProduct('سائل أطباق', 'مطبخ', 'سائل أطباق بيشيل الدهون.', sizes: ['½ لتر', '1 لتر'], image: 'dish-soap'),
    StarterProduct('صابون إيد', 'عناية', 'صابون سائل لليدين.', sizes: ['½ لتر'], image: 'hand-soap'),
  ],
};
