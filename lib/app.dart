import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart'
    show
        BuildContext,
        MaterialApp,
        Size,
        StatelessWidget,
        ThemeData,
        Widget,
        Locale,
        SizedBox;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, BlocProvider, MultiBlocProvider;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/di/service_locator.dart';
import 'core/routes/app_routes.dart';
import 'features/auth/auth.dart';
import 'core/theme/app_theme.dart';
import 'l10n/s.dart';
import 'shared/cubit/locale_cubit.dart';
import 'shared/widgets/atoms/locale_switcher.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<AuthBloc>()),
        BlocProvider.value(value: sl<AppTheme>()),
        BlocProvider.value(value: sl<LocaleCubit>()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(360, 690),
        builder: (context, child) => BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return BlocBuilder<AppTheme, ThemeData>(
              builder: (context, themeData) => MaterialApp.router(
                debugShowCheckedModeBanner: kDebugMode,
                routerConfig: sl<AppRouter>(),
                title: 'Flutter Bloc Skeleton',
                theme: themeData,
                locale: locale,
                localizationsDelegates: S.localizationsDelegates,
                supportedLocales: S.supportedLocales,
                builder: (context, child) {
                  if (child == null) {
                    return const SizedBox.shrink();
                  }
                  return LocaleSwitcher(child: child);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
