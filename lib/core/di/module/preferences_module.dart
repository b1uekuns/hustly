import '../../data/local/share_preferences_manager.dart';
import '../injector.dart';

class PreferencesModule {
  void provides () {
     sl.registerSingleton<SharedPreferencesManager>(SharedPreferencesManager());
  }

}