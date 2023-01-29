import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/asset_manager.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/profile/profile_Setup/profile_model_view_state.dart';

import 'package:social_media_app/Screens/profile/profile_Setup/profile_setup_viewModel.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:social_media_app/Utils/update_user_info.dart';
import 'package:social_media_app/Utils/user_info_viewstate.dart';
import 'package:social_media_app/Utils/utils.dart';

class ProfileSetupFormWidget extends StatefulWidget {
  final BuildContext ProfileSetupFormScreenConext;
  final String profileSetup;
  final profileModelViewState? previousProfileModelViewState;
  ProfileSetupFormWidget(
      {required this.ProfileSetupFormScreenConext,
      required this.profileSetup,
      this.previousProfileModelViewState});
  @override
  State<ProfileSetupFormWidget> createState() => _ProfileSetupFormWidgetState();
}

class _ProfileSetupFormWidgetState extends State<ProfileSetupFormWidget> {
  final _signUpFormKey = GlobalKey<FormState>();
  ProfileSetupViewModel _profileViewModel = ProfileSetupViewModel();
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _birthdayEditingController = TextEditingController();
  TextEditingController _aboutEditingController = TextEditingController();
  bool _isLoading = false;
  final _toast = FToast();
  File? _image;
  String url = Empty;

  void _defaultCheck() {
    if (widget.profileSetup == profileSetup.Profile.toString()) {
      _nameEditingController.text =
          widget.previousProfileModelViewState?.name ?? '';
      _aboutEditingController.text =
          widget.previousProfileModelViewState?.about ?? '';
      _birthdayEditingController.text =
          widget.previousProfileModelViewState?.date ?? '';

      if (widget.previousProfileModelViewState!.imageUrl.isNotEmpty) {
        url = widget.previousProfileModelViewState?.imageUrl ?? Empty;
      }
    }
  }

  @override
  void initState() {
    _defaultCheck();
    _toast.init(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    _birthdayEditingController.dispose();
    _aboutEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _submitProfileForm() async {
    if (_image != null ||
        _nameEditingController.text.isNotEmpty ||
        _aboutEditingController.text.isNotEmpty ||
        _birthdayEditingController.text.isNotEmpty) {
      String downloadUrl = Empty;
      setState(() {
        _isLoading = true;
      });
      if (_image != null) {
        downloadUrl = await _profileViewModel.uploadFile(_image!);
        if (downloadUrl.isEmpty) {
          _toast.showToast(
              child: builtToast(
                  verdict: toastMessageVerdict.Error.toString(),
                  mes: _profileViewModel.message));
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      final String name = _nameEditingController.text;
      final String birthday = _birthdayEditingController.text;
      final String about = _aboutEditingController.text;
      final result = await _profileViewModel.saveProfile(
          name: name,
          about: about,
          date: birthday,
          imageUrl: _image != null ? downloadUrl : url);
      if (result) {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        if (widget.profileSetup == profileSetup.Profile.toString()) {
          if (_image != null) {
            final QuerySnapshot getPosts = await FirebaseFirestore.instance
                .collection('Posts')
                .where('userId', isEqualTo: userId)
                .get();
            getPosts.docs.forEach((element) async {
              await FirebaseFirestore.instance
                  .collection('Posts')
                  .doc(element.id)
                  .update({'userProfileUrl': downloadUrl});
            });
          }
          UpdateUserInfo.updateUserInfoData(
              user: userInfoViewState(
                  userId: userId,
                  username: logedinUserInfo.Username,
                  name: name,
                  about: about,
                  email: logedinUserInfo.Email,
                  b_date: birthday,
                  image_url: _image != null ? downloadUrl : url));
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context)
              .pushReplacementNamed(routes.mainScreensRoute, arguments: false);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _toast.showToast(
            child: builtToast(
                verdict: toastMessageVerdict.Error.toString(),
                mes: _profileViewModel.message));
      }
    } else {
      _toast.showToast(
          child: builtToast(
              verdict: toastMessageVerdict.Error.toString(),
              mes: 'All fields are empty. There is nothing to save'));
    }
  }

  Widget _getElevatedButton(
      {required BuildContext context,
      required String des,
      required ThemeProvider provider}) {
    return SizedBox(
        height: 55,
        width: getWidth(context: context) * 0.55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: des == 'Save' || des == 'Update' ? 3 : 0,
              backgroundColor: des == 'Save' || des == 'Update'
                  ? ColorManager.primeryColor
                  : provider.IsThemeStatusBlack
                      ? Colors.black
                      : ColorManager.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
          onPressed: () {
            if (des == 'Save' || des == 'Update') {
              _submitProfileForm();
            } else {
              _skip();
            }
          },
          child: Text(
            des,
            style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: des == 'Save' || des == 'Update'
                    ? FontWeight.w500
                    : FontWeight.bold,
                color: des == 'Save' || des == 'Update'
                    ? ColorManager.white
                    : ColorManager.primeryColor),
          ),
        ));
  }

  void _skip() {
    if (widget.profileSetup == profileSetup.Profile.toString()) {
      Navigator.of(context).pop(false);
    } else {
      Navigator.of(context)
          .pushReplacementNamed(routes.mainScreensRoute, arguments: false);
    }
  }

  void _getPhotoFromCamera() async {
    Navigator.of(context).pop();
    final imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null)
      setState(() {
        _image = File(pickedFile.path);
      });
  }

  void _getPhotoFromGallery() async {
    Navigator.of(context).pop();
    final imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null)
      setState(() {
        _image = File(pickedFile.path);
      });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsetsBottom =
        MediaQuery.of(widget.ProfileSetupFormScreenConext).viewInsets.bottom;
    bool isKeyboard = viewInsetsBottom != 0;

    return Consumer<ThemeProvider>(builder: (ctx, provider, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: isKeyboard ? 50 : 0,
          ),
          isKeyboard
              ? SizedBox.shrink()
              : Stack(
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: url.isNotEmpty && _image == null
                                  ? CachedNetworkImageProvider(url)
                                  : _image == null
                                      ? Image.asset(ImageAssets.emptyImage)
                                          .image
                                      : FileImage(_image!)),
                          color: ColorManager.shadowColor,
                          shape: BoxShape.circle),
                      width: 120,
                    ),
                    Positioned(
                        bottom: 7,
                        right: 7,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    titlePadding: const EdgeInsets.only(
                                        left: 30, right: 35, top: 30),
                                    title: Text(
                                      'Choose option',
                                      style: GoogleFonts.nunito(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        top: 20,
                                        bottom: 15,
                                        left: 10,
                                        right: 40),
                                    content: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            onTap: _getPhotoFromCamera,
                                            leading: const Icon(
                                              Icons.camera,
                                            ),
                                            minLeadingWidth: 25,
                                            title: Text(
                                              'Take a picture',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          ListTile(
                                            onTap: _getPhotoFromGallery,
                                            leading: Icon(Icons.photo),
                                            minLeadingWidth: 28,
                                            title: Text(
                                              'Photo from gallery',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                  child: Icon(
                                Icons.camera_alt_outlined,
                                color: ColorManager.white,
                              ))),
                        ))
                  ],
                ),
          SizedBox(
            height: isKeyboard ? 0 : 40,
          ),
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
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1.7,
                        blurRadius: 0,
                        color: ColorManager.shadowColor,
                        offset: const Offset(1.2, 0.9))
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
                      controller: _nameEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name',
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
                        controller: _aboutEditingController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'About',
                            hintStyle: GoogleFonts.nunito(
                                color: provider.IsThemeStatusBlack
                                    ? Colors.grey[200]
                                    : ColorManager.grey),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8))),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                        controller: _birthdayEditingController,
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  final DateTime? date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100));
                                  if (date != null) {
                                    _birthdayEditingController.text =
                                        DateFormat('dd/MM/yyyy').format(date);
                                  }
                                },
                                icon: Icon(
                                  Icons.date_range,
                                  color: ColorManager.primeryColor,
                                )),
                            hintText: 'Birthday',
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
            height: 30,
          ),
          Container(
            width: getWidth(context: context) * 0.8 - 40,
            child: Text('All fields are optional',
                style: GoogleFonts.nunito(
                    color: provider.IsThemeStatusBlack
                        ? Colors.grey[200]
                        : Colors.grey[400],
                    fontSize: 14)),
          ),
          SizedBox(
            height: isKeyboard ? 50 : 60,
          ),
          _isLoading
              ? const SizedBox(
                  height: 55,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _getElevatedButton(
                  context: context,
                  des: widget.profileSetup == profileSetup.Auth.toString()
                      ? 'Save'
                      : 'Update',
                  provider: provider),
          SizedBox(
            height: isKeyboard ? 0 : 15,
          ),
          if (!isKeyboard)
            _getElevatedButton(
                context: context, des: 'Skip', provider: provider)
        ],
      );
    });
  }
}
