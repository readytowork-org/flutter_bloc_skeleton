part of 'get_profile_bloc.dart';

@freezed
class GetProfileState with _$GetProfileState implements BaseState {
  @Implements<BaseInitial>()
  const factory GetProfileState.initial() = ProfileInitial;

  @Implements<BaseLoading>()
  const factory GetProfileState.loading() = ProfileLoading;

  @Implements<BaseLoaded<UserEntity>>()
  const factory GetProfileState.loaded({required UserEntity res}) =
      ProfileLoaded;

  @Implements<BaseFailure>()
  const factory GetProfileState.failure({required String message}) =
      ProfileFailure;

  @Implements<BaseEmpty>()
  const factory GetProfileState.empty() = ProfileEmpty;
}
