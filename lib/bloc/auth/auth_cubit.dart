import 'package:agent_app/bloc/auth/auth_state.dart';
import 'package:agent_app/bloc/base_cubit.dart';
import 'package:agent_app/data/middlewares/auth_middleware.dart';
import 'package:agent_app/data/models/user.dart';
import 'package:agent_app/di/dependency_injection.dart';

class AuthCubit extends BaseCubit<AuthState> {
  AuthCubit() : super(AuthInitializeState());

  final _authMiddleware = di<AuthMiddleware>();

  Future<void> login(String user, String password) async {
    emit(AuthProcessingState());

    await _authMiddleware.login(user, password);

    const latestUser = User(accessToken: 'accessToken');

    emit(const AuthSigninSuccessState(latestUser));

    emit(const AuthReadyState(latestUser));
  }
}
