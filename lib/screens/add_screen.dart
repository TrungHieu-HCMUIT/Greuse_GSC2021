import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/components/floating_bottom_button.dart';

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
  final _materials = [
    'Material',
    'Material',
    'Material',
    'Material',
    'Material',
    'Material',
    'Material',
    'Material',
    'Material',
    'Material',
    'Orthers...',
  ];

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
                  onPressed: () {},
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
                  children: _materials
                      .map((m) => MyCheckBox(
                            value: false,
                            label: m,
                            onChanged: (value) {},
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final String label;
  final bool value;
  final Function onChanged;
  MyCheckBox({
    @required this.value,
    @required this.label,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.8,
      child: Row(
        children: [
          Checkbox(
            value: value,
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
