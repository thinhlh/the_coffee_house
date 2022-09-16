import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../providers/categories.dart';
import '../../utils/const.dart' as Constant;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditCategoryScreen extends StatefulWidget {
  final String id;
  EditCategoryScreen(this.id);

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  Category currentCategory;

  TextEditingController titleController;
  TextEditingController imageController;

  bool isLoading = false;
  bool isChoosingFileFromLocal = false;
  File imageFile;
  String imageUrl;

  @override
  void initState() {
    if (widget.id != null)
      currentCategory = context.read<Categories>().getCategoryById(widget.id);
    else
      currentCategory = Category(id: null, title: null, imageUrl: null);
    titleController = TextEditingController(text: currentCategory.title ?? '');
    imageController =
        TextEditingController(text: currentCategory.imageUrl ?? '');
    imageUrl = currentCategory.imageUrl ?? '';
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
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
    Category newCategory = Category(
      id: currentCategory.id,
      title: titleController.text,
      imageUrl: isChoosingFileFromLocal ? imageFile.path : imageUrl,
    );
    if (currentCategory.id != null) {
      // id is not null => this is the update form
      await context.read<Categories>().updateCategory(
            newCategory,
            isChoosingFileFromLocal,
          );
    } else {
      // id is null => this is add form
      await context.read<Categories>().addCategory(
            newCategory,
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
          widget.id == null ? 'Add Category' : currentCategory.title,
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
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        value.isEmpty ? 'Title cannot be empty' : null,
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
                          currentCategory.id == null
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
