import 'package:flutter/foundation.dart';

import '../models/coupon.dart';

class Coupons with ChangeNotifier {
  List<Coupon> _coupons = [
    Coupon(
      code: 'NHATINHTE',
      title: 'MUA 2 TẶNG 1',
      expiryDate: DateTime(2021, 6, 22),
      conditions: [
        'Ưu đãi 15% cho đơn hàng delivery (giao tận nơi)',
        'Áp dụng cho sản phẩm bánh, nước, snack. Không áo dụng cho cà phê gói, topping, merhandise & các loại combo',
        'Ưu đãi áp dụng cho thành viên Vàng thăng hạn trước ngày 01/04/2021. Ưu đãi 5 lần/khách hàng.',
        'Không áp dụng cho các chương trình khuyến mãi song song',
      ],
      imageUrl:
          'https://scontent.fsgn5-6.fna.fbcdn.net/v/t1.6435-9/183946537_2979277092346297_4904299199711006753_n.jpg?_nc_cat=109&ccb=1-3&_nc_sid=730e14&_nc_ohc=lrHNwSNj9tYAX8w-TQS&_nc_ht=scontent.fsgn5-6.fna&oh=2f6a9a01fd8f9bf5fb0ad7575263d4d3&oe=60D3B645',
    ),
    Coupon(
      code: '2MON30',
      conditions: [
        'Ưu đãi 2 món 30% cho đơn hàng delivery (giao tận nơi)',
        'Áp dụng cho sản phẩm bánh, nước, snack. Không áo dụng cho cà phê gói, topping, merhandise & các loại combo',
        'Ưu đãi áp dụng cho thành viên Vàng thăng hạn trước ngày 01/04/2021. Ưu đãi 5 lần/khách hàng.',
        'Không áp dụng cho các chương trình khuyến mãi song song',
      ],
      title:
          'Ưu đãi Giảm 30% cho 2 món bất kỳ khi đặt Pickup (Tự đến lấy) và giảm tối đa 30K.',
      expiryDate: DateTime(2021, 5, 27),
      imageUrl:
          'https://scontent-sin6-1.xx.fbcdn.net/v/t1.6435-9/186501568_2977289765878363_2377373563791239103_n.jpg?_nc_cat=107&ccb=1-3&_nc_sid=730e14&_nc_ohc=pbHoZYfbvtsAX9Ogvnl&_nc_ht=scontent-sin6-1.xx&oh=2dd67c7d37843c8daf00a22703f0a648&oe=60D36105',
    ),
    Coupon(
      code: 'UUDAI50',
      conditions: [
        'Ưu đãi 50% cho đơn hàng delivery (giao tận nơi)',
        'Áp dụng cho sản phẩm bánh, nước, snack. Không áo dụng cho cà phê gói, topping, merhandise & các loại combo',
        'Ưu đãi áp dụng cho thành viên Vàng thăng hạn trước ngày 01/04/2021. Ưu đãi 5 lần/khách hàng.',
        'Không áp dụng cho các chương trình khuyến mãi song song',
      ],
      title: 'Ưu đãi 50% khi gọi 2 ly size lớn nhất (giảm tối đa 50K).',
      expiryDate: DateTime(2021, 6, 4),
      imageUrl:
          'https://scontent.fsgn5-6.fna.fbcdn.net/v/t1.6435-9/174264073_2955803258027014_5848573941274479812_n.jpg?_nc_cat=106&ccb=1-3&_nc_sid=730e14&_nc_ohc=st_LdzFYPv4AX8yaNtC&_nc_ht=scontent.fsgn5-6.fna&oh=d752eb012ef2b7ae7fcc01a14d07e137&oe=60D21CE5',
    ),
    Coupon(
      code: 'UUDAI40GOLD',
      conditions: [
        'Ưu đãi 40% cho đơn hàng delivery (giao tận nơi)',
        'Áp dụng cho sản phẩm bánh, nước, snack. Không áo dụng cho cà phê gói, topping, merhandise & các loại combo',
        'Ưu đãi áp dụng cho thành viên Vàng thăng hạn trước ngày 01/04/2021. Ưu đãi 5 lần/khách hàng.',
        'Không áp dụng cho các chương trình khuyến mãi song song',
      ],
      title: 'Ưu đãi 40% cho Thành Viên Vàng',
      expiryDate: DateTime(2021, 8, 10),
      imageUrl:
          'https://scontent-sin6-2.xx.fbcdn.net/v/t1.6435-9/168539948_2945877402352933_2457515249078356851_n.jpg?_nc_cat=102&ccb=1-3&_nc_sid=730e14&_nc_ohc=KKo0LuqT2HQAX9fCEW-&_nc_ht=scontent-sin6-2.xx&oh=e5578f1ca7458787c50106f7f85ae4af&oe=60D4809C',
    ),
    Coupon(
      code: 'HOICHIEM',
      conditions: [],
      title: 'Deal diệu kỳ\nMời hội chị em so đẹp',
      expiryDate: DateTime(2021, 6, 26),
      imageUrl:
          'https://scontent.fsgn5-1.fna.fbcdn.net/v/t1.6435-9/169070271_2948397962100877_1276878859948122394_n.jpg?_nc_cat=101&ccb=1-3&_nc_sid=730e14&_nc_ohc=Kji8CHGjf3cAX8Mdgbo&_nc_ht=scontent.fsgn5-1.fna&oh=44730127996cf0639ef136664c5f9815&oe=60D22CAF',
    ),
    Coupon(
      code: 'SATCANH50',
      conditions: [
        'Ưu đãi 50% cho đơn hàng delivery (giao tận nơi)',
        'Áp dụng cho sản phẩm bánh, nước, snack. Không áo dụng cho cà phê gói, topping, merhandise & các loại combo',
        'Ưu đãi áp dụng cho thành viên Vàng thăng hạn trước ngày 01/04/2021. Ưu đãi 5 lần/khách hàng.',
        'Không áp dụng cho các chương trình khuyến mãi song song',
      ],
      title: 'ƯU đãi 50%',
      expiryDate: DateTime(2021, 6, 18),
      imageUrl:
          'https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.6435-9/177609385_2965181790422494_1936114340236207428_n.jpg?_nc_cat=105&ccb=1-3&_nc_sid=730e14&_nc_ohc=Fo1Cc-zF1uwAX-7iR2x&_nc_ht=scontent.fsgn5-2.fna&oh=40931061c415c70b1a3ffd36ca51b759&oe=60D344EC',
    ),
  ];

  List<Coupon> get coupons => [..._coupons];

  List<Coupon> get firstThreeCoupons => _coupons.length < 3
      ? _coupons.sublist(0, _coupons.length)
      : _coupons.sublist(0, 3);

  List<Coupon> get nearlyOutOfDate => _coupons
      .where((element) =>
          element.expiryDate.difference(DateTime.now()).inDays <= 7)
      .toList();
}
