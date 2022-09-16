import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../../providers/categories.dart';
import '../../providers/products.dart';
import '../../utils/const.dart' as Constant;

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class ProductEditScreen extends StatefulWidget {
  final String id;
  ProductEditScreen(this.id);

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  Product currentProduct;
  List<Category> categories;
  String currentDropdownCategoryId;
  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController priceController;
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
    categories = context.read<Categories>().categories;
    if (widget.id == null) {
      currentProduct = Product(
        id: null,
        title: null,
        description: null,
        price: null,
        imageUrl: null,
        categoryId: null,
      );
      currentDropdownCategoryId = categories.first.id;
    } else {
      currentProduct = Provider.of<Products>(context, listen: false)
          .getProductById(widget.id);
      currentDropdownCategoryId = currentProduct.categoryId;
    }
    titleController = TextEditingController(text: currentProduct.title ?? '');
    descriptionController =
        TextEditingController(text: currentProduct.description ?? '');
    priceController = TextEditingController(
      text:
          currentProduct.price == null ? '0' : currentProduct.price.toString(),
    );

    imageController =
        TextEditingController(text: currentProduct.imageUrl ?? '');
    imageUrl = currentProduct.imageUrl ?? '';

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void save() async {
    if (!_formKey.currentState.validate()) return;
    if ((imageUrl == null || imageUrl.isEmpty) && imageFile == null) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('No Image'),
          content: Text('You must provide product image'),
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
    Product newProduct = Product(
      id: currentProduct.id,
      title: titleController.text,
      description: descriptionController.text,
      price: int.parse(priceController.text),
      imageUrl: isChoosingImageFromLocal ? imageFile.path : imageUrl,
      categoryId: currentDropdownCategoryId,
    );
    if (currentProduct.id != null) {
      // id is not null => this is the update form
      await context.read<Products>().updateProduct(
            newProduct,
            isChoosingImageFromLocal,
          );
    } else {
      // id is null => this is add form
      await context.read<Products>().addProduct(
            newProduct,
            isChoosingImageFromLocal,
          );
    }
    setState(() => isLoading = false);
    Navigator.of(context).pop();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? 'Add Product' : currentProduct.title,
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
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) => value.isEmpty
                        ? 'Price cannot be empty'
                        : int.tryParse(value) == null
                            ? 'Invalid price'
                            : null,
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  DropdownButtonFormField(
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          child: Text(category.title),
                          value: category.id,
                        );
                      }).toList(),
                      value: categories
                              .map((e) => e.id)
                              .contains(currentDropdownCategoryId)
                          ? currentDropdownCategoryId
                          : categories.first.id,
                      isExpanded: false,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (category) {
                        if (category == null) return 'Category cannot be null';
                        return null;
                      },
                      onChanged: (newValue) {
                        setState(() {
                          currentDropdownCategoryId = newValue;
                        });
                      }),
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
                    } else if (isChoosingImageFromLocal) {
                      return Image.file(imageFile);
                    } else {
                      return Image.network(
                        imageUrl,
                        errorBuilder: (_, child, error) => Text(
                          currentProduct.id == null
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
