import 'package:flutter/widgets.dart' as widget;
import 'package:the_coffee_house/models/notification.dart';

class Notifications with widget.ChangeNotifier {
  final List<Notification> _notifications = [
    Notification(
      id: DateTime.now().toString(),
      title: 'Đổi BEAN lấy quà xịn ngay nào',
      description:
          'Chương trình khách hàng thân thiết - The Coffee House Rewards cập nhật thêm nhiều ưu đãi hấp dẫn, đa tiện ích: giải trí, mua sắm, ăn uống,... Đặc biệt, kéo dài thời gian đổi BEAN thêm 3 tháng. Kiểm tra mục Rewards và tận hưởng ưu đãi đặc quyền ngay hôm nay.',
      dateTime: DateTime.now(),
      imageUrl:
          'https://file.hstatic.net/1000075078/file/uudau3-01_8d653a254235408d9dbc06aefe6234ee.jpg',
    ),
    Notification(
      id: DateTime.now().toString(),
      title: 'MUA 2 TẶNG 1!',
      description:
          'Ghé Nhà Peakview - mang món bạn yêu về thôi!\nDù cuộc hẹn rôm rả gần nhau tạm gác lại, nhưng từ ngày 01/03 này - Nhà mới Peakview vẫn sẽ khai trương phục vụ mua mang về (Take away) với ưu đãi MUA 2 TẶNG 1 (áp dụng từ ngày 02/03 - 05/03), để bạn ghé thưởng thức món yêu thích 1 cách nhanh và an toàn nhất đó nha!',
      dateTime: DateTime.now(),
      imageUrl:
          'https://file.hstatic.net/1000075078/file/uudau3-01_8d653a254235408d9dbc06aefe6234ee.jpg',
    ),
    Notification(
      id: DateTime.now().toString(),
      title: 'Ở nhà vui khoẻ, gọi món tận nơi. Nhà mời 50% nhé!',
      description:
          'Hết mùng còn tết, Nhà hiểu bạn đang chăm chỉ học online, làm việc tại gia mà vẫn thèm “món ruột” nên Nhà mời 50% ngay khi bạn nhập mã SATCANH50 qua app The Coffee House, cho đơn hàng 2 món yêu thích size lớn nhất nè.\nBạn cứ việc ở nhà làm việc chăm chỉ, giữ gìn sức khoẻ. Món ngon đã có Nhà mang đến tận nơi nha. Mở app chọn món yêu thích, shipper Nhà mang tới trong 30 phút ngay.',
      dateTime: DateTime.now(),
      imageUrl:
          'https://file.hstatic.net/1000075078/file/uudau3-01_8d653a254235408d9dbc06aefe6234ee.jpg',
    ),
    Notification(
        id: DateTime.now().toString(),
        title: '“Sếp Nhà” chơi lớn. Mời team đi làm sớm 50%',
        description:
            'Còn mùng là còn Tết, còn được sếp Nhà lì xì từ tận 50% - áp dụng cho 2 ly size lớn nhất và nhập mã TANNIEN50 qua app nè. Biết team đi làm sớm bánh chưng, thịt kho hột vịt còn đè, dư âm ngày Tết cũng chưa thể nguôi ngoai - nên món yêu thích để giải nhiệt, giải “lag" sau tết đã luôn sẵn sàng rồi đấy',
        dateTime: DateTime.now(),
        imageUrl:
            'https://file.hstatic.net/1000075078/file/banneuudai-11_b48c093d94954d44a44a5970e21c053a.png'),
    Notification(
        id: DateTime.now().toString(),
        title: 'Xông App đầu năm',
        description:
            'Nhà mời 35% khi nhập mã TANNIEN35\nNghỉ Tết 4 ngày mà shipper Nhà đã nhớ bạn rồi, nên ngày 15/02 (mùng 4 Tết) sẽ trở lại - để mang “món ruột" đến tận nơi chỉ với 30 phút như mọi ngày nhé vì shipper Nhà nôn nóng lắm rồi bạn ơi!  \nĐừng quên nhập mã TANNIEN35 để nhận lì xì 35% cho đơn hàng 5 món yêu thích bất kỳ. Bánh ngon, nước mát và snack giòn luôn sẵn sàng để cùng bạn đón Tết trọn vẹn rôm rả rồi nè. ',
        dateTime: DateTime.now(),
        imageUrl:
            'https://file.hstatic.net/1000075078/file/banneuudai-11_b48c093d94954d44a44a5970e21c053a.png'),
  ];

  List<Notification> get notifications => [..._notifications];
}
