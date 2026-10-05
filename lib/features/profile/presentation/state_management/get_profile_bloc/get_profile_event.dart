part of 'get_profile_bloc.dart';

@freezed
class GetProfileEvent with _$GetProfileEvent {
  const factory GetProfileEvent.started() = _Started;
  const factory GetProfileEvent.getProfileRequested() = GetProfileRequested;
}
