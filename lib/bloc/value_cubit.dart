import 'package:agent_app/bloc/base_cubit.dart';
import 'package:equatable/equatable.dart';

class ValueCubit<T> extends BaseCubit<BaseValueChangedState> {
  ValueCubit._internal(this._value)
      : super(ValueChangedInitializeState(_value));

  factory ValueCubit.value(T value) {
    return ValueCubit._internal(value);
  }

  late T _value;

  set value(T newValue) {
    _value = newValue;
    emit(ValueChangedState(_value));
  }

  T get value => _value;
}

abstract class BaseValueChangedState extends Equatable {
  const BaseValueChangedState();

  @override
  List<Object?> get props => [];
}

class ValueChangedInitializeState<T> extends BaseValueChangedState {
  const ValueChangedInitializeState(this.value);

  final T value;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'ValueChangedInitializeState { crUser: $value }';
}

class ValueChangedState<T> extends BaseValueChangedState {
  const ValueChangedState(this.value);

  final T value;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'ValueChangedState { crUser: $value }';
}
