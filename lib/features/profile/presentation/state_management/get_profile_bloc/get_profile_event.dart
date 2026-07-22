part of 'get_profile_bloc.dart';

sealed class GetProfileEvent extends Equatable {
  const GetProfileEvent();

  const factory GetProfileEvent.started() = _Started;
  const factory GetProfileEvent.getProfileRequested() = GetProfileRequested;

  @override
  List<Object?> get props => [];
}

final class _Started extends GetProfileEvent {
  const _Started();
}

final class GetProfileRequested extends GetProfileEvent {
  const GetProfileRequested();
}
