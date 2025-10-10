abstract class AppUseCases<Type, Params> {
  Future<Type> call({Params? params});
}

class NoParams {}