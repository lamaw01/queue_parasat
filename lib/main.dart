import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_parasat/model/teller_model.dart';
import 'package:url_strategy/url_strategy.dart';

import 'model/branch_model.dart';
import 'providers/branch_provider.dart';
import 'providers/counter_provider.dart';
import 'providers/teller_provider.dart';
import 'view/branch_counter_view.dart';
import 'view/branch_view.dart';
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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Queue Parasat',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      scrollBehavior: CustomScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
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
        String? teller = state.uri.queryParameters['teller'];
        if (teller == 'true') {
          return const TellerView();
        } else {
          return const BranchView();
        }
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
      path: '/teller',
      builder: (context, state) => const TellerView(),
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
