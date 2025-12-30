import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

/// GetIt instance - Singleton để access dependencies
final getIt = GetIt.instance;

/// Khởi tạo tất cả dependencies
/// Gọi trong main.dart:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await configureDependencies();
///   runApp(MyApp());
/// }
/// ```
@InjectableInit(
  initializerName: 'init', // Tên hàm generated
  preferRelativeImports: true, // Dùng relative imports
  asExtension: true, // Generate as extension
)
Future<void> configureDependencies() async {
  await getIt.init();
}
