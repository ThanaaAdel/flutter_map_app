import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_app/constant/strings.dart';
import 'app_router.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
late String initialRoute;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if(user == null){
      initialRoute = loginScreen;
    }
    else {
      initialRoute = homeMapScreen;
    }
  });
  runApp( MapApp(appRouter: AppRouter(),));
}
class MapApp extends StatelessWidget {
  final AppRouter appRouter;

  const MapApp({super.key, required this.appRouter});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute,
    );
  }
}
