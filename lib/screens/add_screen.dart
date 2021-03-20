import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/components/floating_bottom_button.dart';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget {
  static const id = 'add_screen';
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _productNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
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
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    CupertinoIcons.checkmark,
                    color: Colors.white,
                    size: 36.0,
                  ),
                  radius: 36.0,
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
      final pickedImage = await ImagePicker().getImage(
        source: imageSource,
        imageQuality: 85,
      );
      // TODO: Upload to Cloud Storage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingBottomButton(
        label: 'Post',
        onPressed: () {
          _showSucceedDialog(context);
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
                  icon: CupertinoIcons.photo,
                  label: 'Choose image',
                ),
                SizedBox(height: 10.0),
                MyButton(
                  onPressed: () {},
                  icon: CupertinoIcons.location,
                  label: 'Choose location',
                ),
                SizedBox(height: 25.0),
                MyTextField(
                  controller: _productNameController,
                  focusNode: _productNameFocusNode,
                  hintText: "Product's name",
                  icon: CupertinoIcons.gift,
                ),
                SizedBox(height: 10.0),
                MyTextField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocusNode,
                  hintText: "Description",
                  icon: Icons.edit_outlined,
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
                Wrap(
                  children: _buildRadioList(),
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
  final IconData icon;
  final FocusNode focusNode;
  MyTextField({
    @required this.controller,
    @required this.hintText,
    @required this.icon,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 32.0,
        ),
        hintText: hintText ?? 'Enter your text',
        border: InputBorder.none,
      ),
      style: TextStyle(
        fontSize: 20.0,
        color: Color(0xFF868686),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final IconData icon;
  MyButton({
    @required this.label,
    @required this.onPressed,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 175.0,
      child: RaisedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon ?? Icons.warning,
          color: Theme.of(context).primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: EdgeInsets.all(10.0),
        elevation: 4.0,
        color: Colors.white,
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
