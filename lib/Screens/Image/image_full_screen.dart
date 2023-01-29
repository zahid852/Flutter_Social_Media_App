import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/Resources/asset_manager.dart';
import 'package:social_media_app/Resources/color_manager.dart';

class FullImageScreen extends StatelessWidget {
  final String imagePath;
  FullImageScreen({required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Icon(
                Icons.close,
                color: ColorManager.white,
                size: 30,
              ),
            )),
      ),
      body: GestureDetector(
        child: Hero(
            tag: imagePath,
            child: Container(
              padding: const EdgeInsets.only(bottom: 100, top: 50),
              color: Colors.black,
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: CachedNetworkImage(
                    imageUrl: "${imagePath}",
                    placeholder: (context, url) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 70),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.white,
                                    size: 150,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  height: 50,
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 100),
                                  child: Text(
                                    "Couldn't load image. Check your internet connection.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            )),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
