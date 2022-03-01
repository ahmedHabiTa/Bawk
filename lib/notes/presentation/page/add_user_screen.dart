import 'dart:io';

import 'package:bawq/core/size_config.dart';
import 'package:bawq/notes/presentation/provider/notes_provider.dart';
import 'package:bawq/notes/presentation/widget/custom_text_form_field.dart';
import 'package:bawq/notes/presentation/widget/image_picker_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final emailController = TextEditingController();
  String? interestId ;
  @override
  void initState() {
    super.initState();
    Provider.of<NotesProvider>(context,listen: false).getAllInterests();
  }
  @override
  Widget build(BuildContext context) {
    final noteProv = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title:const Text('Add User'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                const ProfileImage(),
                const SizedBox(
                  height: 5,
                ),
               const Text(
                  'Select Image',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      wordSpacing: 1.5,
                      letterSpacing: 1.2),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomFormField(
                  controller: usernameController,
                  validation: 'Cannot be empty',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 22, horizontal: 10),
                  labelText: 'User Name',
                  hintText: '',
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomFormField(
                  controller: passwordController,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 22, horizontal: 10),
                  hintText: 'password',
                  labelText: 'Password',
                  security: true,
                  suffixBool: true,
                  validation:
                      'password should have alphabet and numbers \n with minimum length of 8 chars',
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomFormField(
                  controller: emailController,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 22, horizontal: 10),
                  hintText: 'email',
                  labelText: 'Email',
                  validation: 'Incorrect Email',
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: DropdownButtonFormField(
                      onTap: () => FocusScope.of(context).unfocus(),
                      validator: (value) {
                        if (value == null) {
                          return 'Field cannot be empty';
                        }
                        return null;
                      },
                      isExpanded: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[50],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Colors.black87,
                          ),
                        ),
                        hintText: 'Interest',
                      ),
                      items: noteProv.interests
                          .map(
                            (e) => DropdownMenuItem(
                          child: Row(
                            children: [
                              Text(
                                e.intrestText,
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          value: e.id.toString(),
                        ),
                      )
                          .toList(),
                      onSaved: (value) {},
                      onChanged: (value) {
                        setState(() {
                          interestId = value.toString();
                        });
                        print(interestId.toString());
                      }),
                ),
                const SizedBox(
                  height: 15,
                ),
                noteProv.loading == true
                    ?const CircularProgressIndicator(
                        color: Colors.indigo,
                      )
                    : GestureDetector(
                        onTap: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          if (Provider.of<NotesProvider>(
                            context,
                            listen: false,
                          ).isPicked) {
                            await Provider.of<NotesProvider>(
                              context,
                              listen: false,
                            ).addUser(
                              context: context,
                              username: usernameController.text,
                              password: passwordController.text,
                              email: emailController.text,
                              interestId: interestId!,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("please pick image"),
                              backgroundColor: Colors.red,
                            ));
                          }
                          // await Provider.of<NotesProvider>(context,listen: false).addNote();
                        },
                        child: Material(
                          elevation: 7,
                          borderRadius: BorderRadius.circular(8.0),
                          shadowColor: Colors.black87,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.88,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child:const Center(
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Provider.of<NotesProvider>(context, listen: false).imageUrl = _image;
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await getImage();
      },
      child: Container(
        alignment: Alignment.center,
        height: 100,
        width: 100,
        child: Stack(
          children: [
            const SizedBox(
              height: 120,
              width: 120,
              // color: Colors.red,
            ),
            _image == null
                ? SizedBox(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Image.asset(
                          "assets/images/profile.png",
                          fit: BoxFit.fill,
                        )))
                : SizedBox(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: Image.file(
                        File(_image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
