import 'package:agent_app/app/app_flavor_config.dart';
import 'package:agent_app/app/app_wireframe.dart';
import 'package:agent_app/bloc/app/app_cubit.dart';
import 'package:agent_app/res/res.dart';
import 'package:agent_app/utils/tp_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:overlay_support/overlay_support.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppCubit get _appCubit => GetIt.I<AppCubit>();

  @override
  void initState() {
    _appCubit.checkSession();
    super.initState();
  }

  @override
  void dispose() {
    _appCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<AppCubit>.value(value: _appCubit)],
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // navigatorKey: GetService().navigatorKey,
          theme: createTheme(),
          routes: AppWireFrame.routes,
          initialRoute: '/',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            logger.i(
              'The app is using language (${locale?.languageCode ?? 'unknown'})',
            );
            return locale;
          },
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: (FlavorConfig.instance.flavor == Flavor.dev)
                  ? Banner(
                      message: 'DEV',
                      location: BannerLocation.topEnd,
                      child: child,
                    )
                  : child ?? Container(),
            );
          },
        ),
      ),
    );
  }
}
