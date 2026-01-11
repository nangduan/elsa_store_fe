// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SupplierState {
  SupplierStatus get status => throw _privateConstructorUsedError;
  List<SupplierResponse> get suppliers => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of SupplierState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupplierStateCopyWith<SupplierState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplierStateCopyWith<$Res> {
  factory $SupplierStateCopyWith(
    SupplierState value,
    $Res Function(SupplierState) then,
  ) = _$SupplierStateCopyWithImpl<$Res, SupplierState>;
  @useResult
  $Res call({
    SupplierStatus status,
    List<SupplierResponse> suppliers,
    String? errorMessage,
  });
}

/// @nodoc
class _$SupplierStateCopyWithImpl<$Res, $Val extends SupplierState>
    implements $SupplierStateCopyWith<$Res> {
  _$SupplierStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupplierState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? suppliers = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SupplierStatus,
            suppliers: null == suppliers
                ? _value.suppliers
                : suppliers // ignore: cast_nullable_to_non_nullable
                      as List<SupplierResponse>,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res>
    implements $SupplierStateCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SupplierStatus status,
    List<SupplierResponse> suppliers,
    String? errorMessage,
  });
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$SupplierStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SupplierState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? suppliers = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$InitialImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SupplierStatus,
        suppliers: null == suppliers
            ? _value._suppliers
            : suppliers // ignore: cast_nullable_to_non_nullable
                  as List<SupplierResponse>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl({
    this.status = SupplierStatus.initial,
    final List<SupplierResponse> suppliers = const [],
    this.errorMessage,
  }) : _suppliers = suppliers;

  @override
  @JsonKey()
  final SupplierStatus status;
  final List<SupplierResponse> _suppliers;
  @override
  @JsonKey()
  List<SupplierResponse> get suppliers {
    if (_suppliers is EqualUnmodifiableListView) return _suppliers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suppliers);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SupplierState(status: $status, suppliers: $suppliers, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._suppliers,
              _suppliers,
            ) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    const DeepCollectionEquality().hash(_suppliers),
    errorMessage,
  );

  /// Create a copy of SupplierState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      __$$InitialImplCopyWithImpl<_$InitialImpl>(this, _$identity);
}

abstract class _Initial implements SupplierState {
  const factory _Initial({
    final SupplierStatus status,
    final List<SupplierResponse> suppliers,
    final String? errorMessage,
  }) = _$InitialImpl;

  @override
  SupplierStatus get status;
  @override
  List<SupplierResponse> get suppliers;
  @override
  String? get errorMessage;

  /// Create a copy of SupplierState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
