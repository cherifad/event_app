import 'package:event_poll/states/polls_state.dart';
import 'package:event_poll/ui/details_page.dart';
import 'package:event_poll/ui/edit_page.dart';
import 'package:event_poll/ui/login_page.dart';
import 'package:event_poll/ui/polls_page.dart';
import 'package:event_poll/ui/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'models/poll.dart';
import 'states/auth_state.dart';
import 'ui/app_scaffold.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => AuthState(),
      ),
      ChangeNotifierProxyProvider<AuthState, PollsState>(
        create: (_) => PollsState(),
        update: (_, authState, pollState) =>
            pollState!..setToken(authState.token),
      ),
    ], child: const App()),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Poll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      supportedLocales: const [Locale('fr')],
      locale: const Locale('fr'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: '/polls',
      routes: {
        '/polls': (context) => const AppScaffold(
              title: 'Événements',
              body: PollsPage(child: Center(child: Text('POLLS'))),
            ),
        '/polls/create': (context) => const AppScaffold(
              title: 'Ajouter un événement',
              body: Placeholder(child: Center(child: Text('POLLS_CREATE'))),
            ),
        '/polls/detail': (context) {
          final Poll poll = ModalRoute.of(context)!.settings.arguments as Poll;
          return AppScaffold(
              title: 'Événement',
              body: DetailsPage(child: Center(child: Text('POLLS_DETAIL')), poll: poll,),
            );
        },
        '/polls/update': (context) {
          final Poll poll = ModalRoute.of(context)!.settings.arguments as Poll;
          return AppScaffold(
              title: 'Modifier un événement',
              body: EditPage(child: Center(child: Text('POLLS_UPDATE')), poll: poll),
            );
        },
        '/login': (context) => const AppScaffold(
              title: 'Connexion',
              body: LoginPage(child: Center(child: Text('LOGIN'))),
            ),
        '/signup': (context) => const AppScaffold(
              title: 'Inscription',
              body: RegisterPage(child: Center(child: Text('SIGNUP'))),
            ),
      },
    );
  }
}
