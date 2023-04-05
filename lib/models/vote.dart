import 'package:event_poll/models/user.dart';

class Vote {
  Vote({
    required this.pollId,
    required this.status,
    required this.dateCreated,
    required this.user,
  });

  int pollId;
  bool status;
  DateTime dateCreated;
  User user;

  Vote.fromJson(Map<String, dynamic> json)
      : this(
          pollId: json['pollId'] as int,
          status: json['status'] as bool,
          dateCreated: DateTime.parse(json['created'] as String),
          user: User.fromJson(json['user'] as Map<String, dynamic>),
        );
}
