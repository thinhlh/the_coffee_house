import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the/models/store.dart';
import 'package:the/providers/stores.dart';

import '../../models/category.dart';
import '../../providers/categories.dart';
import '../../utils/const.dart' as Constant;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditStoreScreen extends StatefulWidget {
  final String id;
  EditStoreScreen(this.id);

  @override
  _EditStoreScreenState createState() => _EditStoreScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _EditStoreScreenState extends State<EditStoreScreen> {
  Store currentStore;

  TextEditingController nameController;
  TextEditingController addressController;
  TextEditingController lattitudeController;
  TextEditingController longitudeController;
  TextEditingController imageController;

  bool isLoading = false;
  bool isChoosingFileFromLocal = false;
  File imageFile;
  String imageUrl;

  @override
  void initState() {
    if (widget.id != null)
      currentStore = context.read<Stores>().getStoreById(widget.id);
    else
      currentStore = Store(
        id: null,
        address: null,
        name: null,
        location: null,
        imageUrl: null,
      );
    nameController = TextEditingController(text: currentStore.name ?? '');
    addressController = TextEditingController(text: currentStore.address ?? '');
    lattitudeController = TextEditingController(
      text: currentStore.location != null
          ? currentStore.location.latitude.toString()
          : '0.0',
    );
    longitudeController = TextEditingController(
        text: currentStore.location != null
            ? currentStore.location.longitude.toString()
            : '0.0');
    imageController = TextEditingController(text: currentStore.imageUrl ?? '');

    imageUrl = currentStore.imageUrl ?? '';
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void pickImage() async {
    final PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    } else {
      setState(() {
        imageFile = File(pickedFile.path);
        isChoosingFileFromLocal = true;
      });
    }
  }

  void onChangedOrSubmitUrl() {
    setState(() {
      imageUrl = imageController.text;
      isChoosingFileFromLocal = false;
    });
  }

  void save() async {
    if (!_formKey.currentState.validate()) return;
    if ((imageUrl == null || imageUrl.isEmpty) && imageFile == null) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('No Image'),
          content: Text('You must provide category image'),
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
    setState(() => isLoading = true);
    Store newStore = Store(
      id: currentStore.id,
      name: nameController.text,
      address: addressController.text,
      location: LatLng(
        double.parse(lattitudeController.text),
        double.parse(longitudeController.text),
      ),
      imageUrl: isChoosingFileFromLocal ? imageFile.path : imageUrl,
    );
    if (currentStore.id != null) {
      // id is not null => this is the update form
      await context.read<Stores>().updateStore(
            newStore,
            isChoosingFileFromLocal,
          );
    } else {
      // id is null => this is add form
      await context.read<Stores>().addStore(
            newStore,
            isChoosingFileFromLocal,
          );
    }
    setState(() => isLoading = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? 'Add Store' : currentStore.name,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: save,
          )
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
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(
                        FlutterIcons.title_mdi,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        value.isEmpty ? 'Store name cannot be empty' : null,
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(
                        Icons.location_on,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    maxLines: 2,
                    validator: (value) =>
                        value.isEmpty ? 'Address cannot be empty' : null,
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: lattitudeController,
                          textInputAction: TextInputAction.continueAction,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Lattitude',
                          ),
                          validator: (value) {
                            if (value.isEmpty ||
                                double.tryParse(value) == null) {
                              return 'Invalid lattitude';
                            } else {
                              double val = double.parse(value);
                              return val <= 90 && val >= -90
                                  ? null
                                  : 'Invalid lattitude';
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 1.5 * Constant.SIZED_BOX_HEIGHT),
                      Expanded(
                        child: TextFormField(
                            controller: longitudeController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            textInputAction: TextInputAction.continueAction,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Longitude',
                            ),
                            validator: (value) {
                              if (value.isEmpty ||
                                  double.tryParse(value) == null) {
                                return 'Invalid longitude';
                              } else {
                                double val = double.parse(value);
                                return val <= 180 && val >= -180
                                    ? null
                                    : 'Invalid longitude';
                              }
                            }),
                      )
                    ],
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
                    } else if (isChoosingFileFromLocal) {
                      return Image.file(imageFile);
                    } else {
                      return Image.network(
                        imageUrl,
                        errorBuilder: (_, child, error) => Text(
                          currentStore.id == null
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
