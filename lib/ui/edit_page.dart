import 'package:event_poll/states/polls_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/poll.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required Center child, required this.poll});
  final Poll poll;
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String? _validateRequired(String? value) {
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null;
  }

  late TextEditingController _dateController;
  late TextEditingController _textController;
  late TimeOfDay initialTime;
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _dateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(widget.poll.eventDate));
    initialTime = TimeOfDay.fromDateTime(widget.poll.eventDate);
    _selectedDateTime = widget.poll.eventDate;
    _textController = TextEditingController(text: widget.poll.description);
  }

  void selecteDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: widget.poll.eventDate, //get today's date
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
    widget.poll.description = _textController.text;
    widget.poll.eventDate = _selectedDateTime;
    final pollParam = await context.read<PollsState>().putPoll(widget.poll);

    if (pollParam != null) {
      Navigator.of(context).pop();
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
            TextFormField(
              initialValue: widget.poll.name,
              decoration: const InputDecoration(labelText: 'Nom'),
              onChanged: (value) => widget.poll.name = value,
              validator: _validateRequired,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter text',
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
          ],
        ));
  }
}
