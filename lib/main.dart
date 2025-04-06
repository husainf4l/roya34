import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/app_theme.dart';
import 'screens/home_page.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';

bool _initialUriIsHandled = false;

// Global variable to store deep link data for use across the app
Map<String, dynamic> deepLinkData = {};

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// Handle incoming links - both initial and dynamic links
Future<void> initUniLinks() async {
  // Handle app start by deep link
  if (!_initialUriIsHandled) {
    _initialUriIsHandled = true;
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        // Process the initial URI
        _handleDeepLink(initialUri);
      }
    } on PlatformException catch (e) {
      // Handle exception
      print('Failed to get initial uri: ${e.message}');
    } on MissingPluginException catch (e) {
      print('Missing plugin exception: ${e.message}');
    }
  }

  // Handle links opened while app is running
  try {
    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      print('Error in URI link stream: $err');
    });
  } on MissingPluginException catch (e) {
    print('Missing plugin for uri_links stream: ${e.message}');
  }
}

void _handleDeepLink(Uri uri) {
  print('Received URI: $uri');

  try {
    // Basic validation
    if (uri.toString().isEmpty) {
      print('Empty URI received');
      return;
    }

    // Store the raw URI data for debugging
    deepLinkData['rawUri'] = uri.toString();

    // Process URI parameters based on path
    if (uri.path.contains('xMBOHp0pON8')) {
      final queryParams = uri.queryParameters;
      print('Query parameters: $queryParams');

      // Store important parameters in the global map
      deepLinkData['path'] = 'xMBOHp0pON8';
      deepLinkData['params'] = queryParams;

      // Check for specific required parameters
      if (queryParams.containsKey('token')) {
        deepLinkData['token'] = queryParams['token'];
      }

      if (queryParams.containsKey('action')) {
        deepLinkData['action'] = queryParams['action'];
        // You can trigger different flows based on action
      }
    } else {
      // Handle other paths
      print('Unrecognized path in deep link: ${uri.path}');
      deepLinkData['path'] = uri.path;
      deepLinkData['params'] = uri.queryParameters;
    }
  } catch (e) {
    print('Error processing deep link: $e');
    deepLinkData['error'] = e.toString();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize deep link handling after the app is initialized
    initUniLinks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رؤية ٣٤',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'),
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: FutureBuilder<bool>(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: AppTheme.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.aiBlue,
                            AppTheme.aiSoftPurple,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "رؤية",
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          }
          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn
              ? const MyHomePage(title: 'رؤية ٣٤')
              : const LoginScreen();
        },
      ),
    );
  }
}
