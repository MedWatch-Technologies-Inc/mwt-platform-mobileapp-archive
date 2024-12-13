import 'package:dio/dio.dart';
import '../api/app_exception.dart';
import '../api/exception_helper.dart';
import '../core_util/common_utils.dart';

import 'app_error_type.dart';

class AppError {
  AppErrorType? _appErrorType;
  String? _errorCode;
  int? _apiCode;
  String? displayMessage;

  //Debug purpose only
  DioError? _dioError;
  Exception? _exception;
  Error? _error;
  ErrorModel? _errorModel;

  Exception? get exception => _exception;

  AppErrorType get appErrorType =>
      _appErrorType ?? AppErrorType.unknownHandlingError;

  String get errorCode => _errorCode ?? kApiUnknownError;

  int get apiCode => _apiCode ?? kApiUnknownErrorCode;

  AppError.withApiException(ExceptionHandler? error, {String? displayMessage}) {
    if (error != null &&
        error.getErrorModel() != null &&
        error.getErrorModel()!.errorMessageKey.hasValidData()) {
      _dioError = error.getDioError();
      _exception = error.getException();
      _errorModel = error.getErrorModel();
      _setErrorType(_errorModel?.errorMessageKey,
          apiCode: _errorModel?.errorCode);
      this.displayMessage = displayMessage;
    } else {
      AppError.defaultException(displayMessage: displayMessage);
    }
  }

  // AppError.withRestaurantException(result.getRestaurantException)
  // AppError.defaultError(exception: error)

  //TODO (anshul_daffodil) -> Need proper handling

  AppError.defaultException({Exception? exception, this.displayMessage}) {
    _defaultError();
    _exception = exception;
  }

  AppError.defaultError({Error? error, this.displayMessage}) {
    _defaultError();
    _error = error;
  }

  void _defaultError() {
    _appErrorType = AppErrorType.unknownHandlingError;
  }

  void _setErrorType(String? errorCode, {int? apiCode}) {
    if (errorCode?.hasValidData() ?? false) {
      errorCode = errorCode!.trim().toUpperCase();
      if (errorCode.contains(kApiCanceled)) {
        _appErrorType = AppErrorType.canceledError;
        _apiCode = kApiCanceledCode;
        _errorCode = kApiCanceled;
      } else if (errorCode.contains(kApiConnectionTimeout)) {
        _appErrorType = AppErrorType.connectionTimeOutError;
        _apiCode = kApiConnectionTimeoutCode;
        _errorCode = kApiConnectionTimeout;
      } else if (errorCode.contains(kApiDefault)) {
        _appErrorType = AppErrorType.defaultError;
        _apiCode = kApiDefaultCode;
        _errorCode = kApiDefault;
      } else if (errorCode.contains(kApiReceiveTimeout)) {
        _appErrorType = AppErrorType.receivedTimeOutError;
        _apiCode = kApiReceiveTimeoutCode;
        _errorCode = kApiReceiveTimeout;
      } else if (errorCode.contains(kApiSendTimeout)) {
        _appErrorType = AppErrorType.sendTimeoutCode;
        _apiCode = kApiCanceledCode;
        _errorCode = kApiCanceled;
      } else if (errorCode.contains(kApiHandshakeExceptionError)) {
        _appErrorType = AppErrorType.handshakeError;
        _apiCode = kApiHandshakeExceptionErrorCode;
        _errorCode = kApiHandshakeExceptionError;
      } else if (errorCode.contains(kApiResponseError)) {
        // TODO: Handle response based error once API returns proper error code
        _appErrorType = AppErrorType.responseError;
        _apiCode = apiCode;
        _errorCode = kApiResponseError;
      } else {
        _appErrorType = AppErrorType.unknownApiError;
        _apiCode = kApiUnknownErrorCode;
        _errorCode = kApiUnknownError;
      }
    } else {
      _defaultError();
    }
  }
}
