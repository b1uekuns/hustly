import 'package:get_it/get_it.dart';
import 'package:hust_chill_app/core/di/module/api_module.dart';
import 'package:hust_chill_app/core/di/module/preferences_module.dart';
import 'package:hust_chill_app/core/di/module/use_case_module.dart';
import 'module/bloc_module.dart';

final sl = GetIt.instance;

class Injection {
  Injection._();

  static Future<void> inject({required String baseUrl}) async {
    PreferencesModule().provides();

    // API module (Dio + AuthApi)
    await ApiModule().provides(baseUrl);

    // Các module còn lại
    UseCaseModule().provides();
    BlocModule().provides();
  }
}
