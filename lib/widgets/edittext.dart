import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luxury_council/colors.dart';

class EditText extends StatefulWidget {
  TextInputType? textInputType;
  String? hint;

  String? name;
  int? maxLength;
  String? Function(String?)? validator;
  TextInputAction? textInputAction;
  void Function()? onEditingComplete;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool obsecureText;
  bool readOnly;
  bool enabled;

  TextEditingController? controller;
  List<TextInputFormatter>? inputformtters;
  bool autoFoucs;
  GestureTapCallback? onTap;

  EditText(
      {this.textInputType,
      this.obsecureText = false,
      this.readOnly = false,
      this.suffixIcon,
      this.prefixIcon,
      this.hint, 
      this.textInputAction,
      this.validator,
      this.controller,
      this.inputformtters,
      this.enabled = true,
      this.maxLength,
      this.onEditingComplete,
      this.autoFoucs = false,
        this.onTap,
      Key? key})
      : super(key: key);

  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        onEditingComplete: widget.onEditingComplete,
        textInputAction: widget.textInputAction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: widget.textInputType,
        obscureText: widget.obsecureText,
        readOnly: widget.readOnly,
        cursorColor: AppColor.cursorcolor,
        inputFormatters: widget.inputformtters,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        autofocus: widget.autoFoucs,
        onTap: widget.onTap,
        toolbarOptions: ToolbarOptions(
          copy: true,
          cut: true,
          paste: true,
          selectAll: true,
        ),
        style: TextStyle(
          fontSize: 14, 
          color: AppColor.white
        ),
        decoration: InputDecoration(
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            errorStyle: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: Colors.red),
            helperStyle: Theme.of(context).textTheme.subtitle1,
            hintStyle: TextStyle(color: AppColor.lightgrey),
            hintText: widget.hint,
           // filled: true,
            contentPadding: EdgeInsets.only(left: 0,top: 10, right: 0),
            label: widget.name != null ? Text(widget.name ?? "") : null,
            
            // disabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // focusedErrorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // errorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // )
            ),
      ),
    );
  }
}

class EditText1 extends StatefulWidget {
  TextInputType? textInputType;
  String? hint;

  String? name;
  int? maxLength;
  String? Function(String?)? validator;
  TextInputAction? textInputAction;
  void Function()? onEditingComplete;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool obsecureText;
  bool readOnly;
  bool enabled;

  TextEditingController? controller;
  List<TextInputFormatter>? inputformtters;
  bool autoFoucs;

  EditText1(
      {this.textInputType,
      this.obsecureText = false,
      this.readOnly = false,
      this.suffixIcon,
      this.prefixIcon,
      this.hint, 
      this.textInputAction,
      this.validator,
      this.controller,
      this.inputformtters,
      this.enabled = true,
      this.maxLength,
      this.onEditingComplete,
      this.autoFoucs = false,
      Key? key})
      : super(key: key);

  @override
  _EditText1State createState() => _EditText1State();
}

class _EditText1State extends State<EditText1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        onEditingComplete: widget.onEditingComplete,
        textInputAction: widget.textInputAction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: widget.textInputType,
        obscureText: widget.obsecureText,
        readOnly: widget.readOnly,
        cursorColor: AppColor.cursorcolor,
        inputFormatters: widget.inputformtters,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        autofocus: widget.autoFoucs,
        toolbarOptions: ToolbarOptions(
          copy: true,
          cut: true,
          paste: true,
          selectAll: true,
        ),
        style: TextStyle(
          fontSize: 14, 
          color: AppColor.white
        ),
        decoration: InputDecoration(
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            errorStyle: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: Colors.red),
            helperStyle: Theme.of(context).textTheme.subtitle1,
            hintStyle: TextStyle(color: AppColor.white),
            hintText: widget.hint,
            filled: true,fillColor: AppColor.black,
            contentPadding: EdgeInsets.only(left: 10,top: 10, right: 0),
            label: widget.name != null ? Text(widget.name ?? "") : null,
            
            disabledBorder: OutlineInputBorder(
               borderSide: BorderSide(width: 1, color: AppColor.primarycolor),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AppColor.primarycolor),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder( borderSide: BorderSide(width: 1, color: AppColor.primarycolor),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder( borderSide: BorderSide(width: 1, color: AppColor.primarycolor),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder( borderSide: BorderSide(width: 1, color: AppColor.primarycolor),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder( borderSide: BorderSide(width: 1, color: AppColor.primarycolor),
              borderRadius: BorderRadius.circular(10),
            )
            ),
      ),
    );
  }
}

class EditText3 extends StatefulWidget {
  TextInputType? textInputType;
  String? hint;

  String? name;
  int? maxLength;
  String? Function(String?)? validator;
  TextInputAction? textInputAction;
  void Function()? onEditingComplete;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool obsecureText;
  bool readOnly;
  bool enabled;

  TextEditingController? controller;
  List<TextInputFormatter>? inputformtters;
  bool autoFoucs;
  GestureTapCallback? onTap;

  EditText3(
      {this.textInputType,
      this.obsecureText = false,
      this.readOnly = false,
      this.suffixIcon,
      this.prefixIcon,
      this.hint, 
      this.textInputAction,
      this.validator,
      this.controller,
      this.inputformtters,
      this.enabled = true,
      this.maxLength,
      this.onEditingComplete,
      this.autoFoucs = false,
        this.onTap,
      Key? key})
      : super(key: key);

  @override
  _EditText3State createState() => _EditText3State();
}

class _EditText3State extends State<EditText3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),border: Border.all(color: AppColor.primarycolor)),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        onEditingComplete: widget.onEditingComplete,
        textInputAction: widget.textInputAction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: widget.textInputType,
        obscureText: widget.obsecureText,
        readOnly: widget.readOnly,
        cursorColor: AppColor.cursorcolor,
        inputFormatters: widget.inputformtters,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        autofocus: widget.autoFoucs,
        onTap: widget.onTap,
        toolbarOptions: ToolbarOptions(
          copy: true,
          cut: true,
          paste: true,
          selectAll: true,
        ),
        style: TextStyle(
          fontSize: 14, 
          color: AppColor.white
        ),
        decoration: InputDecoration(
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            errorStyle: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: Colors.red),
            helperStyle: Theme.of(context).textTheme.subtitle1,
            hintStyle: TextStyle(color: AppColor.darkgrey),
            hintText: widget.hint,border: InputBorder.none,

           // filled: true,
            contentPadding: EdgeInsets.only(left: 10,top: 10, right: 10),
            label: widget.name != null ? Text(widget.name ?? "") : null,
            
            // disabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // focusedErrorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // errorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // )
            ),
      ),
    );
  }
}