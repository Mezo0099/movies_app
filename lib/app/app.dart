import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movies_app/presentation/home/presentation/manager/home_bloc.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../data/shared_preferences/settings_notifier.dart';
import '../../presentation/actions/presentation/manager/actions_cubit.dart';
import '../app/localization/resources.dart';
import '../core/exports.dart';
import '../presentation/home/presentation/screens/splash.dart';
import '../presentation/route_generator.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsNotifier>(
      create: (_) => sl<SettingsNotifier>(),
      child: Consumer<SettingsNotifier>(
        builder: (context, settings, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<HomeBloc>(
                create: (context) => sl<HomeBloc>(),
              ),
              BlocProvider<ActionsCubit>(
                create: (context) => sl<ActionsCubit>(),
              ),
            ],
            child: MaterialApp(
              builder: (context, widget) => ResponsiveWrapper.builder(
                ClampingScrollWrapper.builder(context, widget!),
                breakpoints: const [
                  ResponsiveBreakpoint.resize(400,
                      name: MOBILE, scaleFactor: 1),
                  ResponsiveBreakpoint.resize(800,
                      name: TABLET, scaleFactor: 1.4),
                ],
              ),
              debugShowCheckedModeBanner: false,
              restorationScopeId: 'app',
              localizationsDelegates: const [
                Resources.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale("en"),
                Locale("ar"),
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale!.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              locale: settings.getLocale,
              theme: settings.getTheme,
              darkTheme: settings.getTheme,
              onGenerateRoute: RouteGenerator(),
              home: const Splash(),
            ),
          );
        },
      ),
    );
  }
}
