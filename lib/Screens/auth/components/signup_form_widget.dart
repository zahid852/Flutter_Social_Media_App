import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/auth/view_models/auth_view_model.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/utils.dart';
import 'package:social_media_app/main.dart';
import '../../../resources/color_manager.dart';

class SignUpFormWidget extends StatefulWidget {
  final BuildContext signUpScreenConext;
  SignUpFormWidget({required this.signUpScreenConext});
  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final _signUpFormKey = GlobalKey<FormState>();
  authViewModel _authViewModel = authViewModel();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _usernameEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  bool _isLoading = false;
  FToast _toast = FToast();
  bool _isPasswordObscureText = true;
  bool isEmailVerified = false;
  bool isPasswordVerified = false;
  bool isUsernameVerified = false;

  @override
  void initState() {
    _toast.init(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();

    _passwordEditingController.dispose();
    _usernameEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _submitSignUpForm() async {
    final validate = _signUpFormKey.currentState!.validate();
    if (validate &&
        isEmailVerified &&
        isUsernameVerified &&
        isPasswordVerified) {
      _signUpFormKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final String email = _emailEditingController.text;
      final String username = _usernameEditingController.text;
      final String password = _passwordEditingController.text;
      final result = await _authViewModel.signUpUser(
          email: email, username: username, password: password);
      if (!result) {
        _toast.showToast(
            child: builtToast(
                verdict: toastMessageVerdict.Error.toString(),
                mes: _authViewModel.message));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsetsBottom =
        MediaQuery.of(widget.signUpScreenConext).viewInsets.bottom;
    bool isKeyboard = viewInsetsBottom != 0;

    return Consumer<ThemeProvider>(builder: (ctx, provider, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _signUpFormKey,
            child: Container(
              width: getWidth(context: context),
              margin: EdgeInsets.symmetric(
                  horizontal: getWidth(context: context) * 0.1),
              decoration: BoxDecoration(
                  color: provider.IsThemeStatusBlack
                      ? Colors.grey[900]
                      : ColorManager.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 1,
                        color: provider.IsThemeStatusBlack
                            ? Colors.grey
                            : ColorManager.shadowColor,
                        offset: const Offset(1, 1))
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: ColorManager.shadowColor))),
                    child: TextFormField(
                      controller: _emailEditingController,
                      validator: (email) {
                        if (!isEmailValid(email!)) {
                          _toast.showToast(
                              child: builtToast(
                                  verdict: toastMessageVerdict.Error.toString(),
                                  mes: 'Email is not valid.'));
                          isEmailVerified = false;
                        } else {
                          isEmailVerified = true;
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: GoogleFonts.nunito(
                            color: provider.IsThemeStatusBlack
                                ? Colors.grey[200]
                                : ColorManager.grey),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: ColorManager.shadowColor))),
                    child: TextFormField(
                        controller: _usernameEditingController,
                        validator: (username) {
                          if (username!.length < 3) {
                            _toast.showToast(
                                child: builtToast(
                                    verdict:
                                        toastMessageVerdict.Error.toString(),
                                    mes:
                                        'Username length must be at least 3 characters'));

                            isUsernameVerified = false;
                          } else {
                            isUsernameVerified = true;
                          }
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Username',
                            hintStyle: GoogleFonts.nunito(
                                color: provider.IsThemeStatusBlack
                                    ? Colors.grey[200]
                                    : ColorManager.grey),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8))),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: ColorManager.shadowColor))),
                    child: TextFormField(
                        controller: _passwordEditingController,
                        textAlignVertical: TextAlignVertical.center,
                        validator: (password) {
                          if (password!.length < 6) {
                            _toast.showToast(
                                child: builtToast(
                                    verdict:
                                        toastMessageVerdict.Error.toString(),
                                    mes:
                                        'Password length must be at least 6 characters'));
                            isPasswordVerified = false;
                          } else {
                            isPasswordVerified = true;
                          }
                        },
                        obscureText: _isPasswordObscureText,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordObscureText =
                                        !_isPasswordObscureText;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordObscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: provider.IsThemeStatusBlack
                                      ? Colors.grey[200]
                                      : ColorManager.grey,
                                )),
                            hintText: 'Password',
                            hintStyle: GoogleFonts.nunito(
                                color: provider.IsThemeStatusBlack
                                    ? Colors.grey[200]
                                    : ColorManager.grey),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8))),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: isKeyboard ? 50 : 100,
          ),
          _isLoading
              ? const SizedBox(
                  height: 55,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SizedBox(
                  height: 55,
                  width: getWidth(context: context) * 0.55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                    onPressed: () {
                      _submitSignUpForm();
                    },
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.nunito(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  )),
        ],
      );
    });
  }
}
