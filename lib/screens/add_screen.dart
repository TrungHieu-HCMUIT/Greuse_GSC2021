import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greuse/components/floating_bottom_button.dart';
import 'package:greuse/screens/choose_location_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddScreen extends StatefulWidget {
  static const id = 'add_screen';
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;
  final _weightController = TextEditingController();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _weightFocusNode = FocusNode();
  final _productNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  dynamic _pickedImages;
  var _materials = [
    'Paper',
    'Plastic Bottle',
    'Aluminium Can',
    'Glass',
    'others...',
  ];
  String _material;
  String _nameErrorText;
  String _descriptionErrorText;
  String _weightErrorText;
  String _materialErrorText;

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

  void _chooseLocation() async {
    Navigator.pushNamed(context, ChooseLocationScreen.id);
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
    if (imageSource == ImageSource.camera) {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _pickedImages = null;
        _pickedImages = File(pickedFile.path);
      }
      return;
    }

    final pickedFiles = await MultiImagePicker.pickImages(maxImages: 5);
    if (pickedFiles.isNotEmpty) {
      _pickedImages = null;
      for (int i = 0; i < pickedFiles.length; i++) {
        final img = pickedFiles[i];
        _pickedImages = <Uint8List>[];
        final byteData = await img.getByteData();
        _pickedImages.add(byteData.buffer.asUint8List());
      }
    }
  }

  String generateImageName(String path) {
    return "${path.hashCode}${path.substring(path.lastIndexOf('.'))}";
  }

  Future<String> _uploadImage() async {
    String downloadUrl;
    if (_pickedImages is File) {
      final ref = _storage
          .ref()
          .child("postImages")
          .child(generateImageName(_pickedImages.path));

      final uploadTask = ref.putFile(_pickedImages);
      await uploadTask.whenComplete(() async {
        downloadUrl = await ref.getDownloadURL();
      });
    }

    return downloadUrl;
  }

  Future<void> _post() async {
    setState(() {
      _nameErrorText = null;
      _descriptionErrorText = null;
      _weightErrorText = null;
      _materialErrorText = null;
    });

    bool isValid = true;

    final prodName = _productNameController.text.trim();
    final description = _descriptionController.text.trim();
    dynamic weight = _weightController.text.trim();

    setState(() {
      if (prodName.isEmpty) {
        _nameErrorText = "Please enter product's name";
        isValid = false;
      }
      if (description.isEmpty) {
        _descriptionErrorText = "Please enter description";
        isValid = false;
      }
      if (weight.isEmpty) {
        _weightErrorText = "Please enter weight";
        isValid = false;
      } else {
        weight = double.tryParse(weight);
        if (weight == null) {
          _weightErrorText = "Please enter a valid number";
          isValid = false;
        }
      }
      if (_material == null) {
        _materialErrorText = "Please choose a mateiral";
        isValid = false;
      }
    });

    if (!isValid) return;

    final user = _auth.currentUser;
    if (user == null) return;
    final dbUser = _firestore.collection('users').doc(user.uid);
    final res = await _firestore.collection("posts").add({
      'material': _material,
      'name': prodName,
      'location': 'TP HCM',
      'description': description,
      'isSaved': false,
      'weight': weight,
      'user': dbUser,
    });
    if (res != null) {
      await res.update({'id': res.id});
      final imageUrl = await _uploadImage();
      if (imageUrl == null) {
        await res.delete();
      } else {
        await res.update({'image': imageUrl});
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
        onPressed: _post,
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
                  onPressed: _chooseLocation,
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
                  errorText: _nameErrorText,
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
                        _materialErrorText ?? '',
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
                  errorText: _weightErrorText,
                  keyboardType: TextInputType.number,
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
      width: MediaQuery.of(context).size.width / 2.4,
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.0,
              ),
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
