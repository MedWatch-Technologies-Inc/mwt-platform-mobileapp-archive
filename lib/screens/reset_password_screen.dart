import 'package:flutter/material.dart';
import 'package:health_gauge/models/user_model.dart';

import 'package:health_gauge/screens/sign_in_screen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'package:health_gauge/widgets/buttons.dart';
import 'package:health_gauge/widgets/my_behaviour.dart';
import 'package:health_gauge/widgets/text_utils.dart';

import '../main.dart';

class ResetPasswordScreen extends StatefulWidget {
  final UserModel userModel;

  const ResetPasswordScreen({required this.userModel});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool? isLoading;
  bool isErrorInGetMessage = false;

  AppImages images = new AppImages();

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  FocusNode confirmPasswordFocusNode = new FocusNode();

  AutovalidateMode autoValidate = AutovalidateMode.always;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : HexColor.fromHex("#384341").withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      body: layoutMain(),
    );
  }

  Widget layoutMain() {
    return dataLayout();
  }

  Widget dataLayout() {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView(
        padding: EdgeInsets.all(36.0),
        shrinkWrap: true,
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                logoImageLayout(),
                textFields(),
                RaisedBtn(
                    onPressed: () {
                      onClickResetPassword();
                    },
                    text: StringLocalization.of(context)
                        .getText(StringLocalization.save)
                        .toUpperCase()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget logoImageLayout() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0, top: 0.0),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.lock_outline,
            size: 50.0,
            color: AppColor.primaryColor,
          ),
          SizedBox(height: 20.0),
          Display1Text(
            text: "Reset Password",
            align: TextAlign.center,
            color: AppColor.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget textFields() {
    return Column(
      children: <Widget>[
        //region password
        Row(
          children: <Widget>[
            Icon(
              Icons.lock,
              color: Colors.black.withAlpha(100),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                autovalidateMode: autoValidate,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: StringLocalization.of(context)
                      .getText(StringLocalization.hintForNewPassword),
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return StringLocalization.of(context)
                        .getText(StringLocalization.emptyNewPassword);
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
                },
              ),
            ),
          ],
        ),
        //endregion
        SizedBox(height: 10.0),
        //region Confirm password
        Row(
          children: <Widget>[
            Icon(
              Icons.lock,
              color: Colors.black.withAlpha(100),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: TextFormField(
                obscureText: true,
                focusNode: confirmPasswordFocusNode,
                controller: confirmPasswordController,
                autovalidateMode: autoValidate,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: StringLocalization.of(context)
                      .getText(StringLocalization.hintForConfirmPassword),
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return StringLocalization.of(context)
                        .getText(StringLocalization.emptyConfirmPassword);
                  }
                  if (value != passwordController.text) {
                    return StringLocalization.of(context)
                        .getText(StringLocalization.confirmPasswordDoesntMatch);
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
        //endregion
        SizedBox(height: 20.0),
      ],
    );
  }

  void onClickResetPassword() {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      callApi();
    } else {
      autoValidate = AutovalidateMode.always;
      setState(() {});
    }
  }

  Future<void> callApi() async {
    // bool isInternet = await Constants.isInternetAvailable();
    // if (isInternet) {
    //   String password = passwordController.text.trim();
    //   String userId = widget.userModel.userId ?? "";
    //   Constants.progressDialog(true, context);
    //   final Map result = await new ResetPassword().callApi(
    //       Constants.baseUrl +
    //           "/ResetPassword?UserID=$userId&NewPassword=$password",
    //       "");
    //   Constants.progressDialog(false, context);
    //   if (!result["isError"]) {
    //     if (result["value"].toString().isNotEmpty) {
    //       // scaffoldKey.currentState
    //       //     .showSnackBar(SnackBar(content: Text(result["value"])));
    //       CustomSnackBar.CurrentBuildSnackBar(
    //           context, scaffoldKey, result["value"]);
    //       await Future.delayed(Duration(seconds: 2));
    //     }
    //     Constants.navigatePushAndRemove(SignInScreen(), context);
    //   } else {
    //     if (result["value"].toString().isNotEmpty) {
    //       // scaffoldKey.currentState
    //       //     .showSnackBar(SnackBar(content: Text(result["value"])));
    //       CustomSnackBar.CurrentBuildSnackBar(
    //           context, scaffoldKey, result["value"]);
    //     }
    //   }
    //
    //   isLoading = false;
    // } else {
    //   // scaffoldKey.currentState.showSnackBar(SnackBar(
    //   //     content: Text(StringLocalization.of(context)
    //   //         .getText(StringLocalization.enableInternet))));
    //
    //   CustomSnackBar.CurrentBuildSnackBar(
    //       context,
    //       scaffoldKey,
    //       StringLocalization.of(context)
    //           .getText(StringLocalization.enableInternet));
    // }
    // setState(() {});
  }
}
