import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/utils.dart';

class CreatePostScreenWidgets {
  static Future<void> showModalBottomSheetFunction({
    required BuildContext context,
    required photoOptions photo_option,
    required void Function(photoOptions, FileTypeOption) option,
    required bool isDark,
  }) async {
    showModalBottomSheet(
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: context,
        backgroundColor: isDark ? Colors.grey[800] : Colors.white,
        builder: (context) {
          return Container(
              height: getHeight(context: context) * 0.3,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: isDark ? Colors.white : Colors.black,
                    height: 5,
                    width: 30,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Choose Option',
                    style: GoogleFonts.nunito(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Divider(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListTile(
                      onTap: () {
                        option(photo_option, FileTypeOption.Image);
                      },
                      leading: Padding(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: Icon(
                          Icons.photo,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      title: Text(
                        photo_option == photoOptions.Camera
                            ? 'Take a photo'
                            : 'Select a photo',
                        style: GoogleFonts.nunito(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                  ListTile(
                      onTap: () {
                        option(photo_option, FileTypeOption.Video);
                      },
                      leading: Padding(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: Icon(
                          Icons.video_collection,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      title: Text(
                        photo_option == photoOptions.Camera
                            ? 'Make a video'
                            : 'Select a video',
                        style: GoogleFonts.nunito(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                ],
              ));
        });
  }
}
