// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_product_by_id_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetProductByIdEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetProductByIdEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProductByIdEvent()';
}


}

/// @nodoc
class $GetProductByIdEventCopyWith<$Res>  {
$GetProductByIdEventCopyWith(GetProductByIdEvent _, $Res Function(GetProductByIdEvent) __);
}


/// Adds pattern-matching-related methods to [GetProductByIdEvent].
extension GetProductByIdEventPatterns on GetProductByIdEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( GetProductByIdRequested value)?  getProductByIdRequested,TResult Function( ProductUpdatedLocally value)?  productUpdatedLocally,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case GetProductByIdRequested() when getProductByIdRequested != null:
return getProductByIdRequested(_that);case ProductUpdatedLocally() when productUpdatedLocally != null:
return productUpdatedLocally(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( GetProductByIdRequested value)  getProductByIdRequested,required TResult Function( ProductUpdatedLocally value)  productUpdatedLocally,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case GetProductByIdRequested():
return getProductByIdRequested(_that);case ProductUpdatedLocally():
return productUpdatedLocally(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( GetProductByIdRequested value)?  getProductByIdRequested,TResult? Function( ProductUpdatedLocally value)?  productUpdatedLocally,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case GetProductByIdRequested() when getProductByIdRequested != null:
return getProductByIdRequested(_that);case ProductUpdatedLocally() when productUpdatedLocally != null:
return productUpdatedLocally(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String id)?  getProductByIdRequested,TResult Function( ProductEntity product)?  productUpdatedLocally,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case GetProductByIdRequested() when getProductByIdRequested != null:
return getProductByIdRequested(_that.id);case ProductUpdatedLocally() when productUpdatedLocally != null:
return productUpdatedLocally(_that.product);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String id)  getProductByIdRequested,required TResult Function( ProductEntity product)  productUpdatedLocally,}) {final _that = this;
switch (_that) {
case _Started():
return started();case GetProductByIdRequested():
return getProductByIdRequested(_that.id);case ProductUpdatedLocally():
return productUpdatedLocally(_that.product);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String id)?  getProductByIdRequested,TResult? Function( ProductEntity product)?  productUpdatedLocally,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case GetProductByIdRequested() when getProductByIdRequested != null:
return getProductByIdRequested(_that.id);case ProductUpdatedLocally() when productUpdatedLocally != null:
return productUpdatedLocally(_that.product);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements GetProductByIdEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProductByIdEvent.started()';
}


}




/// @nodoc


class GetProductByIdRequested implements GetProductByIdEvent {
  const GetProductByIdRequested({required this.id});
  

 final  String id;

/// Create a copy of GetProductByIdEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetProductByIdRequestedCopyWith<GetProductByIdRequested> get copyWith => _$GetProductByIdRequestedCopyWithImpl<GetProductByIdRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetProductByIdRequested&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'GetProductByIdEvent.getProductByIdRequested(id: $id)';
}


}

/// @nodoc
abstract mixin class $GetProductByIdRequestedCopyWith<$Res> implements $GetProductByIdEventCopyWith<$Res> {
  factory $GetProductByIdRequestedCopyWith(GetProductByIdRequested value, $Res Function(GetProductByIdRequested) _then) = _$GetProductByIdRequestedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$GetProductByIdRequestedCopyWithImpl<$Res>
    implements $GetProductByIdRequestedCopyWith<$Res> {
  _$GetProductByIdRequestedCopyWithImpl(this._self, this._then);

  final GetProductByIdRequested _self;
  final $Res Function(GetProductByIdRequested) _then;

/// Create a copy of GetProductByIdEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(GetProductByIdRequested(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProductUpdatedLocally implements GetProductByIdEvent {
  const ProductUpdatedLocally({required this.product});
  

 final  ProductEntity product;

/// Create a copy of GetProductByIdEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductUpdatedLocallyCopyWith<ProductUpdatedLocally> get copyWith => _$ProductUpdatedLocallyCopyWithImpl<ProductUpdatedLocally>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductUpdatedLocally&&(identical(other.product, product) || other.product == product));
}


@override
int get hashCode => Object.hash(runtimeType,product);

@override
String toString() {
  return 'GetProductByIdEvent.productUpdatedLocally(product: $product)';
}


}

/// @nodoc
abstract mixin class $ProductUpdatedLocallyCopyWith<$Res> implements $GetProductByIdEventCopyWith<$Res> {
  factory $ProductUpdatedLocallyCopyWith(ProductUpdatedLocally value, $Res Function(ProductUpdatedLocally) _then) = _$ProductUpdatedLocallyCopyWithImpl;
@useResult
$Res call({
 ProductEntity product
});




}
/// @nodoc
class _$ProductUpdatedLocallyCopyWithImpl<$Res>
    implements $ProductUpdatedLocallyCopyWith<$Res> {
  _$ProductUpdatedLocallyCopyWithImpl(this._self, this._then);

  final ProductUpdatedLocally _self;
  final $Res Function(ProductUpdatedLocally) _then;

/// Create a copy of GetProductByIdEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,}) {
  return _then(ProductUpdatedLocally(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductEntity,
  ));
}


}

/// @nodoc
mixin _$GetProductByIdState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetProductByIdState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProductByIdState()';
}


}

/// @nodoc
class $GetProductByIdStateCopyWith<$Res>  {
$GetProductByIdStateCopyWith(GetProductByIdState _, $Res Function(GetProductByIdState) __);
}


/// Adds pattern-matching-related methods to [GetProductByIdState].
extension GetProductByIdStatePatterns on GetProductByIdState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductInitial value)?  initial,TResult Function( ProductLoading value)?  loading,TResult Function( ProductLoaded value)?  loaded,TResult Function( ProductFailure value)?  failure,TResult Function( ProductEmpty value)?  empty,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductInitial() when initial != null:
return initial(_that);case ProductLoading() when loading != null:
return loading(_that);case ProductLoaded() when loaded != null:
return loaded(_that);case ProductFailure() when failure != null:
return failure(_that);case ProductEmpty() when empty != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductInitial value)  initial,required TResult Function( ProductLoading value)  loading,required TResult Function( ProductLoaded value)  loaded,required TResult Function( ProductFailure value)  failure,required TResult Function( ProductEmpty value)  empty,}){
final _that = this;
switch (_that) {
case ProductInitial():
return initial(_that);case ProductLoading():
return loading(_that);case ProductLoaded():
return loaded(_that);case ProductFailure():
return failure(_that);case ProductEmpty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductInitial value)?  initial,TResult? Function( ProductLoading value)?  loading,TResult? Function( ProductLoaded value)?  loaded,TResult? Function( ProductFailure value)?  failure,TResult? Function( ProductEmpty value)?  empty,}){
final _that = this;
switch (_that) {
case ProductInitial() when initial != null:
return initial(_that);case ProductLoading() when loading != null:
return loading(_that);case ProductLoaded() when loaded != null:
return loaded(_that);case ProductFailure() when failure != null:
return failure(_that);case ProductEmpty() when empty != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( ProductEntity res)?  loaded,TResult Function( String message)?  failure,TResult Function()?  empty,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductInitial() when initial != null:
return initial();case ProductLoading() when loading != null:
return loading();case ProductLoaded() when loaded != null:
return loaded(_that.res);case ProductFailure() when failure != null:
return failure(_that.message);case ProductEmpty() when empty != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( ProductEntity res)  loaded,required TResult Function( String message)  failure,required TResult Function()  empty,}) {final _that = this;
switch (_that) {
case ProductInitial():
return initial();case ProductLoading():
return loading();case ProductLoaded():
return loaded(_that.res);case ProductFailure():
return failure(_that.message);case ProductEmpty():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( ProductEntity res)?  loaded,TResult? Function( String message)?  failure,TResult? Function()?  empty,}) {final _that = this;
switch (_that) {
case ProductInitial() when initial != null:
return initial();case ProductLoading() when loading != null:
return loading();case ProductLoaded() when loaded != null:
return loaded(_that.res);case ProductFailure() when failure != null:
return failure(_that.message);case ProductEmpty() when empty != null:
return empty();case _:
  return null;

}
}

}

/// @nodoc


class ProductInitial implements GetProductByIdState, BaseInitial {
  const ProductInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProductByIdState.initial()';
}


}




/// @nodoc


class ProductLoading implements GetProductByIdState, BaseLoading {
  const ProductLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProductByIdState.loading()';
}


}




/// @nodoc


class ProductLoaded implements GetProductByIdState, BaseLoaded<ProductEntity> {
  const ProductLoaded({required this.res});
  

 final  ProductEntity res;

/// Create a copy of GetProductByIdState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductLoadedCopyWith<ProductLoaded> get copyWith => _$ProductLoadedCopyWithImpl<ProductLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductLoaded&&(identical(other.res, res) || other.res == res));
}


@override
int get hashCode => Object.hash(runtimeType,res);

@override
String toString() {
  return 'GetProductByIdState.loaded(res: $res)';
}


}

/// @nodoc
abstract mixin class $ProductLoadedCopyWith<$Res> implements $GetProductByIdStateCopyWith<$Res> {
  factory $ProductLoadedCopyWith(ProductLoaded value, $Res Function(ProductLoaded) _then) = _$ProductLoadedCopyWithImpl;
@useResult
$Res call({
 ProductEntity res
});




}
/// @nodoc
class _$ProductLoadedCopyWithImpl<$Res>
    implements $ProductLoadedCopyWith<$Res> {
  _$ProductLoadedCopyWithImpl(this._self, this._then);

  final ProductLoaded _self;
  final $Res Function(ProductLoaded) _then;

/// Create a copy of GetProductByIdState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? res = null,}) {
  return _then(ProductLoaded(
res: null == res ? _self.res : res // ignore: cast_nullable_to_non_nullable
as ProductEntity,
  ));
}


}

/// @nodoc


class ProductFailure implements GetProductByIdState, BaseFailure {
  const ProductFailure({required this.message});
  

 final  String message;

/// Create a copy of GetProductByIdState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductFailureCopyWith<ProductFailure> get copyWith => _$ProductFailureCopyWithImpl<ProductFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'GetProductByIdState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $ProductFailureCopyWith<$Res> implements $GetProductByIdStateCopyWith<$Res> {
  factory $ProductFailureCopyWith(ProductFailure value, $Res Function(ProductFailure) _then) = _$ProductFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ProductFailureCopyWithImpl<$Res>
    implements $ProductFailureCopyWith<$Res> {
  _$ProductFailureCopyWithImpl(this._self, this._then);

  final ProductFailure _self;
  final $Res Function(ProductFailure) _then;

/// Create a copy of GetProductByIdState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ProductFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProductEmpty implements GetProductByIdState, BaseEmpty {
  const ProductEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetProductByIdState.empty()';
}


}




// dart format on
