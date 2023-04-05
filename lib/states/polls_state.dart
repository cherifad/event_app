import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../configs.dart';
import '../models/poll.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class PollsState extends ChangeNotifier {
  String? _token;

  List<Poll> _polls = [];
  List<Poll> get polls => _polls;

  void setToken(String? token) {
    _token = token;
  }

  Future<void> fetchPolls() async {
    final response = await http.get(
      Uri.parse('${Configs.baseUrl}/polls'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      _polls = (json.decode(response.body) as List)
          .map((e) => Poll.fromJson(e))
          .toList();
      notifyListeners();
    }
  }

  Future<Poll?> putPoll(Poll poll) async {
    DateTime parsedDate = DateTime.parse(poll.eventDate.toString());
    String outputDate = parsedDate.toUtc().toIso8601String();
    final putResponse = await http.put(
      Uri.parse('${Configs.baseUrl}/polls/${poll.id}'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({
        "name": poll.name,
        "description": poll.description,
        "eventDate": outputDate
      }),
    );

    if (putResponse.statusCode == HttpStatus.ok) {
      final poll = Poll.fromJson(json.decode(putResponse.body));
      _polls = _polls.map((e) => e.id == poll.id ? poll : e).toList();
      notifyListeners();
      return poll;
    } else {
      return null;
    }
  }

  Future<bool> deletePoll(Poll poll) async {
    final deleteResponse = await http
        .delete(Uri.parse('${Configs.baseUrl}/polls/${poll.id}'), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    });

    if (deleteResponse.statusCode == HttpStatus.noContent) {
      _polls = _polls.where((e) => e.id != poll.id).toList();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
