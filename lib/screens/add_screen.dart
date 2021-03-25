import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greuse/components/floating_bottom_button.dart';
import 'package:greuse/models/post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddScreen extends StatefulWidget {
  static const id = 'add_screen';
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _weightController = TextEditingController();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _weightFocusNode = FocusNode();
  final _productNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _storage = FirebaseStorage.instance;
  var _materials = [
    'Material 1',
    'Material 2',
    'Material 3',
    'Material 4',
    'Material 5',
    'Material 6',
    'Material 7',
    'Material 8',
    'Material 9',
    'others...',
  ];
  String _material;
  String _productNameErrorText,
      _descriptionErrorText,
      _weightErrorText,
      _materialErrorText;
  var _pickedImagePaths = <String>[];
  var _pickedAssetImages = <Asset>[];

  void _showSucceedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.all(24.0),
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'Succeed!',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 14.0),
                Image.asset(
                  'assets/icons/checked.png',
                  scale: 2.0,
                ),
              ],
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  List<Widget> _buildRadioList() {
    final newList = <Widget>[];
    for (int i = 0; i < _materials.length; i++) {
      final m = _materials[i];
      newList.add(MyRadio(
          value: m,
          label: m,
          groupValue: _material,
          onChanged: (value) {
            setState(() {
              _material = value;
            });
          }));
    }
    return newList;
  }

  Future<ImageSource> _chooseImageSource() async {
    ImageSource source;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200.0,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  'Choose image from',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 12.0),
                ListTile(
                  title: Text('Camera'),
                  onTap: () {
                    source = ImageSource.camera;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Gallary'),
                  onTap: () {
                    source = ImageSource.gallery;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    return source;
  }

  void _chooseImage() async {
    final imageSource = await _chooseImageSource();
    if (imageSource != null) {
      if (imageSource == ImageSource.camera) {
        final pickedImage = await ImagePicker().getImage(
          source: imageSource,
          imageQuality: 85,
        );
        _pickedImagePaths.add(pickedImage.path);
      } else {
        final pickedImages = await MultiImagePicker.pickImages(maxImages: 5);
        _pickedAssetImages = pickedImages;
      }
      // TODO: Upload to Cloud Storage
    }
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);

    try {
      await _storage.ref('uploads/file-to-upload.png').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  bool _isFormValid() {
    bool isValid = true;
    final productName = _productNameController.text.trim();
    final description = _descriptionController.text.trim();
    final weight = _weightController.text.trim();
    setState(() {
      _productNameErrorText = null;
      _descriptionErrorText = null;
      _weightErrorText = null;
      _materialErrorText = null;

      if (productName.isEmpty) {
        isValid = false;
        _productNameErrorText = "Please enter product's name";
      }
      if (description.isEmpty) {
        isValid = false;
        _descriptionErrorText = "Please enter description";
      }
      if (weight.isEmpty) {
        isValid = false;
        _weightErrorText = "Please enter weight";
      }
      if (_material == null) {
        isValid = false;
        _materialErrorText = "Please choose material";
      }
    });
    return isValid;
  }

  Future<void> _post() async {
    if (_isFormValid()) {
      // await uploadFile(_pickedAssetImages[0].identifier);
      // await _storage
      //     .ref('uploads/file-to-upload-1.png')
      //     .putData(_pickedAssetImages[0].);
      final res = await _firestore.collection("posts").add(
            Post(
              image:
                  'https://thunggiay.com/wp-content/uploads/2018/10/Mua-thung-giay-o-dau-uy-tin-va-chat-luong1.jpg',
              material: _material,
              name: _productNameController.text.trim(),
              location: "TP HCM",
              description: _descriptionController.text,
              weight: double.parse(_weightController.text.trim()),
            ).toJson(),
          );
      if (res != null) {
        await res.update({'id': res.id});
        _showSucceedDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingBottomButton(
        label: 'Post',
        onPressed: () {
          _post();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 65.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyButton(
                  onPressed: _chooseImage,
                  icon: ImageIcon(
                    AssetImage('assets/icons/image.png'),
                    color: Theme.of(context).primaryColor,
                  ),
                  label: 'Choose image',
                ),
                SizedBox(height: 10.0),
                MyButton(
                  onPressed: () {},
                  icon: ImageIcon(
                    AssetImage('assets/icons/location.png'),
                    color: Theme.of(context).primaryColor,
                  ),
                  label: 'Choose location',
                ),
                SizedBox(height: 25.0),
                MyTextField(
                  controller: _productNameController,
                  focusNode: _productNameFocusNode,
                  hintText: "Product's name",
                  errorText: _productNameErrorText,
                  icon: ImageIcon(
                    AssetImage('assets/icons/box.png'),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 10.0),
                MyTextField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocusNode,
                  hintText: "Description",
                  errorText: _descriptionErrorText,
                  icon: ImageIcon(
                    AssetImage('assets/icons/edit.png'),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  'Material',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _materialErrorText == null
                    ? Container()
                    : Text(
                        _materialErrorText ?? "",
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Theme.of(context).errorColor,
                            ),
                      ),
                Wrap(
                  children: _buildRadioList(),
                ),
                SizedBox(height: 12),
                MyTextField(
                  controller: _weightController,
                  focusNode: _weightFocusNode,
                  hintText: "Weight",
                  keyboardType: TextInputType.number,
                  errorText: _weightErrorText,
                  icon: ImageIcon(
                    AssetImage('assets/icons/weight.png'),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/point.png',
                        scale: 3,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '599',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyRadio extends StatelessWidget {
  final String label;
  final dynamic value;
  final dynamic groupValue;
  final Function onChanged;
  MyRadio({
    @required this.value,
    @required this.label,
    @required this.groupValue,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.8,
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          SizedBox(width: 10.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget icon;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final String errorText;
  MyTextField({
    @required this.controller,
    @required this.hintText,
    @required this.icon,
    this.keyboardType,
    this.focusNode,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        icon: icon,
        hintText: hintText ?? 'Enter your text',
        border: InputBorder.none,
        errorText: errorText,
      ),
      style: TextStyle(
        fontSize: 17.0,
        color: Color(0xFF868686),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Widget icon;
  MyButton({
    @required this.label,
    @required this.onPressed,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 175.0,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(10.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          primary: Colors.white,
          onPrimary: Theme.of(context).primaryColor,
        ),
        label: Text(
          label ?? 'null',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
