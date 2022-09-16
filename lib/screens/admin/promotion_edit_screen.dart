import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:the/models/category.dart';
import 'package:the/models/promotion.dart';
import 'package:the/providers/categories.dart';
import 'package:the/providers/promotions.dart';

import '../../models/membership.dart';
import '../../providers/notifications.dart';
import '../../utils/const.dart' as Constant;

class PromotionEditScreen extends StatefulWidget {
  final String id;
  PromotionEditScreen(this.id);

  @override
  _PromotionEditScreenState createState() => _PromotionEditScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _PromotionEditScreenState extends State<PromotionEditScreen> {
  List<bool> targettedCustomer = List.filled(4, false);
  Promotion promotion;
  DateTime expiryDate;

  TextEditingController codeController;
  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController valueController;
  TextEditingController imageController;
  TextEditingController expiryDateController;

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
      promotion = Promotion(
        id: null,
        code: null,
        title: null,
        description: null,
        expiryDate: null,
        targetCustomer: [],
        imageUrl: null,
        value: null,
      );
    } else {
      promotion = Provider.of<Promotions>(context, listen: false)
          .getPromotionById(widget.id);
      promotion.targetCustomer.forEach((element) {
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
    titleController = TextEditingController(text: promotion.title ?? '');
    descriptionController =
        TextEditingController(text: promotion.description ?? '');
    valueController = TextEditingController(text: promotion.value ?? '');
    codeController = TextEditingController(text: promotion.code ?? '');
    imageController = TextEditingController(text: promotion.imageUrl ?? '');

    expiryDate = promotion.expiryDate ?? DateTime.now();

    expiryDateController = TextEditingController(
      text: DateFormat('EEE, dd MMM y').format(expiryDate),
    );
    imageUrl = promotion.imageUrl ?? '';

    super.initState();
  }

  void save() async {
    if (!_formKey.currentState.validate()) return;
    if ((imageUrl == null || imageUrl.isEmpty) && imageFile == null) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('No Image'),
          content: Text('You must provide promotion image'),
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

    print(targetCustomer);

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

    Promotion newPromotion = Promotion(
      id: promotion.id,
      title: titleController.text,
      description: descriptionController.text,
      imageUrl: isChoosingImageFromLocal ? imageFile.path : imageUrl,
      code: codeController.text.toUpperCase(),
      value: valueController.text,
      targetCustomer: targetCustomer,
      expiryDate: expiryDate,
    );
    if (promotion.id != null) {
      // id is not null => this is the update form
      await context.read<Promotions>().updatePromotion(
            newPromotion,
            isChoosingImageFromLocal,
          );
      //TODO HANDLING HERE
    } else {
      // id is null => this is add form
      await context.read<Promotions>().addPromotion(
            newPromotion,
            isChoosingImageFromLocal,
          );

      //TODO HANDLING HERE
    }
    setState(() => isLoading = false);
    Navigator.of(context).pop();
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    codeController.dispose();
    valueController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? 'Add Promotion' : promotion.title,
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
                      controller: codeController,
                      decoration: InputDecoration(
                        labelText: 'CODE',
                        prefixIcon: IconButton(
                          icon: Icon(Icons.qr_code),
                          onPressed: () {
                            var r = Random();
                            const _chars =
                                'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                            codeController.text = List.generate(
                              8,
                              (index) => _chars[r.nextInt(_chars.length)],
                            ).join().toUpperCase();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) => value.isEmpty
                          ? 'Code cannot be empty'
                          : value.length > 10
                              ? 'CODE should have maximum 10 characters'
                              : null),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
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
                    maxLines: 3,
                    validator: (value) =>
                        value.isEmpty ? 'Decription cannot be empty' : null,
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  TextFormField(
                    controller: valueController,
                    decoration: InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty)
                        return 'CODE cannot be empty';
                      else {
                        if (value.contains("%")) {
                          if (value[value.length - 1] == '%') {
                            String expectedValue =
                                value.substring(0, value.length - 1);
                            int intValue = int.tryParse(expectedValue);
                            print(intValue);
                            if (expectedValue == null ||
                                expectedValue.isEmpty ||
                                intValue == null) {
                              return 'Invalid value';
                            } else {
                              if (intValue <= 100 && intValue >= 0) {
                                return null;
                              } else {
                                return 'Invalid value';
                              }
                            }
                          } else {
                            return 'Invalid value';
                          }
                        } else {
                          int intValue = int.tryParse(value);
                          if (intValue != null)
                            return null;
                          else
                            return 'Invalid value';
                        }
                      }
                    },
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
                  TextFormField(
                    controller: expiryDateController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.utc(3000),
                          initialDatePickerMode: DatePickerMode.day,
                          fieldLabelText: 'Expiry Date',
                          fieldHintText: 'Expiry Date',
                        ).then(
                          (value) => setState(
                            () {
                              expiryDate = value;
                              expiryDateController.text =
                                  DateFormat('EEE, dd MMM y')
                                      .format(expiryDate);
                            },
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    readOnly: true,
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
                          promotion.id == null
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
