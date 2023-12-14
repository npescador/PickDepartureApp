import 'package:get_it/get_it.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupMainModule();
    _setupJokesModule();
  }

  _setupMainModule() {
    //inject.registerSingleton(NetworkClient());
  }

  _setupJokesModule() {
    //inject.registerFactory(() => JokesRemoteImpl(networkClient: inject.get()));
    //inject.registerFactory<JokesRepository>(
    //    () => JokeDataImpl(jokesRemoteImpl: inject.get()));
    //inject.registerFactory(() => JokesViewModel(jokesRepository: inject.get()));
  }
}
