import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/bloc/bottle/bottle_bloc.dart';
import 'package:flutter_task/repositories/bottle_repository.dart';
import 'package:flutter_task/screens/bottle_deatiles_screen.dart';

import 'package:flutter_task/screens/my_collection_screen.dart';
import 'package:flutter_task/screens/sigin_in_screen.dart';

import 'package:flutter_task/screens/splash_screen.dart';
import 'package:flutter_task/screens/welcome_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    final hiveBox = await Hive.openBox('appCache');
    
    final sharedPreferences = await SharedPreferences.getInstance();
    final connectivity = Connectivity();

    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<BottleRepository>(
            create: (context) => BottleRepositoryImpl(
              sharedPreferences: sharedPreferences,
              connectivity: connectivity,
              hiveBox: hiveBox,
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    runApp(const ErrorApp());
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0B1519),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                'App Initialization Failed',
                style: GoogleFonts.ebGaramond(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please restart the application',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BottleBloc(
            repository: context.read<BottleRepository>(),
          )..add(FetchBottles()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whisky Collection',
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0B1519),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0B1519),
          textTheme: GoogleFonts.ebGaramondTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/signin': (context) => const SignInScreen(),
          '/collection': (context) => const MyCollectionScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/bottle') {
            final args = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => BottleDetailPage(bottleId: args),
            );
          }
          return null;
        },
      ),
    );
  }
}