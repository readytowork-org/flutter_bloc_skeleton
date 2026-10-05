// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_profile_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetProfileEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetProfileEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProfileEvent()';
}


}

/// @nodoc
class $GetProfileEventCopyWith<$Res>  {
$GetProfileEventCopyWith(GetProfileEvent _, $Res Function(GetProfileEvent) __);
}


/// Adds pattern-matching-related methods to [GetProfileEvent].
extension GetProfileEventPatterns on GetProfileEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( GetProfileRequested value)?  getProfileRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case GetProfileRequested() when getProfileRequested != null:
return getProfileRequested(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( GetProfileRequested value)  getProfileRequested,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case GetProfileRequested():
return getProfileRequested(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( GetProfileRequested value)?  getProfileRequested,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case GetProfileRequested() when getProfileRequested != null:
return getProfileRequested(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  getProfileRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case GetProfileRequested() when getProfileRequested != null:
return getProfileRequested();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  getProfileRequested,}) {final _that = this;
switch (_that) {
case _Started():
return started();case GetProfileRequested():
return getProfileRequested();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  getProfileRequested,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case GetProfileRequested() when getProfileRequested != null:
return getProfileRequested();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements GetProfileEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProfileEvent.started()';
}


}




/// @nodoc


class GetProfileRequested implements GetProfileEvent {
  const GetProfileRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetProfileRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProfileEvent.getProfileRequested()';
}


}




/// @nodoc
mixin _$GetProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProfileState()';
}


}

/// @nodoc
class $GetProfileStateCopyWith<$Res>  {
$GetProfileStateCopyWith(GetProfileState _, $Res Function(GetProfileState) __);
}


/// Adds pattern-matching-related methods to [GetProfileState].
extension GetProfileStatePatterns on GetProfileState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProfileInitial value)?  initial,TResult Function( ProfileLoading value)?  loading,TResult Function( ProfileLoaded value)?  loaded,TResult Function( ProfileFailure value)?  failure,TResult Function( ProfileEmpty value)?  empty,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial(_that);case ProfileLoading() when loading != null:
return loading(_that);case ProfileLoaded() when loaded != null:
return loaded(_that);case ProfileFailure() when failure != null:
return failure(_that);case ProfileEmpty() when empty != null:
return empty(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProfileInitial value)  initial,required TResult Function( ProfileLoading value)  loading,required TResult Function( ProfileLoaded value)  loaded,required TResult Function( ProfileFailure value)  failure,required TResult Function( ProfileEmpty value)  empty,}){
final _that = this;
switch (_that) {
case ProfileInitial():
return initial(_that);case ProfileLoading():
return loading(_that);case ProfileLoaded():
return loaded(_that);case ProfileFailure():
return failure(_that);case ProfileEmpty():
return empty(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProfileInitial value)?  initial,TResult? Function( ProfileLoading value)?  loading,TResult? Function( ProfileLoaded value)?  loaded,TResult? Function( ProfileFailure value)?  failure,TResult? Function( ProfileEmpty value)?  empty,}){
final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial(_that);case ProfileLoading() when loading != null:
return loading(_that);case ProfileLoaded() when loaded != null:
return loaded(_that);case ProfileFailure() when failure != null:
return failure(_that);case ProfileEmpty() when empty != null:
return empty(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( UserEntity res)?  loaded,TResult Function( String message)?  failure,TResult Function()?  empty,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial();case ProfileLoading() when loading != null:
return loading();case ProfileLoaded() when loaded != null:
return loaded(_that.res);case ProfileFailure() when failure != null:
return failure(_that.message);case ProfileEmpty() when empty != null:
return empty();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( UserEntity res)  loaded,required TResult Function( String message)  failure,required TResult Function()  empty,}) {final _that = this;
switch (_that) {
case ProfileInitial():
return initial();case ProfileLoading():
return loading();case ProfileLoaded():
return loaded(_that.res);case ProfileFailure():
return failure(_that.message);case ProfileEmpty():
return empty();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( UserEntity res)?  loaded,TResult? Function( String message)?  failure,TResult? Function()?  empty,}) {final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial();case ProfileLoading() when loading != null:
return loading();case ProfileLoaded() when loaded != null:
return loaded(_that.res);case ProfileFailure() when failure != null:
return failure(_that.message);case ProfileEmpty() when empty != null:
return empty();case _:
  return null;

}
}

}

/// @nodoc


class ProfileInitial implements GetProfileState, BaseInitial {
  const ProfileInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProfileState.initial()';
}


}




/// @nodoc


class ProfileLoading implements GetProfileState, BaseLoading {
  const ProfileLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProfileState.loading()';
}


}




/// @nodoc


class ProfileLoaded implements GetProfileState, BaseLoaded<UserEntity> {
  const ProfileLoaded({required this.res});
  

 final  UserEntity res;

/// Create a copy of GetProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileLoadedCopyWith<ProfileLoaded> get copyWith => _$ProfileLoadedCopyWithImpl<ProfileLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileLoaded&&(identical(other.res, res) || other.res == res));
}


@override
int get hashCode => Object.hash(runtimeType,res);

@override
String toString() {
  return 'GetProfileState.loaded(res: $res)';
}


}

/// @nodoc
abstract mixin class $ProfileLoadedCopyWith<$Res> implements $GetProfileStateCopyWith<$Res> {
  factory $ProfileLoadedCopyWith(ProfileLoaded value, $Res Function(ProfileLoaded) _then) = _$ProfileLoadedCopyWithImpl;
@useResult
$Res call({
 UserEntity res
});




}
/// @nodoc
class _$ProfileLoadedCopyWithImpl<$Res>
    implements $ProfileLoadedCopyWith<$Res> {
  _$ProfileLoadedCopyWithImpl(this._self, this._then);

  final ProfileLoaded _self;
  final $Res Function(ProfileLoaded) _then;

/// Create a copy of GetProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? res = null,}) {
  return _then(ProfileLoaded(
res: null == res ? _self.res : res // ignore: cast_nullable_to_non_nullable
as UserEntity,
  ));
}


}

/// @nodoc


class ProfileFailure implements GetProfileState, BaseFailure {
  const ProfileFailure({required this.message});
  

 final  String message;

/// Create a copy of GetProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileFailureCopyWith<ProfileFailure> get copyWith => _$ProfileFailureCopyWithImpl<ProfileFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'GetProfileState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $ProfileFailureCopyWith<$Res> implements $GetProfileStateCopyWith<$Res> {
  factory $ProfileFailureCopyWith(ProfileFailure value, $Res Function(ProfileFailure) _then) = _$ProfileFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ProfileFailureCopyWithImpl<$Res>
    implements $ProfileFailureCopyWith<$Res> {
  _$ProfileFailureCopyWithImpl(this._self, this._then);

  final ProfileFailure _self;
  final $Res Function(ProfileFailure) _then;

/// Create a copy of GetProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ProfileFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProfileEmpty implements GetProfileState, BaseEmpty {
  const ProfileEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProfileState.empty()';
}


}




// dart format on
