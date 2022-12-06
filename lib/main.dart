import 'dart:async';
import 'package:flutter/material.dart';

class LanguageBloc extends ChangeNotifier {
  StreamController<String> _languageController = StreamController<String>();

  Stream<String> get languageStream => _languageController.stream;
  String _selectedLanguage = 'en';

  String get selectedLanguage => _selectedLanguage;

  void changeLanguage(String language) {
    _selectedLanguage = language;
    _languageController.sink.add(_selectedLanguage);
    notifyListeners();
  }

  static LanguageBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType <LanguageBlocProvider>()!.bloc;
  }

  @override
  void dispose() {
    _languageController.close();
    super.dispose();
  }
}

class LanguageBlocProvider extends InheritedWidget {
  final LanguageBloc bloc;

  LanguageBlocProvider({super.key,  required Widget child})
      : bloc = LanguageBloc(),
        super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LanguageBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType <LanguageBlocProvider>()!.bloc;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final languageBloc = LanguageBlocProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Multi-Language App"),
      ),
      body: StreamBuilder(
        stream: languageBloc.languageStream,
        initialData: languageBloc.selectedLanguage,
        builder: (context, snapshot) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => languageBloc.changeLanguage("fr"),
                      child: Text("fr"),
                    ),
                    ElevatedButton(
                      onPressed: () => languageBloc.changeLanguage("en"),
                      child: Text("eng"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: Text("Selected Language: ${snapshot.data}"),
                ),
              ],

          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LanguageBlocProvider(
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

void main() => runApp(MyApp());

