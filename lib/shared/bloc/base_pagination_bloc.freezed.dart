// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_pagination_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginationEvent<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationEvent<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginationEvent<$T>()';
}


}

/// @nodoc
class $PaginationEventCopyWith<T,$Res>  {
$PaginationEventCopyWith(PaginationEvent<T> _, $Res Function(PaginationEvent<T>) __);
}


/// Adds pattern-matching-related methods to [PaginationEvent].
extension PaginationEventPatterns<T> on PaginationEvent<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PaginationFetch<T> value)?  fetch,TResult Function( PaginationRefresh<T> value)?  refresh,TResult Function( PaginationUpdateLocally<T> value)?  updateLocally,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PaginationFetch() when fetch != null:
return fetch(_that);case PaginationRefresh() when refresh != null:
return refresh(_that);case PaginationUpdateLocally() when updateLocally != null:
return updateLocally(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PaginationFetch<T> value)  fetch,required TResult Function( PaginationRefresh<T> value)  refresh,required TResult Function( PaginationUpdateLocally<T> value)  updateLocally,}){
final _that = this;
switch (_that) {
case PaginationFetch():
return fetch(_that);case PaginationRefresh():
return refresh(_that);case PaginationUpdateLocally():
return updateLocally(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PaginationFetch<T> value)?  fetch,TResult? Function( PaginationRefresh<T> value)?  refresh,TResult? Function( PaginationUpdateLocally<T> value)?  updateLocally,}){
final _that = this;
switch (_that) {
case PaginationFetch() when fetch != null:
return fetch(_that);case PaginationRefresh() when refresh != null:
return refresh(_that);case PaginationUpdateLocally() when updateLocally != null:
return updateLocally(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  fetch,TResult Function()?  refresh,TResult Function( T data)?  updateLocally,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PaginationFetch() when fetch != null:
return fetch();case PaginationRefresh() when refresh != null:
return refresh();case PaginationUpdateLocally() when updateLocally != null:
return updateLocally(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  fetch,required TResult Function()  refresh,required TResult Function( T data)  updateLocally,}) {final _that = this;
switch (_that) {
case PaginationFetch():
return fetch();case PaginationRefresh():
return refresh();case PaginationUpdateLocally():
return updateLocally(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  fetch,TResult? Function()?  refresh,TResult? Function( T data)?  updateLocally,}) {final _that = this;
switch (_that) {
case PaginationFetch() when fetch != null:
return fetch();case PaginationRefresh() when refresh != null:
return refresh();case PaginationUpdateLocally() when updateLocally != null:
return updateLocally(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class PaginationFetch<T> implements PaginationEvent<T> {
  const PaginationFetch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationFetch<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginationEvent<$T>.fetch()';
}


}




/// @nodoc


class PaginationRefresh<T> implements PaginationEvent<T> {
  const PaginationRefresh();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationRefresh<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginationEvent<$T>.refresh()';
}


}




/// @nodoc


class PaginationUpdateLocally<T> implements PaginationEvent<T> {
  const PaginationUpdateLocally({required this.data});
  

 final  T data;

/// Create a copy of PaginationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationUpdateLocallyCopyWith<T, PaginationUpdateLocally<T>> get copyWith => _$PaginationUpdateLocallyCopyWithImpl<T, PaginationUpdateLocally<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationUpdateLocally<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'PaginationEvent<$T>.updateLocally(data: $data)';
}


}

/// @nodoc
abstract mixin class $PaginationUpdateLocallyCopyWith<T,$Res> implements $PaginationEventCopyWith<T, $Res> {
  factory $PaginationUpdateLocallyCopyWith(PaginationUpdateLocally<T> value, $Res Function(PaginationUpdateLocally<T>) _then) = _$PaginationUpdateLocallyCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$PaginationUpdateLocallyCopyWithImpl<T,$Res>
    implements $PaginationUpdateLocallyCopyWith<T, $Res> {
  _$PaginationUpdateLocallyCopyWithImpl(this._self, this._then);

  final PaginationUpdateLocally<T> _self;
  final $Res Function(PaginationUpdateLocally<T>) _then;

/// Create a copy of PaginationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(PaginationUpdateLocally<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc
mixin _$PaginationState<T> {

 List<T> get data; PaginationStatus get status; String? get error; bool get hasReachedMax;
/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationStateCopyWith<T, PaginationState<T>> get copyWith => _$PaginationStateCopyWithImpl<T, PaginationState<T>>(this as PaginationState<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationState<T>&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),status,error,hasReachedMax);

@override
String toString() {
  return 'PaginationState<$T>(data: $data, status: $status, error: $error, hasReachedMax: $hasReachedMax)';
}


}

/// @nodoc
abstract mixin class $PaginationStateCopyWith<T,$Res>  {
  factory $PaginationStateCopyWith(PaginationState<T> value, $Res Function(PaginationState<T>) _then) = _$PaginationStateCopyWithImpl;
@useResult
$Res call({
 List<T> data, PaginationStatus status, String? error, bool hasReachedMax
});




}
/// @nodoc
class _$PaginationStateCopyWithImpl<T,$Res>
    implements $PaginationStateCopyWith<T, $Res> {
  _$PaginationStateCopyWithImpl(this._self, this._then);

  final PaginationState<T> _self;
  final $Res Function(PaginationState<T>) _then;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? status = null,Object? error = freezed,Object? hasReachedMax = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<T>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaginationStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginationState].
extension PaginationStatePatterns<T> on PaginationState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginationState<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginationState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginationState<T> value)  $default,){
final _that = this;
switch (_that) {
case _PaginationState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginationState<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PaginationState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> data,  PaginationStatus status,  String? error,  bool hasReachedMax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginationState() when $default != null:
return $default(_that.data,_that.status,_that.error,_that.hasReachedMax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> data,  PaginationStatus status,  String? error,  bool hasReachedMax)  $default,) {final _that = this;
switch (_that) {
case _PaginationState():
return $default(_that.data,_that.status,_that.error,_that.hasReachedMax);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> data,  PaginationStatus status,  String? error,  bool hasReachedMax)?  $default,) {final _that = this;
switch (_that) {
case _PaginationState() when $default != null:
return $default(_that.data,_that.status,_that.error,_that.hasReachedMax);case _:
  return null;

}
}

}

/// @nodoc


class _PaginationState<T> implements PaginationState<T> {
  const _PaginationState({final  List<T> data = const [], this.status = PaginationStatus.initial, this.error, this.hasReachedMax = false}): _data = data;
  

 final  List<T> _data;
@override@JsonKey() List<T> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey() final  PaginationStatus status;
@override final  String? error;
@override@JsonKey() final  bool hasReachedMax;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginationStateCopyWith<T, _PaginationState<T>> get copyWith => __$PaginationStateCopyWithImpl<T, _PaginationState<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginationState<T>&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),status,error,hasReachedMax);

@override
String toString() {
  return 'PaginationState<$T>(data: $data, status: $status, error: $error, hasReachedMax: $hasReachedMax)';
}


}

/// @nodoc
abstract mixin class _$PaginationStateCopyWith<T,$Res> implements $PaginationStateCopyWith<T, $Res> {
  factory _$PaginationStateCopyWith(_PaginationState<T> value, $Res Function(_PaginationState<T>) _then) = __$PaginationStateCopyWithImpl;
@override @useResult
$Res call({
 List<T> data, PaginationStatus status, String? error, bool hasReachedMax
});




}
/// @nodoc
class __$PaginationStateCopyWithImpl<T,$Res>
    implements _$PaginationStateCopyWith<T, $Res> {
  __$PaginationStateCopyWithImpl(this._self, this._then);

  final _PaginationState<T> _self;
  final $Res Function(_PaginationState<T>) _then;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? status = null,Object? error = freezed,Object? hasReachedMax = null,}) {
  return _then(_PaginationState<T>(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<T>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaginationStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
