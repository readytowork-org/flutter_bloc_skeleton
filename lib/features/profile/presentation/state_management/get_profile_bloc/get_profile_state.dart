part of 'get_profile_bloc.dart';

sealed class GetProfileState extends Equatable implements BaseState {
  const GetProfileState();

  const factory GetProfileState.initial() = ProfileInitial;
  const factory GetProfileState.loading() = ProfileLoading;
  const factory GetProfileState.loaded({required UserEntity res}) =
      ProfileLoaded;
  const factory GetProfileState.failure({required String message}) =
      ProfileFailure;
  const factory GetProfileState.empty() = ProfileEmpty;

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends GetProfileState implements BaseInitial {
  const ProfileInitial();
}

final class ProfileLoading extends GetProfileState implements BaseLoading {
  const ProfileLoading();
}

final class ProfileLoaded extends GetProfileState
    implements BaseLoaded<UserEntity> {
  const ProfileLoaded({required this.res});

  @override
  final UserEntity res;

  @override
  List<Object?> get props => [res];
}

final class ProfileFailure extends GetProfileState implements BaseFailure {
  const ProfileFailure({required this.message});

  @override
  final String message;

  @override
  List<Object?> get props => [message];
}

final class ProfileEmpty extends GetProfileState implements BaseEmpty {
  const ProfileEmpty();
}
