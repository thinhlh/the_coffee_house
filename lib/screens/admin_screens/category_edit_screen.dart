import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/models/category.dart';
import 'package:the_coffee_house/providers/categories.dart';

class EditCategoryScreen extends StatefulWidget {
  final id;
  EditCategoryScreen(this.id);

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  var editingCategory = Category(
    id: null,
    title: '',
    imageUrl: '',
  );

  Map<String, String> initValues;

  final TextEditingController imageController = TextEditingController();

  var isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      if (widget.id != null) {
        editingCategory =
            Provider.of<Categories>(context).getCategoryById(widget.id);
      }
      initValues = {
        'title': editingCategory.title,
        'imageUrl': editingCategory.imageUrl,
      };
      imageController.text = editingCategory.imageUrl;
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageController.dispose();
    super.dispose();
  }

  void save() {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() => isLoading = true);
    if (editingCategory.id != null) {
      Provider.of<Categories>(context, listen: false)
          .updateCategory(editingCategory.id, editingCategory);
    } else {
      Provider.of<Categories>(context, listen: false)
          .addCategory(editingCategory);
    }
    setState(() => isLoading = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? 'Add Category' : editingCategory.title,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: save,
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: formKey,
              child: ListView(
                physics: PageScrollPhysics(),
                padding: const EdgeInsets.all(Constant.GENERAL_PADDING * 2),
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    initialValue: initValues['title'],
                    validator: (value) {
                      if (value.isEmpty) return 'Title cannot be null';
                      return null;
                    },
                    onSaved: (newValue) => editingCategory = Category(
                      id: editingCategory.id,
                      imageUrl: editingCategory.imageUrl,
                      title: newValue,
                    ),
                  ),
                  TextFormField(
                      controller: imageController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Image Url',
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value.isEmpty) return 'Please fill this field';
                        return null;
                      },
                      onSaved: (newValue) => editingCategory = Category(
                            id: editingCategory.id,
                            title: editingCategory.title,
                            imageUrl: newValue,
                          ),
                      onFieldSubmitted: (value) => setState(() {})),
                  SizedBox(
                    height: Constant.SIZED_BOX_HEIGHT,
                  ),
                  Builder(
                    builder: (_) => imageController.text.isEmpty
                        ? Container()
                        : SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Image.network(
                              imageController.text,
                              fit: BoxFit.contain,
                              loadingBuilder: (_, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                              errorBuilder:
                                  (_, exception, StackTrace stackTrace) =>
                                      Center(
                                child: Text(
                                  'Unable to load the image',
                                  style: TextStyle(
                                      fontSize: Constant.TEXT_SIZE,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: Constant.SIZED_BOX_HEIGHT,
                  ),
                  Center(
                    child: ElevatedButton(
                      child: Text('Save'),
                      onPressed: save,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
