import 'package:agent_app/data/models/user.dart';
import 'package:agent_app/data/repositories/base_repository.dart';

class AuthRepository extends BaseRepository {
  User? _currentUser;
  User? get currentUser => _currentUser;

  User? getCurrentUser() {
    return _currentUser ??= storage.currentUser;
  }

  void setCurrentUser(User user) {
    _currentUser = user;
    storage.currentUser = user;
  }

  @override
  Future<void> clean() async {}
}
