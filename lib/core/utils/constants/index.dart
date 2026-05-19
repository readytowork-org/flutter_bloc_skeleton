import 'package:flutter/material.dart' show BuildContext, Locale;

import '../../routes/app_routes.dart';

const List<Locale> supportLocales = [Locale('en'), Locale('ne')];

BuildContext get globalContext => rootNavigatorKey.currentState!.context;
