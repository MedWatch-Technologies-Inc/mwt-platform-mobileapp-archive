// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _UserClient implements UserClient {
  _UserClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ForgetUserIdResult> forgetUserID(email) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'Email': email};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ForgetUserIdResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/ForgetUserID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ForgetUserIdResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ForgetPasswordUsingUserNameResult> forgetPasswordUsingUserName(
      forgetPasswordUsingUserNameRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(forgetPasswordUsingUserNameRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ForgetPasswordUsingUserNameResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/ForgetPasswordUsingUserName',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ForgetPasswordUsingUserNameResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ForgetPasswordChooseMediumResult> forgetPasswordChooseMedium(
      forgetPasswordChooseMediumRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(forgetPasswordChooseMediumRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ForgetPasswordChooseMediumResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/ForgetPasswordChooseMedium',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ForgetPasswordChooseMediumResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VerifyOtpResult> verifyOTP(verifyOtpRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(verifyOtpRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VerifyOtpResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/VerifyOTP',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VerifyOtpResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ResetPasswordUsingUserNameResult> resetPasswordUsingUserName(
      resetPasswordUsingUserNameRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(resetPasswordUsingUserNameRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ResetPasswordUsingUserNameResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/ResetPasswordUsingUserName',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ResetPasswordUsingUserNameResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ChangePasswordByUserIdResult> changePasswordByUserID(
      authToken, userId, oldPassword, newPassword) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'UserId': userId,
      r'OldPassword': oldPassword,
      r'NewPassword': newPassword
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ChangePasswordByUserIdResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/ChangePasswordByUserID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ChangePasswordByUserIdResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LoginResult> getUSerDetailsByUserID(authToken, userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'UserId': userId};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LoginResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetUSerDetailsByUserID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LoginResult.fromJson(_result.data!);
    var user = UserModel.mapper(value.data!);
    dbHelper.insertUser(user.toJsonForInsertUsingSignInOrSignUp(), user.id?.toString() ?? '');
    return value;
  }

  @override
  Future<LoginResult> editUser(authToken, editUserRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(editUserRequest.toJson());
    print('jsonDataUser :: ${jsonEncode(editUserRequest.toJson())}');
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LoginResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/EditUser',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LoginResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserExistResult> checkDuplicateUserIDAndEmail(
      emailOrUserID, type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'EmailOrUserID': emailOrUserID,
      r'Type': type
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserExistResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/CheckDuplicateUserIDAndEmail',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserExistResult.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
