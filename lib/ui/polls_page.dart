import 'package:event_poll/states/polls_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../states/auth_state.dart';
import 'package:provider/provider.dart';

class PollsPage extends StatefulWidget {
  const PollsPage({super.key, required Center child});

  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  @override
  Widget build(BuildContext context) {
    context.read<PollsState>().fetchPolls();
    final polls = context.watch<PollsState>().polls;
    final mq = MediaQuery.of(context);
    return ListView.builder(
      itemCount: polls.length,
      itemBuilder: (context, index) {
        final poll = polls[index];
        return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/polls/detail',
                      arguments: poll);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mq.size.width * 0.05,
                      vertical: mq.size.height * 0.01),
                  child: Card(
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(
                            child: ListTile(
                              title: Text(poll.name),
                              subtitle: Text(poll.description),
                              // leading: poll.imageName != null
                              //     ? Image.network(
                              //         'https://event-poll-api.herokuapp.com/images/${poll.imageName}',
                              //         width: 100,
                              //         height: 100,
                              //         fit: BoxFit.cover,
                              //       )
                              //     : const SizedBox.shrink(),
                            ),
                          ),
                          Text(DateFormat.yMMMMd('fr_FR')
                              .format(poll.eventDate)),
                          const SizedBox(width: 8),
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/polls/detail',
                                    arguments: poll);
                              },
                              child: const Text('Voir'),
                            ),
                            const SizedBox(width: 8),
                            context.read<AuthState>().currentUser?.isAdmin ==
                                    true
                                ? Row(children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/polls/update',
                                            arguments: poll);
                                      },
                                      child: const Text('Modifier'),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () {
                                        context
                                            .read<PollsState>()
                                            .deletePoll(poll);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 24.0,
                                      ),
                                      label: Text('Supprimer'),
                                    ),
                                  ])
                                : const SizedBox.shrink(),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                )));
      },
    );
  }
}
