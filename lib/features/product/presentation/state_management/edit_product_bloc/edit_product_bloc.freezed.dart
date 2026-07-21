// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_product_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProductEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProductEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProductEvent()';
}


}

/// @nodoc
class $EditProductEventCopyWith<$Res>  {
$EditProductEventCopyWith(EditProductEvent _, $Res Function(EditProductEvent) __);
}


/// Adds pattern-matching-related methods to [EditProductEvent].
extension EditProductEventPatterns on EditProductEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( UpdatedProductRequested value)?  updatedProductRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case UpdatedProductRequested() when updatedProductRequested != null:
return updatedProductRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( UpdatedProductRequested value)  updatedProductRequested,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case UpdatedProductRequested():
return updatedProductRequested(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( UpdatedProductRequested value)?  updatedProductRequested,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case UpdatedProductRequested() when updatedProductRequested != null:
return updatedProductRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( JsonMap productData,  String id)?  updatedProductRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case UpdatedProductRequested() when updatedProductRequested != null:
return updatedProductRequested(_that.productData,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( JsonMap productData,  String id)  updatedProductRequested,}) {final _that = this;
switch (_that) {
case _Started():
return started();case UpdatedProductRequested():
return updatedProductRequested(_that.productData,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( JsonMap productData,  String id)?  updatedProductRequested,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case UpdatedProductRequested() when updatedProductRequested != null:
return updatedProductRequested(_that.productData,_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements EditProductEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProductEvent.started()';
}


}




/// @nodoc


class UpdatedProductRequested implements EditProductEvent {
  const UpdatedProductRequested({required final  JsonMap productData, required this.id}): _productData = productData;
  

 final  JsonMap _productData;
 JsonMap get productData {
  if (_productData is EqualUnmodifiableMapView) return _productData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_productData);
}

 final  String id;

/// Create a copy of EditProductEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatedProductRequestedCopyWith<UpdatedProductRequested> get copyWith => _$UpdatedProductRequestedCopyWithImpl<UpdatedProductRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatedProductRequested&&const DeepCollectionEquality().equals(other._productData, _productData)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_productData),id);

@override
String toString() {
  return 'EditProductEvent.updatedProductRequested(productData: $productData, id: $id)';
}


}

/// @nodoc
abstract mixin class $UpdatedProductRequestedCopyWith<$Res> implements $EditProductEventCopyWith<$Res> {
  factory $UpdatedProductRequestedCopyWith(UpdatedProductRequested value, $Res Function(UpdatedProductRequested) _then) = _$UpdatedProductRequestedCopyWithImpl;
@useResult
$Res call({
 JsonMap productData, String id
});




}
/// @nodoc
class _$UpdatedProductRequestedCopyWithImpl<$Res>
    implements $UpdatedProductRequestedCopyWith<$Res> {
  _$UpdatedProductRequestedCopyWithImpl(this._self, this._then);

  final UpdatedProductRequested _self;
  final $Res Function(UpdatedProductRequested) _then;

/// Create a copy of EditProductEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productData = null,Object? id = null,}) {
  return _then(UpdatedProductRequested(
productData: null == productData ? _self._productData : productData // ignore: cast_nullable_to_non_nullable
as JsonMap,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$EditProductState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProductState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProductState()';
}


}

/// @nodoc
class $EditProductStateCopyWith<$Res>  {
$EditProductStateCopyWith(EditProductState _, $Res Function(EditProductState) __);
}


/// Adds pattern-matching-related methods to [EditProductState].
extension EditProductStatePatterns on EditProductState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditProductInitial value)?  initial,TResult Function( EditProductLoading value)?  loading,TResult Function( EditProductSuccess value)?  success,TResult Function( EditProductFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditProductInitial() when initial != null:
return initial(_that);case EditProductLoading() when loading != null:
return loading(_that);case EditProductSuccess() when success != null:
return success(_that);case EditProductFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditProductInitial value)  initial,required TResult Function( EditProductLoading value)  loading,required TResult Function( EditProductSuccess value)  success,required TResult Function( EditProductFailure value)  failure,}){
final _that = this;
switch (_that) {
case EditProductInitial():
return initial(_that);case EditProductLoading():
return loading(_that);case EditProductSuccess():
return success(_that);case EditProductFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditProductInitial value)?  initial,TResult? Function( EditProductLoading value)?  loading,TResult? Function( EditProductSuccess value)?  success,TResult? Function( EditProductFailure value)?  failure,}){
final _that = this;
switch (_that) {
case EditProductInitial() when initial != null:
return initial(_that);case EditProductLoading() when loading != null:
return loading(_that);case EditProductSuccess() when success != null:
return success(_that);case EditProductFailure() when failure != null:
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
case EditProductInitial() when initial != null:
return initial();case EditProductLoading() when loading != null:
return loading();case EditProductSuccess() when success != null:
return success(_that.product);case EditProductFailure() when failure != null:
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
case EditProductInitial():
return initial();case EditProductLoading():
return loading();case EditProductSuccess():
return success(_that.product);case EditProductFailure():
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
case EditProductInitial() when initial != null:
return initial();case EditProductLoading() when loading != null:
return loading();case EditProductSuccess() when success != null:
return success(_that.product);case EditProductFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class EditProductInitial implements EditProductState {
  const EditProductInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProductInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProductState.initial()';
}


}




/// @nodoc


class EditProductLoading implements EditProductState {
  const EditProductLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProductLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProductState.loading()';
}


}




/// @nodoc


class EditProductSuccess implements EditProductState {
  const EditProductSuccess({required this.product});
  

 final  ProductEntity product;

/// Create a copy of EditProductState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProductSuccessCopyWith<EditProductSuccess> get copyWith => _$EditProductSuccessCopyWithImpl<EditProductSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProductSuccess&&(identical(other.product, product) || other.product == product));
}


@override
int get hashCode => Object.hash(runtimeType,product);

@override
String toString() {
  return 'EditProductState.success(product: $product)';
}


}

/// @nodoc
abstract mixin class $EditProductSuccessCopyWith<$Res> implements $EditProductStateCopyWith<$Res> {
  factory $EditProductSuccessCopyWith(EditProductSuccess value, $Res Function(EditProductSuccess) _then) = _$EditProductSuccessCopyWithImpl;
@useResult
$Res call({
 ProductEntity product
});




}
/// @nodoc
class _$EditProductSuccessCopyWithImpl<$Res>
    implements $EditProductSuccessCopyWith<$Res> {
  _$EditProductSuccessCopyWithImpl(this._self, this._then);

  final EditProductSuccess _self;
  final $Res Function(EditProductSuccess) _then;

/// Create a copy of EditProductState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,}) {
  return _then(EditProductSuccess(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductEntity,
  ));
}


}

/// @nodoc


class EditProductFailure implements EditProductState {
  const EditProductFailure({required this.message});
  

 final  String message;

/// Create a copy of EditProductState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProductFailureCopyWith<EditProductFailure> get copyWith => _$EditProductFailureCopyWithImpl<EditProductFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProductFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'EditProductState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $EditProductFailureCopyWith<$Res> implements $EditProductStateCopyWith<$Res> {
  factory $EditProductFailureCopyWith(EditProductFailure value, $Res Function(EditProductFailure) _then) = _$EditProductFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$EditProductFailureCopyWithImpl<$Res>
    implements $EditProductFailureCopyWith<$Res> {
  _$EditProductFailureCopyWithImpl(this._self, this._then);

  final EditProductFailure _self;
  final $Res Function(EditProductFailure) _then;

/// Create a copy of EditProductState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(EditProductFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
