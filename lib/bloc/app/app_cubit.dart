import 'package:agent_app/bloc/app/app_state.dart';
import 'package:agent_app/bloc/base_cubit.dart';

class AppCubit extends BaseCubit<AppState> {
  AppCubit() : super(AppInitialState());

  Future<void> checkSession() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    emit(const AppReadyWithAuthenticationState());
  }
}
