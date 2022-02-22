import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({Key? key, this.image, this.width, this.height})
      : super(key: key);
  final File? image;
  final double? width, height;

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? image;

  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  static Future<File?> getImageFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      debugPrint('No image selected.');
    }
  }

  Future getImage() async {
    image = await getImageFile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        height: widget.height!,
        width: widget.width,
        child: Stack(children: [
          image == null
              ? Image.asset(
                  "assets/images/profile.png",
            fit: BoxFit.fill,
                )
              : Container(
                  height: widget.height,
                  width: widget.width,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.9),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                        image!,
                        fit: BoxFit.fill,
                      ))),
        ]));
  }
}
