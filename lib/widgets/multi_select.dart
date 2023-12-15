import 'package:flutter/material.dart';
import 'package:luxury_council/colors.dart'; 

class CategoriesSelect extends StatefulWidget {
  final List<String> items;
  const CategoriesSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoriesSelectState();
}

class _CategoriesSelectState extends State<CategoriesSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.black,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      insetPadding: EdgeInsets.only(right: 110, left: 15, top: 160,bottom: 15),
      alignment: Alignment.topRight,
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    activeColor: AppColor.primarycolor,
                    checkColor: AppColor.black,
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    side: MaterialStateBorderSide.resolveWith(
                      (states) =>
                          BorderSide(width: 1.0, color: AppColor.primarycolor),
                    ),
                    value: _selectedItems.contains(item),
                    title: Transform.translate(
                      offset: const Offset(-15, 0),
                      child: Text(
                        item,
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
          height: 25,
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColor.primarycolor,
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
                _submit();
              },
              child: Text(
                'View',
                style: TextStyle(color: AppColor.black, fontSize: 13),
              ),
            ),
          ),
        )),
        
      ],
    );
  }
}

class MediaTypeSelect extends StatefulWidget {
  final List<String> items;
  const MediaTypeSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MediaTypeSelectState();
}

class _MediaTypeSelectState extends State<MediaTypeSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  } 

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.black,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      insetPadding: EdgeInsets.only(right: 15, left: 140, top: 160,bottom: 15),alignment: Alignment.topRight,
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    activeColor: AppColor.primarycolor,
                    checkColor: AppColor.black,

                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    // dense: true,
                    side: MaterialStateBorderSide.resolveWith(
                      (states) =>
                          BorderSide(width: 1.0, color: AppColor.primarycolor),
                    ),
                    value: _selectedItems.contains(item),
                    title: Transform.translate(
                      offset: const Offset(-15, 0),
                      child: Text(
                        item,
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
          height: 25,
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColor.primarycolor,
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
                _submit();
              },
              child: Text(
                'View',
                style: TextStyle(color: AppColor.black, fontSize: 13),
              ),
            ),
          ),
        )),
      ],
    );
  }
}

class InterestSelect extends StatefulWidget {
  final List<String> items;
  const InterestSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InterestSelectState();
}

class _InterestSelectState extends State<InterestSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  } 

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.black,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      insetPadding: EdgeInsets.only(right: 70, left: 80, top: 160,bottom: 15),
      //alignment: Alignment.center,
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    activeColor: AppColor.primarycolor,
                    checkColor: AppColor.black,

                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    // dense: true,
                    side: MaterialStateBorderSide.resolveWith(
                      (states) =>
                          BorderSide(width: 1.0, color: AppColor.primarycolor),
                    ),
                    value: _selectedItems.contains(item),
                    title: Transform.translate(
                      offset: const Offset(-15, 0),
                      child: Text(
                        item,
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
          height: 25,
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColor.primarycolor,
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
                _submit();
              },
              child: Text(
                'View',
                style: TextStyle(color: AppColor.black, fontSize: 13),
              ),
            ),
          ),
        )),
      ],
    );
  }
}
