import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:mi_anddes_mobile_app/constants.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/nav/nav.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), Constants.databaseName),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) async {
      Batch batch = db.batch();
      // Run the CREATE TABLE statement on the database.

      batch.execute(
          'CREATE TABLE tools(id INTEGER PRIMARY KEY, name TEXT, description TEXT,link TEXT, cover TEXT) ');
      batch.execute(
          'CREATE TABLE services(id INTEGER PRIMARY KEY, name TEXT, description TEXT,icon TEXT) ');
      batch.execute(
          'CREATE TABLE services_detail(id INTEGER PRIMARY KEY, description TEXT, title TEXT,service_id INTEGER) ');
      batch.execute(
          'CREATE TABLE elearning_content(id INTEGER PRIMARY KEY,name TEXT,image TEXT,finished INTEGER,started INTEGER,progress INTEGER,result INTEGER,sent INTEGER) ');
      batch.execute(
          'CREATE TABLE elearning_content_card(id INTEGER PRIMARY KEY,title TEXT,type TEXT,draft INTEGER,content TEXT,deleted INTEGER,position INTEGER,read INTEGER,date_read TEXT,elearning_content_id INTEGER) ');
      batch.execute(
          'CREATE TABLE elearning_content_card_option(id INTEGER PRIMARY KEY,description TEXT,correct INTEGER,checked INTEGER,elearning_content_card_id INTEGER) ');
      batch.execute(
          'CREATE TABLE first_day_information_item(id INTEGER PRIMARY KEY,title TEXT,description TEXT,body TEXT,addFromServices INTEGER,type TEXT, icon TEXT) ');
      batch.execute(
          'CREATE TABLE ceo_presentation(id INTEGER PRIMARY KEY, urlVideo TEXT, urlPoster TEXT) ');
      batch.execute(
          'CREATE TABLE onsite_induction(id INTEGER PRIMARY KEY, description TEXT) ');
      batch.execute(
          'CREATE TABLE remote_induction(id INTEGER PRIMARY KEY, description TEXT) ');
      batch.execute(
          'CREATE TABLE team_member(id INTEGER PRIMARY KEY, dni TEXT, image TEXT,fullname TEXT,job TEXT,email TEXT,onItinerary INTEGER,hobbies TEXT,roles TEXT,dateCreated TEXT) ');
      batch.execute(
          'CREATE TABLE processes(id INTEGER PRIMARY KEY,startDate INTEGER,status INTEGER,finished INTEGER,delayed INTEGER,welcomed INTEGER,hourOnsite TEXT,placeOnsite TEXT,hourRemote TEXT,linkRemote TEXT) ');
      batch.execute(
          'CREATE TABLE processes_activities(id INTEGER PRIMARY KEY,activity_id INTEGER,activity_code TEXT,activity_name TEXT,activity_parent TEXT,activity_parent_code TEXT,activity_manual INTEGER,completed INTEGER,completionDate STRING) ');
      await batch.commit();
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = MiAnddesTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        MiAnddesTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'my-anddes',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
