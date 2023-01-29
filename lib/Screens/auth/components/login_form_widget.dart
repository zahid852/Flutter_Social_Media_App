import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/auth/view_models/auth_view_model.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/utils.dart';
import 'package:social_media_app/main.dart';

class loginFormWidget extends StatefulWidget {
  final BuildContext loginScreenConext;
  loginFormWidget({required this.loginScreenConext});

  @override
  State<loginFormWidget> createState() => _loginFormWidgetState();
}

class _loginFormWidgetState extends State<loginFormWidget> {
  final _loginFormKey = GlobalKey<FormState>();
  authViewModel _authViewModel = authViewModel();
  TextEditingController _emailEditingController = TextEditingController();

  TextEditingController _passwordEditingController = TextEditingController();
  bool _isLoading = false;
  final _toast = FToast();
  bool _isPasswordObscureText = true;
  bool isEmailVerified = false;
  bool isPasswordVerified = false;
  @override
  void initState() {
    _toast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  void _submitLoginForm() async {
    final validate = _loginFormKey.currentState!.validate();
    if (validate && isEmailVerified && isPasswordVerified) {
      _loginFormKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final String email = _emailEditingController.text;

      final String password = _passwordEditingController.text;
      final result =
          await _authViewModel.loginUser(email: email, password: password);
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
        MediaQuery.of(widget.loginScreenConext).viewInsets.bottom;
    bool isKeyboard = viewInsetsBottom != 0;
    return Consumer<ThemeProvider>(builder: (ctx, provider, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _loginFormKey,
            child: Container(
              width: getWidth(context: context),
              margin: EdgeInsets.symmetric(
                  horizontal: getWidth(context: context) * 0.1),
              decoration: BoxDecoration(
                  color: provider.IsThemeStatusBlack
                      ? Colors.grey[900]
                      : Colors.white,
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
                      controller: _emailEditingController,
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
                        controller: _passwordEditingController,
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
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: getWidth(context: context) * 0.1),
              child: TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsetsDirectional.all(0)),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(routes.resetPasswordPageRoute);
                  },
                  child: Text('Forgot Password?',
                      style: GoogleFonts.nunito(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500))),
            ),
          ),
          SizedBox(
            height: isKeyboard ? 40 : 70,
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
                      _submitLoginForm();
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.nunito(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  )),
        ],
      );
    });
  }
}
