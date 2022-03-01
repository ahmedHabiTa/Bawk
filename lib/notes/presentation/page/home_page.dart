import 'package:bawq/core/util/sqflite_helper.dart';
import 'package:bawq/notes/presentation/page/edit_note_page.dart';
import 'package:bawq/notes/presentation/page/options_screen.dart';
import 'package:bawq/notes/presentation/provider/notes_provider.dart';
import 'package:bawq/notes/presentation/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_user_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool searched = false;

  @override
  void initState() {
    super.initState();
    Provider.of<NotesProvider>(context, listen: false).getAllNotes();
    Provider.of<NotesProvider>(context, listen: false).getAllUsers();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>  EditNoteScreen(
                noteData: {},
              ),
            ),
          );

        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Notes'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddUserScreen(),
                ),
              );
            },
            child: const Icon(Icons.person_add),
          ),
          const SizedBox(
            width: 12,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OptionsScreen(),
                ),
              );
            },
            child: const Icon(Icons.settings),
          ),
          const SizedBox(
            width: 12,
          ),
          const Icon(Icons.sort),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, prov, _) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: prov.checkList().isEmpty
                ? Column(
                    children: const [
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                          child: CircularProgressIndicator(
                        color: Colors.indigo,
                      )),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.filter_list,
                                color: Colors.indigo,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      searched = !searched;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.search,
                                    color: Colors.indigo,
                                    size: 25,
                                  )),
                              const SizedBox(
                                width: 6,
                              ),
                              if (searched == true)
                                Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    const Positioned(
                                      right: 10,
                                      child: Icon(Icons.clear),
                                    ),
                                    CustomFormField(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      hintText: 'forget',
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: prov.checkList().length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Text(
                                        prov.checkList()[index].text,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        if(prov.isLocal == true){
                                          (){};
                                        }else{
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => EditNoteScreen(
                                                noteData: {
                                                  'id': prov.notes[index].id,
                                                  'Text': prov.notes[index].text,
                                                  'UserId':
                                                  prov.notes[index].userId,
                                                  'PlaceDateTime': prov
                                                      .notes[index].placeDateTime,
                                                },
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Icon(Icons.edit),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                              const Divider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
