import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../utils/const.dart' as Constant;

class ContactScreen extends StatelessWidget {
  static const routeName = '/contact_screen';

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
        padding: const EdgeInsets.only(top: Constant.GENERAL_PADDING),
        child: ListView(
          children: [
            ListTile(
              tileColor: Colors.white,
              onTap: () => UrlLauncher.launch('tel:02871087088'),
              leading: Icon(
                Icons.phone_forwarded,
                color: Theme.of(context).accentColor,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text('Tổng đài'),
              subtitle: Text('02871087088'),
            ),
            divider,
            ListTile(
              onTap: () => UrlLauncher.launch('mailto:hi@thecoffeehouse.vn'),
              tileColor: Colors.white,
              leading: Icon(
                Icons.email,
                color: Theme.of(context).accentColor,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text('Email'),
              subtitle: Text('hi@thecoffeehouse.vn'),
            ),
            divider,
            ListTile(
              onTap: () => UrlLauncher.launch('https://www.thecoffeehouse.com'),
              tileColor: Colors.white,
              leading: Icon(
                Icons.public,
                color: Theme.of(context).accentColor,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text('Website'),
              subtitle: Text('www.thecoffeehouse.com'),
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
                color: Theme.of(context).accentColor,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text('Facebook'),
              subtitle: Text('facebook.com/The.Coffee.House.2014'),
            )
          ],
        ),
      ),
    );
  }
}
