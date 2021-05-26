import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/store.dart';

class Stores with ChangeNotifier {
  List<Store> _stores = [
    Store(
      street: '86 Cao Thắng',
      district: 'Quận 3',
      city: 'Hồ Chí Minh',
      location: LatLng(10.771291878774353, 106.68106218194482),
      imageUrls: [
        'https://file.hstatic.net/1000075078/file/store_lhp_vt_master.jpg',
        'https://file.hstatic.net/1000075078/file/store_pvt2_master.jpg',
        'https://file.hstatic.net/1000075078/file/store_xuanla_hn_master.jpg',
      ],
    ),
    Store(
      street: '798 Sư Vạn Hạnh',
      district: 'Quận 10',
      city: 'Hồ Chí Minh',
      location: LatLng(10.77420964819986, 106.66849804016307),
      imageUrls: [
        'https://file.hstatic.net/1000075078/file/3e0a8783_master.jpg',
        'https://file.hstatic.net/1000075078/file/store_caudat_hp_master.jpg',
      ],
    ),
    Store(
      street: '141 Nguyễn Thái Bình',
      district: 'Quận 1',
      city: 'Hồ Chí Minh',
      location: LatLng(10.768526189983133, 106.69884304016306),
      imageUrls: [
        'https://file.hstatic.net/1000075078/file/sun_avenue_-_dmh05951_7edb233258314fca82c5e19dd217696d_1024x1024.jpg',
        'https://file.hstatic.net/1000075078/file/cao_thang_2_-_img_3660_2583ad32f0f449ab94e2dd8d490162fa_1024x1024.jpg',
      ],
    ),
    Store(
      street: '798 Sư Vạn Hạnh',
      district: 'Quận 10',
      city: 'Hồ Chí Minh',
      location: LatLng(10.77420964819986, 106.66849804016307),
      imageUrls: [
        'https://file.hstatic.net/1000075078/file/3e0a8783_master.jpg',
        'https://file.hstatic.net/1000075078/file/store_caudat_hp_master.jpg',
      ],
    ),
    Store(
      street: '86 Cao Thắng',
      district: 'Quận 3',
      city: 'Hồ Chí Minh',
      location: LatLng(10.771291878774353, 106.68106218194482),
      imageUrls: [
        'https://file.hstatic.net/1000075078/file/store_lhp_vt_master.jpg',
        'https://file.hstatic.net/1000075078/file/store_pvt2_master.jpg',
        'https://file.hstatic.net/1000075078/file/store_xuanla_hn_master.jpg',
      ],
    ),
    Store(
      street: '141 Nguyễn Thái Bình',
      district: 'Quận 1',
      city: 'Hồ Chí Minh',
      location: LatLng(10.768526189983133, 106.69884304016306),
      imageUrls: [
        'https://file.hstatic.net/1000075078/file/sun_avenue_-_dmh05951_7edb233258314fca82c5e19dd217696d_1024x1024.jpg',
        'https://file.hstatic.net/1000075078/file/cao_thang_2_-_img_3660_2583ad32f0f449ab94e2dd8d490162fa_1024x1024.jpg',
      ],
    ),
  ];

  List<Store> get store => [..._stores];
}
