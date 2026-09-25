import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/state/base_state.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../../domain/repository/profile_repository.dart';

part 'get_profile_event.dart';
part 'get_profile_state.dart';

class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {
  final ProfileRepository _repository;

  GetProfileBloc({required ProfileRepository repository})
    : _repository = repository,
      super(GetProfileState.initial()) {
    on<GetProfileRequested>(_onGetProfileRequested);
  }
  Future<void> _onGetProfileRequested(
    GetProfileRequested event,
    Emitter<GetProfileState> emit,
  ) async {
    final result = await _repository.getProfile();

    result.when(
      success: (res) => emit(GetProfileState.loaded(res: res)),
      failure: (failure) =>
          emit(GetProfileState.failure(message: failure.message)),
    );
  }
}
