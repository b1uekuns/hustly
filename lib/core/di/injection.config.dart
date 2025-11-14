import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../error/handlers/token_provider.dart';
import '../error/handlers/token_provider_impl.dart';
import '../network/dio_client.dart';
import '../network/interceptors/logging_interceptor.dart';
import '../network/network_info.dart';
import '../services/storage/preferences_service.dart';
import '../services/storage/storage_service.dart';
import 'modules/network_module.dart';
import 'modules/storage_module.dart';

extension GetItInjectableX on GetIt {
  Future<GetIt> init({
    String? environment,
    EnvironmentFilter? environmentFilter,
  }) async {
    final gh = GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    final storageModule = _$StorageModule();
    gh.lazySingleton<Connectivity>(() => networkModule.connectivity);
    gh.lazySingleton<LoggingInterceptor>(
      () => networkModule.loggingInterceptor,
    );
    await gh.lazySingletonAsync<SharedPreferences>(
      () => storageModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<StorageService>(
      () => storageModule.storageService(gh<SharedPreferences>()),
    );
    gh.lazySingleton<NetworkInfo>(
      () => networkModule.networkInfo(gh<Connectivity>()),
    );
    gh.lazySingleton<TokenProvider>(
      () => TokenProviderImpl(gh<StorageService>()),
    );
    gh.lazySingleton<Dio>(
      () => networkModule.provideRefreshDio(gh<LoggingInterceptor>()),
      instanceName: 'refreshDio',
    );
    gh.lazySingleton<PreferencesService>(
      () => storageModule.preferencesService(gh<StorageService>()),
    );
    gh.lazySingleton<Dio>(
      () => networkModule.provideMainDio(
        gh<LoggingInterceptor>(),
        gh<Dio>(instanceName: 'refreshDio'),
        gh<TokenProvider>(),
      ),
      instanceName: 'mainDio',
    );
    gh.lazySingleton<DioClient>(
      () => networkModule.dioClient(gh<Dio>(instanceName: 'mainDio')),
    );
    return this;
  }
}

class _$NetworkModule extends NetworkModule {}

class _$StorageModule extends StorageModule {}