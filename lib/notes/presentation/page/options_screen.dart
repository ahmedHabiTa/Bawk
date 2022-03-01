import 'package:bawq/notes/presentation/provider/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({Key? key}) : super(key: key);

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  bool _value = false;

  void _onChanged(bool value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Options'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 275,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use Local Database',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                      Text(
                        'instead of using HTTP call to work wih the app data ,Please use SQLite',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Switch(
                activeColor: Colors.indigo,
                value: _value,
                onChanged: (bool value) {
                  Provider.of<NotesProvider>(context,listen: false).changeDataState(context);
                  _onChanged(value);
                },
              ),
            ],
          ),
          Divider(
            thickness: 2,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
