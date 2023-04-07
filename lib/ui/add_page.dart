import 'dart:io';

import 'package:event_poll/states/polls_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/poll.dart';
import 'package:file_picker/file_picker.dart';


class AddPage extends StatefulWidget {
  const AddPage({super.key, required Center child});
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String? _validateRequired(String? value) {
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null;
  }
  String _fileText="";

  late TextEditingController _dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  late TextEditingController _textDescriptionController =
      TextEditingController();
  late TextEditingController _textNameController = TextEditingController();
  late TimeOfDay initialTime = TimeOfDay.now();
  late DateTime _selectedDateTime = DateTime.now();

  void selecteDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate: DateTime.now(), // - not to allow to choose before today.
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      // ignore: use_build_context_synchronously
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );
      if (pickedDate != null && pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
        setState(() {
          _dateController.text =
              DateFormat('dd/MM/yyyy').format(_selectedDateTime);
        });
      }
    }
  }

  void _submit() async {
    final pollParam = await context.read<PollsState>().postPoll(
        _fileText,
        _textNameController.text,
        _textDescriptionController.text,
        _selectedDateTime);

    if (pollParam != null && mounted) {
      Navigator.of(context).pushReplacementNamed('/polls/detail', arguments: pollParam);
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['jpg','png'],
      allowMultiple: false,
    );

    if(result != null && result.files.single.path != null){
      File _file = File(result.files.single.path!);
      setState(() {
        _fileText = _file.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mq.size.width * 0.05, vertical: mq.size.height * 0.01),
        child: Column(
          children: [
            _fileText.length > 0 ? Image.file(new File(_fileText), width: 400) : const SizedBox(),
            TextFormField(
              controller: _textNameController,
              decoration: const InputDecoration(labelText: 'Nom'),
              validator: _validateRequired,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textDescriptionController,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Description',
              ),
            ),
            TextField(
                controller:
                    _dateController, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "jj/MM/yyyy" //label text of field
                    ),
                readOnly: true, // when true user cannot edit text
                onTap: () {
                  //action when user taps on textfield
                  selecteDate(context); // call method that has showDatePicker()
                }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _submit();
              },
              child: const Text('Enregistrer'),
            ),
            ElevatedButton(onPressed: _pickFile, child: Text('Ajouter une image de fond') ),
          ],
        ));
  }
}
