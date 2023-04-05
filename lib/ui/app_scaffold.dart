import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../states/auth_state.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    this.title,
    this.body,
    super.key,
  });

  final String? title;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Event Poll'),
        centerTitle: true,
      ),
      floatingActionButton:
          context.read<AuthState>().currentUser?.isAdmin == true
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/polls/create', (_) => false);
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Color.fromARGB(255, 99, 174, 236),
                )
              : null,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(context.read<AuthState>().isLoggedIn
                  ? 'Bonjour ${context.read<AuthState>().currentUser?.username}'
                  : 'Bonjour'),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Événements'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/polls', (_) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Connexion'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Inscription'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/signup', (_) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                context.read<AuthState>().logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              },
            ),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: body,
      ),
    );
  }
}
