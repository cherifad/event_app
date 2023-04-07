import 'dart:io';

import 'package:event_poll/states/auth_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../configs.dart';
import '../models/poll.dart';
import '../models/vote.dart';
import '../states/polls_state.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required Center child, required this.poll});
  final Poll poll;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  void submitVote(bool status) async {
    await context.read<PollsState>().postVote(widget.poll.id, status);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    context.read<PollsState>().fetchVotes(widget.poll.id);
    final List<Vote> votes = context.watch<PollsState>().votes;

    final indexUserVote = context.read<AuthState>().isLoggedIn == true
        ? votes.indexWhere((element) =>
            element.user.id == context.read<AuthState>().currentUser!.id)
        : -1;

    final userVote = indexUserVote != -1 ? votes[indexUserVote] : null;

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mq.size.width * 0.05, vertical: mq.size.height * 0.01),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          widget.poll.imageName != null
              ? Image.network(
                  '${Configs.baseUrl}/images/${widget.poll.imageName!}',
                  width: 400)
              : const SizedBox(),
          Center(
            child: Text(
              widget.poll.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            DateFormat.yMMMMEEEEd('fr_FR').format(widget.poll.eventDate),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.poll.description,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const Divider(
            color: Colors.black,
            height: 50,
            thickness: 1,
          ),
          Text(
            'Participants (${votes.where((element) => element.status).length})',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          indexUserVote == -1 && context.read<AuthState>().isLoggedIn == true
              ? Row(
                  children: [
                    Expanded(
                      child:
                          Text(context.read<AuthState>().currentUser!.username),
                    ),
                    ToggleButtons(
                      isSelected: [false, false],
                      onPressed: (int index) async {
                        submitVote(index == 0);
                      },
                      children: const [
                        Icon(Icons.check, color: Colors.green),
                        Icon(Icons.close, color: Colors.red),
                      ],
                    ),
                  ],
                )
              : const SizedBox(),
          ListView.builder(
            itemCount: votes.length,
            itemBuilder: (context, index) {
              final vote = votes[index];
              return Row(
                children: [
                  Expanded(
                    child: Text(vote.user.username),
                  ),
                  context.read<AuthState>().isLoggedIn == true &&
                          context.read<AuthState>().currentUser!.id ==
                              vote.user.id
                      ? const SizedBox()
                      : Icon(
                          vote.status ? Icons.check : Icons.close,
                          color: vote.status ? Colors.green : Colors.red,
                        ),
                  context.read<AuthState>().isLoggedIn == true &&
                          context.read<AuthState>().currentUser!.id ==
                              vote.user.id
                      ? ToggleButtons(
                          isSelected: [vote.status, !vote.status],
                          onPressed: (int index) async {
                            await context
                                .read<PollsState>()
                                .postVote(widget.poll.id, index == 0);
                            context
                                .read<PollsState>()
                                .fetchVotes(widget.poll.id);
                          },
                          children: const [
                            Icon(Icons.check, color: Colors.green),
                            Icon(Icons.close, color: Colors.red),
                          ],
                        )
                      : const SizedBox(),
                ],
              );
            },
            shrinkWrap: true,
          )
        ]));
  }
}
