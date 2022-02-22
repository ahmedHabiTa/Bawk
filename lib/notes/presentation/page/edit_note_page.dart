import 'package:bawq/notes/presentation/provider/notes_provider.dart';
import 'package:bawq/notes/presentation/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({Key? key}) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final noteController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context,noteProv,_){
        return Form(
          key: formKey,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigo,
              title: const Text('Add Note'),
              actions: [
                noteProv.loading == true
                    ? const Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    : GestureDetector(
                  onTap: () async{
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    await noteProv.addNote(
                        noteContent: noteController.text, context: context);
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
                    Center(
                      child: CustomFormField(
                        controller: noteController,
                        validation: 'Note Cannot be empty',
                        labelText: 'Note',
                        hintText: '',
                        maxLine: 10,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                     // height: 60,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey.withOpacity(0.02),
                          border: Border.all(width: 1)),
                      child: ExpansionTile(
                        onExpansionChanged: (value) {
                          // setState(() {
                          //   serviceProvider = value;
                          // });
                        },
                        backgroundColor: Colors.white,
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        title: const Text('Mohammed'),
                        children: List.generate(noteProv.users.length, (index) {
                          return ListTile(title: Text(noteProv.users[index].username));
                           // Text(noteProv.users[index].username);
                        }),
                      ),
                    ),
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
