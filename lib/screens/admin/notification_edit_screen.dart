import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the/models/category.dart';
import 'package:the/providers/categories.dart';

import '../../models/membership.dart';
import '../../models/notification.dart' as model;
import '../../providers/notifications.dart';
import '../../utils/const.dart' as Constant;

class NotificationEditScreen extends StatefulWidget {
  final String id;
  NotificationEditScreen(this.id);

  @override
  _NotificationEditScreenState createState() => _NotificationEditScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _NotificationEditScreenState extends State<NotificationEditScreen> {
  List<bool> targettedCustomer = List.filled(4, false);
  model.Notification currentNotification = model.Notification.initialize();

  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController imageController;

  File imageFile;
  bool isChoosingImageFromLocal = false;
  String imageUrl;

  void pickImage() async {
    final PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    } else {
      setState(() {
        imageFile = File(pickedFile.path);
        isChoosingImageFromLocal = true;
      });
    }
  }

  void onChangedOrSubmitUrl() {
    setState(() {
      imageUrl = imageController.text;
      isChoosingImageFromLocal = false;
    });
  }

  @override
  void initState() {
    if (widget.id == null) {
      currentNotification = model.Notification(
        id: null,
        title: null,
        description: null,
        imageUrl: null,
        dateTime: null,
        targetCustomers: [],
      );
    } else {
      currentNotification = Provider.of<Notifications>(context, listen: false)
          .getNotificationById(widget.id);
      currentNotification.targetCustomers.forEach((element) {
        switch (element) {
          case Membership.Bronze:
            targettedCustomer[0] = true;
            break;
          case Membership.Silver:
            targettedCustomer[1] = true;
            break;
          case Membership.Gold:
            targettedCustomer[2] = true;
            break;
          case Membership.Diamond:
            targettedCustomer[3] = true;
            break;
        }
      });
    }
    titleController =
        TextEditingController(text: currentNotification.title ?? '');
    descriptionController =
        TextEditingController(text: currentNotification.description ?? '');

    imageController =
        TextEditingController(text: currentNotification.imageUrl ?? '');
    imageUrl = currentNotification.imageUrl ?? '';

    super.initState();
  }

  void save() async {
    if (!_formKey.currentState.validate()) return;
    if ((imageUrl == null || imageUrl.isEmpty) && imageFile == null) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('No Image'),
          content: Text('You must provide notification image'),
          actions: [
            CupertinoDialogAction(
              child: Text('Okay'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
      return;
    }

    _formKey.currentState.save();

    List<Membership> targetCustomer = [];
    if (targettedCustomer[0]) targetCustomer.add(Membership.Bronze);
    if (targettedCustomer[1]) targetCustomer.add(Membership.Silver);
    if (targettedCustomer[2]) targetCustomer.add(Membership.Gold);
    if (targettedCustomer[3]) targetCustomer.add(Membership.Diamond);

    if (targetCustomer.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('No Target Customer'),
          content: Text('You must specify at least 1 target customer'),
          actions: [
            CupertinoDialogAction(
              child: Text('Okay'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    model.Notification newNotification = model.Notification(
      id: currentNotification.id,
      title: titleController.text,
      description: descriptionController.text,
      imageUrl: isChoosingImageFromLocal ? imageFile.path : imageUrl,
      targetCustomers: targetCustomer,
      dateTime: DateTime.now(),
    );
    if (currentNotification.id != null) {
      // id is not null => this is the update form
      await context.read<Notifications>().updateNotification(
            newNotification,
            isChoosingImageFromLocal,
          );
    } else {
      // id is null => this is add form
      await context.read<Notifications>().addNotification(
            newNotification,
            isChoosingImageFromLocal,
          );
    }
    setState(() => isLoading = false);
    Navigator.of(context).pop();
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? 'Add Notification' : currentNotification.title,
        ),
        actions: [
          IconButton(
            onPressed: save,
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(Constant.GENERAL_PADDING * 2),
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(
                        FlutterIcons.title_mdi,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 2,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        value.isEmpty ? 'Title cannot be empty' : null,
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    validator: (value) =>
                        value.isEmpty ? 'Description cannot be empty' : null,
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  TextFormField(
                    controller: imageController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Image Url',
                      isDense: true,
                    ),
                    onEditingComplete: onChangedOrSubmitUrl,
                    onChanged: (value) => onChangedOrSubmitUrl(),
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FilterChip(
                        label: Text('Bronze'),
                        showCheckmark: false,
                        selectedColor: Colors.brown[400],
                        selected: targettedCustomer[0],
                        onSelected: (value) {
                          setState(() {
                            targettedCustomer[0] = value;
                          });
                        },
                      ),
                      FilterChip(
                        showCheckmark: false,
                        label: Text('Silver'),
                        selectedColor: Colors.grey,
                        selected: targettedCustomer[1],
                        onSelected: (value) {
                          setState(() {
                            targettedCustomer[1] = value;
                          });
                        },
                      ),
                      FilterChip(
                        showCheckmark: false,
                        label: Text('Gold'),
                        selectedColor: Colors.amber,
                        selected: targettedCustomer[2],
                        onSelected: (value) {
                          setState(() {
                            targettedCustomer[2] = value;
                          });
                        },
                      ),
                      FilterChip(
                        showCheckmark: false,
                        label: Text('Diamond'),
                        selectedColor: Colors.cyan,
                        selected: targettedCustomer[3],
                        onSelected: (value) {
                          setState(() {
                            targettedCustomer[3] = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.black87)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Constant.GENERAL_PADDING,
                        ),
                        child: Text("OR"),
                      ),
                      Expanded(child: Divider(color: Colors.black87)),
                    ],
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT / 2),
                  Center(
                    child: ElevatedButton(
                      child: Text('Pick Image'),
                      onPressed: pickImage,
                    ),
                  ),
                  SizedBox(
                    height: Constant.SIZED_BOX_HEIGHT,
                  ),
                  Builder(builder: (_) {
                    if (imageFile == null && imageUrl == null) {
                      return Text(
                        'Paste Image URL or Pick Image from Local Storage',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Constant.TEXT_SIZE,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (isChoosingImageFromLocal) {
                      return Image.file(imageFile);
                    } else {
                      return Image.network(
                        imageUrl,
                        errorBuilder: (_, child, error) => Text(
                          currentNotification.id == null
                              ? 'No Image'
                              : 'Unable to load image',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Constant.TEXT_SIZE,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
    );
  }
}
