import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/injector.dart';
import 'core/config/routes/app_router.dart';
import 'core/utils/app_color.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Injection.inject(baseUrl: dotenv.get('BASE_URL'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Inject AuthBloc thông qua GetIt (đã đăng ký trong BlocModule)
        BlocProvider(create: (_) => sl<AuthBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Hustly',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.white),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.returnRouter(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'core/di/injector.dart';
// import 'core/config/routes/app_router.dart';
// import 'core/utils/app_color.dart';
// import 'features/auth/presentation/bloc/auth_bloc.dart';
// import 'features/auth/domain/usecases/auth_usecases.dart';
// import 'core/services/network_service.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await dotenv.load(fileName: ".env");
//   await Injection.inject(baseUrl: dotenv.get('BASE_URL'));

//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final NetworkService _networkService = NetworkService();

//   @override
//   void initState() {
//     super.initState();

//     // Đợi MaterialApp build xong mới init để tránh lỗi context
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _networkService.init(context);
//     });
//   }

//   @override
//   void dispose() {
//     _networkService.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => sl<AuthBloc>()),
//       ],
//       child: MaterialApp.router(
//         title: 'Hustly',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: AppColor.white),
//           useMaterial3: true,
//         ),
//         routerConfig: AppRouter.returnRouter(),
//         builder: (context, child) {
//           return MediaQuery(
//             data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//             child: child!,
//           );
//         },
//       ),
//     );
//   }
// }
