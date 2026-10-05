import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/network/api_result.dart';
import '../../../../../shared/state/base_state.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../../domain/usecases/profile_usecae.dart';

part 'get_profile_event.dart';
part 'get_profile_state.dart';
part 'get_profile_bloc.freezed.dart';

class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {
  final ProfileUseCase _profileUseCase;

  GetProfileBloc({required ProfileUseCase profileUseCase})
    : _profileUseCase = profileUseCase,
      super(GetProfileState.initial()) {
    on<GetProfileRequested>(_onGetProfileRequested);
  }
  Future<void> _onGetProfileRequested(
    GetProfileRequested event,
    Emitter<GetProfileState> emit,
  ) async {
    final result = await _profileUseCase();

    result.when(
      success: (res) => emit(GetProfileState.loaded(res: res)),
      failure: (failure) =>
          emit(GetProfileState.failure(message: failure.message)),
    );
  }
}
