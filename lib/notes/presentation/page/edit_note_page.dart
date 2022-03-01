import 'package:bawq/notes/presentation/provider/notes_provider.dart';
import 'package:bawq/notes/presentation/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EditNoteScreen extends StatefulWidget {
  Map<String, dynamic> noteData;

  EditNoteScreen({
    required this.noteData,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final noteController = TextEditingController();
  String? userId;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, noteProv, _) {
        return Form(
          key: formKey,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigo,
              title: const Text('Add Note'),
              actions: [
                noteProv.loading == true
                    ? const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          if (!formKey.currentState!.validate() ||
                              noteController.text.isEmpty) {
                            return;
                          }
                          widget.noteData.isEmpty
                              ? await noteProv.addNote(
                                  noteContent: noteController.text,
                                  userId: userId!,
                                  context: context)
                              : await noteProv.updateNote(
                                  id: widget.noteData['id'],
                                  text: noteController.text,
                                  userId: widget.noteData['UserId'] ?? '1',
                                  context: context,
                                );
                          ;
                          Fluttertoast.showToast(
                              msg: 'Inserted Successfully',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        child: const Icon(Icons.save),
                      ),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    widget.noteData == {}
                        ? Center(
                            child: CustomFormField(
                              controller: noteController,
                              validation: 'Note Cannot be empty',
                              labelText: 'Note',
                              hintText: '',
                              maxLine: 10,
                            ),
                          )
                        : Center(
                            child: CustomFormField(
                              onChanged: (v) {
                                setState(() {
                                  noteController.text = v;
                                });
                              },
                              validation: 'Note Cannot be empty',
                              labelText: 'Note',
                              initialValue: widget.noteData['Text'],
                              hintText: '',
                              maxLine: 10,
                            ),
                          ),
                    const SizedBox(
                      height: 10,
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
                            hintText: 'Assign To User',
                          ),
                          items: noteProv.users
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Row(
                                    children: [
                                      Text(
                                        e.username,
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
                              userId = value.toString();
                            });
                            print(userId.toString());
                          }),
                    ),
                    // Container(
                    //   // height: 60,
                    //   width: MediaQuery.of(context).size.width * 0.9,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(8.0),
                    //       color: Colors.grey.withOpacity(0.02),
                    //       border: Border.all(width: 1)),
                    //   child: ExpansionTile(
                    //     onExpansionChanged: (value) {
                    //       // setState(() {
                    //       //   serviceProvider = value;
                    //       // });
                    //     },
                    //     backgroundColor: Colors.white,
                    //     tilePadding: const EdgeInsets.symmetric(
                    //       horizontal: 10.0,
                    //     ),
                    //     title: const Text('Mohammed'),
                    //     children: List.generate(noteProv.users.length, (index) {
                    //       return ListTile(
                    //           title: Text(noteProv.users[index].username));
                    //       // Text(noteProv.users[index].username);
                    //     }),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
