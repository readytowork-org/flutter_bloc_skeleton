// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_product_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddProductEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddProductEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddProductEvent()';
}


}

/// @nodoc
class $AddProductEventCopyWith<$Res>  {
$AddProductEventCopyWith(AddProductEvent _, $Res Function(AddProductEvent) __);
}


/// Adds pattern-matching-related methods to [AddProductEvent].
extension AddProductEventPatterns on AddProductEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( AddProductRequested value)?  addProductRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case AddProductRequested() when addProductRequested != null:
return addProductRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( AddProductRequested value)  addProductRequested,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case AddProductRequested():
return addProductRequested(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( AddProductRequested value)?  addProductRequested,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case AddProductRequested() when addProductRequested != null:
return addProductRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( JsonMap productData)?  addProductRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case AddProductRequested() when addProductRequested != null:
return addProductRequested(_that.productData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( JsonMap productData)  addProductRequested,}) {final _that = this;
switch (_that) {
case _Started():
return started();case AddProductRequested():
return addProductRequested(_that.productData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( JsonMap productData)?  addProductRequested,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case AddProductRequested() when addProductRequested != null:
return addProductRequested(_that.productData);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements AddProductEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddProductEvent.started()';
}


}




/// @nodoc


class AddProductRequested implements AddProductEvent {
  const AddProductRequested({required final  JsonMap productData}): _productData = productData;
  

 final  JsonMap _productData;
 JsonMap get productData {
  if (_productData is EqualUnmodifiableMapView) return _productData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_productData);
}


/// Create a copy of AddProductEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddProductRequestedCopyWith<AddProductRequested> get copyWith => _$AddProductRequestedCopyWithImpl<AddProductRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddProductRequested&&const DeepCollectionEquality().equals(other._productData, _productData));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_productData));

@override
String toString() {
  return 'AddProductEvent.addProductRequested(productData: $productData)';
}


}

/// @nodoc
abstract mixin class $AddProductRequestedCopyWith<$Res> implements $AddProductEventCopyWith<$Res> {
  factory $AddProductRequestedCopyWith(AddProductRequested value, $Res Function(AddProductRequested) _then) = _$AddProductRequestedCopyWithImpl;
@useResult
$Res call({
 JsonMap productData
});




}
/// @nodoc
class _$AddProductRequestedCopyWithImpl<$Res>
    implements $AddProductRequestedCopyWith<$Res> {
  _$AddProductRequestedCopyWithImpl(this._self, this._then);

  final AddProductRequested _self;
  final $Res Function(AddProductRequested) _then;

/// Create a copy of AddProductEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productData = null,}) {
  return _then(AddProductRequested(
productData: null == productData ? _self._productData : productData // ignore: cast_nullable_to_non_nullable
as JsonMap,
  ));
}


}

/// @nodoc
mixin _$AddProductState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddProductState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddProductState()';
}


}

/// @nodoc
class $AddProductStateCopyWith<$Res>  {
$AddProductStateCopyWith(AddProductState _, $Res Function(AddProductState) __);
}


/// Adds pattern-matching-related methods to [AddProductState].
extension AddProductStatePatterns on AddProductState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddProductInitial value)?  initial,TResult Function( AddProductLoading value)?  loading,TResult Function( AddProductSuccess value)?  success,TResult Function( AddProductFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddProductInitial() when initial != null:
return initial(_that);case AddProductLoading() when loading != null:
return loading(_that);case AddProductSuccess() when success != null:
return success(_that);case AddProductFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddProductInitial value)  initial,required TResult Function( AddProductLoading value)  loading,required TResult Function( AddProductSuccess value)  success,required TResult Function( AddProductFailure value)  failure,}){
final _that = this;
switch (_that) {
case AddProductInitial():
return initial(_that);case AddProductLoading():
return loading(_that);case AddProductSuccess():
return success(_that);case AddProductFailure():
return failure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddProductInitial value)?  initial,TResult? Function( AddProductLoading value)?  loading,TResult? Function( AddProductSuccess value)?  success,TResult? Function( AddProductFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AddProductInitial() when initial != null:
return initial(_that);case AddProductLoading() when loading != null:
return loading(_that);case AddProductSuccess() when success != null:
return success(_that);case AddProductFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( ProductEntity product)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddProductInitial() when initial != null:
return initial();case AddProductLoading() when loading != null:
return loading();case AddProductSuccess() when success != null:
return success(_that.product);case AddProductFailure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( ProductEntity product)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case AddProductInitial():
return initial();case AddProductLoading():
return loading();case AddProductSuccess():
return success(_that.product);case AddProductFailure():
return failure(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( ProductEntity product)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case AddProductInitial() when initial != null:
return initial();case AddProductLoading() when loading != null:
return loading();case AddProductSuccess() when success != null:
return success(_that.product);case AddProductFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AddProductInitial implements AddProductState {
  const AddProductInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddProductInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddProductState.initial()';
}


}




/// @nodoc


class AddProductLoading implements AddProductState {
  const AddProductLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddProductLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddProductState.loading()';
}


}




/// @nodoc


class AddProductSuccess implements AddProductState {
  const AddProductSuccess({required this.product});
  

 final  ProductEntity product;

/// Create a copy of AddProductState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddProductSuccessCopyWith<AddProductSuccess> get copyWith => _$AddProductSuccessCopyWithImpl<AddProductSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddProductSuccess&&(identical(other.product, product) || other.product == product));
}


@override
int get hashCode => Object.hash(runtimeType,product);

@override
String toString() {
  return 'AddProductState.success(product: $product)';
}


}

/// @nodoc
abstract mixin class $AddProductSuccessCopyWith<$Res> implements $AddProductStateCopyWith<$Res> {
  factory $AddProductSuccessCopyWith(AddProductSuccess value, $Res Function(AddProductSuccess) _then) = _$AddProductSuccessCopyWithImpl;
@useResult
$Res call({
 ProductEntity product
});




}
/// @nodoc
class _$AddProductSuccessCopyWithImpl<$Res>
    implements $AddProductSuccessCopyWith<$Res> {
  _$AddProductSuccessCopyWithImpl(this._self, this._then);

  final AddProductSuccess _self;
  final $Res Function(AddProductSuccess) _then;

/// Create a copy of AddProductState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,}) {
  return _then(AddProductSuccess(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductEntity,
  ));
}


}

/// @nodoc


class AddProductFailure implements AddProductState {
  const AddProductFailure({required this.message});
  

 final  String message;

/// Create a copy of AddProductState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddProductFailureCopyWith<AddProductFailure> get copyWith => _$AddProductFailureCopyWithImpl<AddProductFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddProductFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AddProductState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $AddProductFailureCopyWith<$Res> implements $AddProductStateCopyWith<$Res> {
  factory $AddProductFailureCopyWith(AddProductFailure value, $Res Function(AddProductFailure) _then) = _$AddProductFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AddProductFailureCopyWithImpl<$Res>
    implements $AddProductFailureCopyWith<$Res> {
  _$AddProductFailureCopyWithImpl(this._self, this._then);

  final AddProductFailure _self;
  final $Res Function(AddProductFailure) _then;

/// Create a copy of AddProductState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AddProductFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
