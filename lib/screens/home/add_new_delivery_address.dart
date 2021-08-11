import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the/models/delivery_detail.dart';
import 'package:the/utils/const.dart' as Constant;
import 'package:the/utils/global_vars.dart';

class AddNewDeliveryAddress extends StatefulWidget {
  @override
  _AddNewDeliveryAddressState createState() => _AddNewDeliveryAddressState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _AddNewDeliveryAddressState extends State<AddNewDeliveryAddress> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  void _onSubmitForm(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      DeliveryDetail deliveryDetail = DeliveryDetail(
        recipientName: _nameController.text,
        recipientPhone: _phoneController.text,
        address: _addressController.text,
        note: _noteController.text,
      );

      await sharedPref.saveNewDeliveryDetail(deliveryDetail);

      Navigator.of(context).pop(deliveryDetail);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm địa chỉ mới'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Tên người nhận',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                validator: (value) => (value.isNotEmpty &&
                        !RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                            .hasMatch(value))
                    ? null
                    : 'Invalid name',
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                validator: (value) => value.isEmpty
                    ? 'Phone number cannot be empty'
                    : int.tryParse(value) == null
                        ? 'Invalid phone number'
                        : value.length != 10
                            ? 'Invalid phone number'
                            : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.streetAddress,
                validator: (value) => (value.isEmpty || value == null)
                    ? 'Address cannot be empty'
                    : null,
              ),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Ghi chú khác',
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: Constant.SIZED_BOX_HEIGHT,
              ),
              ElevatedButton(
                onPressed: () async => _onSubmitForm(context),
                child: Text(
                  'Xong',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.amberAccent[200]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
