import 'package:flutter/foundation.dart';

import 'package:the_coffee_house/models/coupon.dart';

class Coupons with ChangeNotifier {
  List<Coupon> _coupons = [
    Coupon(
      code: 'NHATINHTE',
      title: 'MUA 2 TẶNG 1',
      expiryDate: DateTime(2021, 4, 15),
      conditions: [
        'Ưu đãi 15% cho đơn hàng delivery (giao tận nơi)',
        'Áp dụng cho sản phẩm bánh, nước, snack. Không áo dụng cho cà phê gói, topping, merhandise & các loại combo',
        'Ưu đãi áp dụng cho thành viên Vàng thăng hạn trước ngày 01/04/2021. Ưu đãi 5 lần/khách hàng.',
        'Không áp dụng cho các chương trình khuyến mãi song song',
      ],
      imageUrl:
          'https://scontent.fvca1-1.fna.fbcdn.net/v/t1.6435-9/p843x403/158686470_2929913937282613_1416430830885915022_n.jpg?_nc_cat=103&ccb=1-3&_nc_sid=730e14&_nc_ohc=Vlfibo7KPJIAX_cU1IP&_nc_oc=AQmWUkrSvVkm8OMyZCxI2T-qWDJWLN4DEyZBuG5aZS4a1hbqgp-t3_sq5xAY9z7Wp8w&_nc_ht=scontent.fvca1-1.fna&tp=6&oh=5ff95e0ab601159b8070941816192dc1&oe=609588C5',
    ),
    Coupon(
      code: '2MON30',
      conditions: [],
      title:
          'Ưu đãi Giảm 30% cho 2 món bất kỳ khi đặt Pickup (Tự đến lấy) và giảm tối đa 30K.',
      expiryDate: DateTime(2021, 4, 17),
      imageUrl:
          'https://scontent-hkg4-1.xx.fbcdn.net/v/t1.6435-9/s960x960/159626168_2926768614263812_6906778044260583516_n.jpg?_nc_cat=106&ccb=1-3&_nc_sid=730e14&_nc_ohc=9SQ1dC9xqmsAX8i_N-h&_nc_ht=scontent-hkg4-1.xx&tp=7&oh=c39d599940d24181c3819ca2c0d1fff1&oe=60974D1B',
    ),
    Coupon(
      code: 'UUDAI40',
      conditions: [],
      title: 'Ưu đãi 40% khi gọi 2 ly size lớn nhất (giảm tối đa 40K).',
      expiryDate: DateTime(2021, 4, 19),
      imageUrl:
          'https://scontent-hkg4-1.xx.fbcdn.net/v/t1.6435-0/p600x600/162334706_2935601076713899_3893287957765078058_n.jpg?_nc_cat=106&ccb=1-3&_nc_sid=730e14&_nc_ohc=jEhbOUeUWscAX8eqorN&_nc_ht=scontent-hkg4-1.xx&tp=6&oh=dc8fef2dbd1ac4eeb744c65088c5b11b&oe=60949367',
    ),
    Coupon(
      code: 'UUDAI15GOLD',
      conditions: [],
      title: 'Ưu đãi 15% cho Thành Viên Vàng',
      expiryDate: DateTime(2021, 4, 23),
      imageUrl:
          'https://scontent.fsgn5-5.fna.fbcdn.net/v/t1.6435-9/155538443_2921185468155460_1747661102750345092_n.jpg?_nc_cat=108&ccb=1-3&_nc_sid=730e14&_nc_ohc=iX_wHZ0MwmQAX8WmQfh&_nc_ht=scontent.fsgn5-5.fna&oh=297aba307254311b207d181b62daaf00&oe=609822F0',
    ),
    Coupon(
      code: 'HOICHIEM',
      conditions: [],
      title: 'Deal diệu kỳ\nMời hội chị em so đẹp',
      expiryDate: DateTime(2021, 4, 25),
      imageUrl:
          'https://scontent.fsgn5-4.fna.fbcdn.net/v/t1.6435-9/158036766_2922357188038288_6049075286111300929_n.jpg?_nc_cat=102&ccb=1-3&_nc_sid=730e14&_nc_ohc=pcxChCYFz4sAX8IpEB0&_nc_ht=scontent.fsgn5-4.fna&oh=97db641da490332a43c4eb579857ea60&oe=60973F18',
    ),
    Coupon(
      code: 'SATCANH50',
      conditions: [],
      title: 'ƯU đãi 50%',
      expiryDate: DateTime(2021, 4, 18),
      imageUrl:
          'https://scontent.fsgn5-6.fna.fbcdn.net/v/t1.6435-9/153138786_2913336452273695_867779383046930026_n.jpg?_nc_cat=109&ccb=1-3&_nc_sid=730e14&_nc_ohc=j-MbM5Nrth8AX9SPqYY&_nc_ht=scontent.fsgn5-6.fna&oh=a6a706aa5aac9d011c338b177e0a0ecf&oe=609A9BA1',
    ),
  ];

  List<Coupon> get coupons => [..._coupons];

  List<Coupon> get firstThreeCoupons => _coupons.length < 3
      ? _coupons.sublist(0, _coupons.length)
      : _coupons.sublist(0, 3);
}
