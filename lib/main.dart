import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_parasat/model/teller_model.dart';
import 'package:toastification/toastification.dart';
import 'package:url_strategy/url_strategy.dart';

import 'model/branch_model.dart';
import 'providers/branch_provider.dart';
import 'providers/branch_teller_provider.dart';
import 'providers/counter_provider.dart';
import 'providers/teller_provider.dart';
import 'view/admin_view.dart';
import 'view/branch_counter_view.dart';
import 'view/branch_view.dart';
import 'view/branch_window_view.dart';
import 'view/teller_counter_view.dart';
import 'view/teller_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BranchProvider>(
          create: (_) => BranchProvider(),
        ),
        ChangeNotifierProvider<TellerProvider>(
          create: (_) => TellerProvider(),
        ),
        ChangeNotifierProvider<CounterProvider>(
          create: (_) => CounterProvider(),
        ),
        ChangeNotifierProvider<BranchTellerProvider>(
          create: (_) => BranchTellerProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Queue Parasat',
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        scrollBehavior: CustomScrollBehavior(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
      ),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        String mode = state.uri.queryParameters['mode'] ?? 'branch';
        if (mode == 'teller') {
          return const TellerView();
        } else if (mode == 'admin') {
          return const AdminView();
        } else {
          return const BranchView();
        }
      },
    ),
    GoRoute(
      path: '/branch',
      builder: (context, state) => const BranchView(),
    ),
    GoRoute(
      path: '/teller',
      builder: (context, state) => const TellerView(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminView(),
    ),
    GoRoute(
      path: '/branch_window',
      builder: (context, state) {
        final BranchModel extra = GoRouterState.of(context).extra! as BranchModel;
        return BranchWindowView(branchModel: extra);
      },
    ),
    GoRoute(
      path: '/branch_counter',
      builder: (context, state) {
        final BranchModel extra = GoRouterState.of(context).extra! as BranchModel;
        return BranchCounterView(branchModel: extra);
      },
    ),
    GoRoute(
      path: '/teller_counter',
      builder: (context, state) {
        final TellerModel extra = GoRouterState.of(context).extra! as TellerModel;
        return TellerCounterView(tellerModel: extra);
      },
    ),
  ],
);
