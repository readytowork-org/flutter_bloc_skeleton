abstract interface class BaseState {}

abstract interface class BaseInitial implements BaseState {}

abstract interface class BaseLoading implements BaseState {}

abstract interface class BaseLoaded<T> implements BaseState {
  T get res;
}

abstract interface class BaseFailure implements BaseState {
  String get message;
}

abstract interface class BaseEmpty implements BaseState {}
