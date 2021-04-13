import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:the_coffee_house/models/membership.dart';
import 'package:the_coffee_house/providers/notifications.dart';
import 'package:the_coffee_house/models/notification.dart' as model;
import 'package:the_coffee_house/utils/const.dart' as Constant;

class EditNotificationScreen extends StatefulWidget {
  final String notificationId;
  EditNotificationScreen(this.notificationId);

  @override
  _EditNotificationScreenState createState() => _EditNotificationScreenState();
}

final GlobalKey<FormState> _form = GlobalKey<FormState>();

class _EditNotificationScreenState extends State<EditNotificationScreen> {
  final TextEditingController imageController = TextEditingController();
  List<bool> targettedCustomer = List.filled(4, false);
  model.Notification notification = model.Notification.initialize();

  bool _isLoading = false;

  void save() async {
    if (!_form.currentState.validate()) return;

    _form.currentState.save();
    setState(() => _isLoading = true);

    if (targettedCustomer[0])
      notification.targetCustomer.add(Membership.Bronze);
    if (targettedCustomer[1])
      notification.targetCustomer.add(Membership.Silver);
    if (targettedCustomer[2]) notification.targetCustomer.add(Membership.Gold);
    if (targettedCustomer[3])
      notification.targetCustomer.add(Membership.Diamond);
    if (widget.notificationId == null) {
      await Provider.of<Notifications>(context, listen: false)
          .addNotification(notification);
    } else {
      await Provider.of<Notifications>(context, listen: false)
          .updateNotification(notification);
    }

    setState(() => _isLoading = false);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.notificationId != null) {
      notification = Provider.of<Notifications>(context, listen: false)
          .getNotificationById(widget.notificationId);
      targettedCustomer[0] =
          notification.targetCustomer.contains(Membership.Bronze);
      targettedCustomer[1] =
          notification.targetCustomer.contains(Membership.Silver);
      targettedCustomer[2] =
          notification.targetCustomer.contains(Membership.Gold);
      targettedCustomer[3] =
          notification.targetCustomer.contains(Membership.Diamond);
      imageController.text = notification.imageUrl;
    }
  }

  @override
  void dispose() {
    super.dispose();
    imageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imageController.text = notification.imageUrl;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: save,
          ),
        ],
        title: Text(
          notification.id == null ? 'Add Notification' : 'Edit Notification',
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _form,
              child: ListView(
                physics: PageScrollPhysics(),
                padding: const EdgeInsets.all(Constant.GENERAL_PADDING * 2),
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    textInputAction: TextInputAction.next,
                    initialValue: notification.title,
                    validator: (value) =>
                        value.isEmpty ? 'Title cannot be empty' : null,
                    onSaved: (value) => notification.title = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    textInputAction: TextInputAction.next,
                    initialValue: notification.description,
                    validator: (value) => value.isEmpty
                        ? 'Description cannot be empty'
                        : value.characters.length > 200
                            ? "Description must be less than 200 characters"
                            : null,
                    onSaved: (value) => notification.description = value,
                  ),
                  TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    validator: (value) =>
                        value.isEmpty ? 'Image URL cannot be null' : null,
                    onFieldSubmitted: (value) => setState(() {
                      notification.imageUrl = value;
                    }),
                    onSaved: (value) => notification.imageUrl = value,
                  ),
                  SizedBox(
                    height: Constant.SIZED_BOX_HEIGHT,
                  ),
                  imageController.text.isEmpty
                      ? SizedBox(
                          height: 0,
                          width: 0,
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: Image.network(
                            imageController.text,
                            fit: BoxFit.contain,
                            loadingBuilder: (_, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder:
                                (_, exception, StackTrace stackTrace) => Center(
                              child: Text(
                                'Unable to load the image',
                                style: TextStyle(
                                    fontSize: Constant.TEXT_SIZE,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                  Divider(),
                  Text(
                    'Targetted Costumers ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                            notification.imageUrl = imageController.text;
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
                            notification.imageUrl = imageController.text;
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
                            notification.imageUrl = imageController.text;
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
                            notification.imageUrl = imageController.text;
                            targettedCustomer[3] = value;
                          });
                        },
                      ),
                    ],
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
