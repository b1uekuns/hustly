// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/data_sources/remote/auth_api.dart' as _i799;
import '../../features/auth/data/repositories/login_repository_impl.dart'
    as _i327;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/auth_usecases.dart' as _i46;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/chat/data/data_sources/remote/chat_api.dart' as _i931;
import '../../features/chat/data/repositories/chat_repository_impl.dart'
    as _i504;
import '../../features/chat/domain/repositories/chat_repository.dart' as _i420;
import '../../features/chat/domain/usecases/create_conversation_usecase.dart'
    as _i8;
import '../../features/chat/domain/usecases/delete_conversation_usecase.dart'
    as _i253;
import '../../features/chat/domain/usecases/get_conversations_usecase.dart'
    as _i194;
import '../../features/chat/domain/usecases/get_messages_usecase.dart' as _i325;
import '../../features/chat/domain/usecases/mark_as_read_usecase.dart' as _i600;
import '../../features/chat/domain/usecases/send_message_usecase.dart' as _i795;
import '../../features/chat/presentation/bloc/chat_list/chat_list_bloc.dart'
    as _i505;
import '../../features/chat/presentation/bloc/chat_room/chat_room_bloc.dart'
    as _i10;
import '../../features/home/data/data_sources/remote/discover_api.dart'
    as _i971;
import '../../features/home/data/repositories/discover_repository_impl.dart'
    as _i90;
import '../../features/home/domain/repositories/discover_repository.dart'
    as _i952;
import '../../features/home/presentation/bloc/discover_bloc.dart' as _i721;
import '../../features/profile_setup/data/data_source/remote/user_api.dart'
    as _i920;
import '../../features/profile_setup/data/repositories/profile_repository_impl.dart'
    as _i211;
import '../../features/profile_setup/domain/repositories/profile_repository.dart'
    as _i226;
import '../../features/profile_setup/domain/usecases/complete_profile_usecase.dart'
    as _i1006;
import '../../features/profile_setup/presentation/bloc/profile_setup_bloc.dart'
    as _i888;
import '../error/handlers/token_provider.dart' as _i149;
import '../error/handlers/token_provider_impl.dart' as _i547;
import '../network/dio_client.dart' as _i667;
import '../network/interceptors/logging_interceptor.dart' as _i344;
import '../network/network_info.dart' as _i932;
import '../services/image/image_picker_service.dart' as _i346;
import '../services/socket_service.dart' as _i411;
import '../services/storage/preferences_service.dart' as _i318;
import '../services/storage/storage_service.dart' as _i968;
import '../services/upload/upload_service.dart' as _i309;
import 'modules/network_module.dart' as _i851;
import 'modules/storage_module.dart' as _i148;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    final storageModule = _$StorageModule();
    gh.lazySingleton<_i895.Connectivity>(() => networkModule.connectivity);
    gh.lazySingleton<_i344.LoggingInterceptor>(
        () => networkModule.loggingInterceptor);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => storageModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i346.ImagePickerService>(
        () => _i346.ImagePickerService());
    gh.lazySingleton<_i968.StorageService>(
        () => storageModule.storageService(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i932.NetworkInfo>(
        () => networkModule.networkInfo(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i149.TokenProvider>(
        () => _i547.TokenProviderImpl(gh<_i968.StorageService>()));
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.provideRefreshDio(gh<_i344.LoggingInterceptor>()),
      instanceName: 'refreshDio',
    );
    gh.lazySingleton<_i411.SocketService>(
        () => _i411.SocketService(gh<_i149.TokenProvider>()));
    gh.lazySingleton<_i318.PreferencesService>(
        () => storageModule.preferencesService(gh<_i968.StorageService>()));
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.provideMainDio(
        gh<_i344.LoggingInterceptor>(),
        gh<_i361.Dio>(instanceName: 'refreshDio'),
        gh<_i149.TokenProvider>(),
      ),
      instanceName: 'mainDio',
    );
    gh.lazySingleton<_i309.UploadService>(() => _i309.UploadService(
          gh<_i361.Dio>(instanceName: 'mainDio'),
          gh<_i149.TokenProvider>(),
        ));
    gh.lazySingleton<_i667.DioClient>(
        () => networkModule.dioClient(gh<_i361.Dio>(instanceName: 'mainDio')));
    gh.lazySingleton<_i799.AuthApi>(
        () => networkModule.authApi(gh<_i361.Dio>(instanceName: 'mainDio')));
    gh.lazySingleton<_i920.UserApi>(
        () => networkModule.userApi(gh<_i361.Dio>(instanceName: 'mainDio')));
    gh.lazySingleton<_i971.DiscoverApi>(() =>
        networkModule.discoverApi(gh<_i361.Dio>(instanceName: 'mainDio')));
    gh.lazySingleton<_i931.ChatApi>(
        () => networkModule.chatApi(gh<_i361.Dio>(instanceName: 'mainDio')));
    gh.factory<_i420.ChatRepository>(
        () => _i504.ChatRepositoryImpl(gh<_i931.ChatApi>()));
    gh.lazySingleton<_i226.ProfileRepository>(() => _i211.ProfileRepositoryImpl(
          gh<_i920.UserApi>(),
          gh<_i149.TokenProvider>(),
        ));
    gh.lazySingleton<_i787.AuthRepository>(() => _i327.AuthRepositoryImpl(
          gh<_i799.AuthApi>(),
          gh<_i149.TokenProvider>(),
        ));
    gh.lazySingleton<_i952.DiscoverRepository>(
        () => _i90.DiscoverRepositoryImpl(
              discoverApi: gh<_i971.DiscoverApi>(),
              tokenProvider: gh<_i149.TokenProvider>(),
            ));
    gh.factory<_i1006.GetInterestsUseCase>(
        () => _i1006.GetInterestsUseCase(gh<_i226.ProfileRepository>()));
    gh.factory<_i1006.GetMajorsUseCase>(
        () => _i1006.GetMajorsUseCase(gh<_i226.ProfileRepository>()));
    gh.factory<_i1006.CompleteProfileUseCase>(
        () => _i1006.CompleteProfileUseCase(gh<_i226.ProfileRepository>()));
    gh.factory<_i1006.GetMyProfileUseCase>(
        () => _i1006.GetMyProfileUseCase(gh<_i226.ProfileRepository>()));
    gh.factory<_i8.CreateConversationUseCase>(
        () => _i8.CreateConversationUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i253.DeleteConversationUseCase>(
        () => _i253.DeleteConversationUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i194.GetConversationsUseCase>(
        () => _i194.GetConversationsUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i325.GetMessagesUseCase>(
        () => _i325.GetMessagesUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i600.MarkAsReadUseCase>(
        () => _i600.MarkAsReadUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i795.SendMessageUseCase>(
        () => _i795.SendMessageUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i505.ChatListBloc>(() => _i505.ChatListBloc(
          gh<_i194.GetConversationsUseCase>(),
          gh<_i253.DeleteConversationUseCase>(),
        ));
    gh.factory<_i46.SendOtpUseCase>(
        () => _i46.SendOtpUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.VerifyOtpUseCase>(
        () => _i46.VerifyOtpUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.GetCurrentUserUseCase>(
        () => _i46.GetCurrentUserUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.RefreshTokenUseCase>(
        () => _i46.RefreshTokenUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i721.DiscoverBloc>(
        () => _i721.DiscoverBloc(repository: gh<_i952.DiscoverRepository>()));
    gh.factory<_i10.ChatRoomBloc>(() => _i10.ChatRoomBloc(
          gh<_i325.GetMessagesUseCase>(),
          gh<_i795.SendMessageUseCase>(),
          gh<_i600.MarkAsReadUseCase>(),
        ));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          sendOtpUseCase: gh<_i46.SendOtpUseCase>(),
          verifyOtpUseCase: gh<_i46.VerifyOtpUseCase>(),
          tokenProvider: gh<_i149.TokenProvider>(),
          profileRepository: gh<_i226.ProfileRepository>(),
        ));
    gh.factory<_i888.ProfileSetupBloc>(() => _i888.ProfileSetupBloc(
          gh<_i1006.CompleteProfileUseCase>(),
          gh<_i1006.GetMajorsUseCase>(),
          gh<_i1006.GetInterestsUseCase>(),
          gh<_i309.UploadService>(),
          gh<_i797.AuthBloc>(),
        ));
    return this;
  }
}

class _$NetworkModule extends _i851.NetworkModule {}

class _$StorageModule extends _i148.StorageModule {}
