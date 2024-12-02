import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:smart/auth/presentation/pages/login_page.dart';
import 'package:smart/ui/controller_page.dart';
import 'auth/data/datasorce/authentication_remote_ds/authentication.dart';
import 'auth/data/datasorce/user_remote_ds/user_remote_ds.dart';
import 'auth/presentation/bloc/auth_bloc/authentication_bloc.dart';
import 'auth/presentation/bloc/user_data_bloc/user_data_bloc.dart';
import 'auth/presentation/pages/sign_up_page.dart';
import 'core/networks/network_info.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await AuthenticationRemoteDsImpl(
  //             networkInfo:
  //                 NetworkInfoImpl(connectionChecker: InternetConnectionChecker()))
  //         .signOut();
  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => AuthBloc(
                  usersDBModel: UsersRemoteDsImp(),
                  authenticationRemoteDs: AuthenticationRemoteDsImpl(
                      networkInfo: NetworkInfoImpl(
                          connectionChecker: InternetConnectionChecker())),
                  networkInfo: NetworkInfoImpl(
                      connectionChecker: InternetConnectionChecker()))),
          BlocProvider(
              create: (_) => UserBloc(
                  usersDBModel: UsersRemoteDsImp(),
                  authinticationRemoteDs: AuthenticationRemoteDsImpl(
                      networkInfo: NetworkInfoImpl(
                          connectionChecker: InternetConnectionChecker())))),
        ],
        child: MyApp(),
      )
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}


