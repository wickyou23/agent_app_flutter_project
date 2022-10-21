import 'package:agent_app/utils/tp_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  @override
  Future<void> close() {
    logger.i('Cubit: ${toString()} closed');
    return super.close();
  }

  @override
  void onChange(Change<State> change) {
    super.onChange(change);
    logger.i('Cubit: $change');
  }
}
