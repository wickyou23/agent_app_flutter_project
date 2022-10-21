import 'package:agent_app/di/dependency_injection.dart';
import 'package:agent_app/services/local_storage_service.dart';

abstract class BaseRepository {
  LocalStoreService get storage => di<LocalStoreService>();

  void clean();
}
