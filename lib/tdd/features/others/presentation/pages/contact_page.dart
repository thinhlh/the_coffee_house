import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:the/utils/const.dart';
import 'package:the/utils/values/dimens.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ContactPage extends StatelessWidget {
  static const routeName = '/contact_page';

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      color: Colors.black.withOpacity(0.4),
      indent: 20,
      thickness: 0.5,
      height: 0,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Liên hệ'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: AppDimens.MEDIUM_PADDING),
        child: ListView(
          children: [
            ListTile(
              tileColor: Colors.white,
              onTap: () => UrlLauncher.launch('tel:02871087088'),
              leading: Icon(
                Icons.phone_forwarded,
                color: AppColors.PRIMARY_COLOR,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text(
                'Tổng đài',
                style: TextStyle(
                  fontSize: AppDimens.SMALL_TEXT_SIZE,
                ),
              ),
              subtitle: Text(
                '02871087088',
                style: TextStyle(
                  fontSize: AppDimens.SMALL_TEXT_SIZE,
                ),
              ),
            ),
            divider,
            ListTile(
              onTap: () => UrlLauncher.launch('mailto:hi@thecoffeehouse.vn'),
              tileColor: Colors.white,
              leading: Icon(
                Icons.email,
                color: AppColors.PRIMARY_COLOR,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text(
                'Email',
                style: TextStyle(
                  fontSize: AppDimens.SMALL_TEXT_SIZE,
                ),
              ),
              subtitle: Text(
                'hi@thecoffeehouse.vn',
                style: TextStyle(
                  fontSize: AppDimens.SMALL_TEXT_SIZE,
                ),
              ),
            ),
            divider,
            ListTile(
              onTap: () => UrlLauncher.launch('https://www.thecoffeehouse.com'),
              tileColor: Colors.white,
              leading: Icon(
                Icons.public,
                color: AppColors.PRIMARY_COLOR,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text(
                'Website',
                style: TextStyle(
                  fontSize: AppDimens.SMALL_TEXT_SIZE,
                ),
              ),
              subtitle: Text(
                'www.thecoffeehouse.com',
                style: TextStyle(
                  fontSize: AppDimens.SMALL_TEXT_SIZE,
                ),
              ),
            ),
            divider,
            ListTile(
              onTap: () {
                UrlLauncher.canLaunch('fb://page/The.Coffee.House.2014').then(
                  (value) => value
                      ? UrlLauncher.launch('fb://page/The.Coffee.House.2014')
                      : UrlLauncher.launch(
                          'https://www.facebook.com/The.Coffee.House.2014'),
                );
              },
              tileColor: Colors.white,
              leading: Icon(
                FlutterIcons.facebook_f_faw,
                color: AppColors.PRIMARY_COLOR,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text(
                'Facebook',
                style: TextStyle(
                  fontSize: AppDimens.SMALL_TEXT_SIZE,
                ),
              ),
              subtitle: FittedBox(
                child: Text(
                  'facebook.com/The.Coffee.House.2014',
                  style: TextStyle(
                    fontSize: AppDimens.SMALL_TEXT_SIZE,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
