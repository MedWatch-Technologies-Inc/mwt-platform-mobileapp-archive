import 'dart:io';

import 'package:dio/dio.dart';

import 'exception_helper.dart';

class ExceptionHandler implements Exception {
  ErrorModel? _errorModel;
  DioError? _dioError;
  Exception? _exception;

  ExceptionHandler(Exception error) {
    // Init the error model for the default case
    var errormsg = error;
    print(errormsg);
    _errorModel = ErrorModel(
        kApiUnknownErrorCode, kApiUnknownError, kErrorMessageGenericError);

    if (error is DioError) {
      _handleDioError(error);
      _dioError = error;
    }

    _exception = error;
  }

  ErrorModel? getErrorModel() => _errorModel;

  DioError? getDioError() => _dioError;

  Exception? getException() => _exception;

  void _handleDioError(DioError error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        _errorModel = ErrorModel(
            kApiCanceledCode, kApiCanceled, kErrorMessageGenericError);
        break;
      case DioExceptionType.connectionTimeout:
        _errorModel = ErrorModel(kApiConnectionTimeoutCode,
            kApiConnectionTimeout, kErrorMessageGenericError);
        break;
      case DioExceptionType.unknown:
        if (error.error is SocketException || error.error is HttpException) {
          _errorModel = ErrorModel(
              kApiDefaultCode, kApiDefault, kErrorMessageNetworkError);
        } else if (error.error is! String &&
            error.error == kHandshakeExceptionTypeKey) {
          _errorModel = ErrorModel(kApiHandshakeExceptionErrorCode,
              kApiHandshakeExceptionError, kErrorMessageHandshakeException);
        } else {
          _errorModel = ErrorModel(
              kApiDefaultCode, kApiDefault, kErrorMessageGenericError);
        }
        break;
      case DioExceptionType.receiveTimeout:
        _errorModel = ErrorModel(kApiReceiveTimeoutCode, kApiReceiveTimeout,
            kErrorMessageConnectionTimeout);
        break;
      case DioExceptionType.badResponse:
        _errorModel = ErrorModel(
            error.response?.statusCode ?? kApiUnknownErrorCode,
            kApiResponseError,
            kErrorMessageGenericError);
        break;
      case DioExceptionType.sendTimeout:
        _errorModel = ErrorModel(kApiSendTimeoutCode, kApiSendTimeout,
            kErrorMessageConnectionTimeout);
        break;
      default:
        _errorModel = ErrorModel(
            kApiUnknownErrorCode, kApiUnknownError, kErrorMessageGenericError);
    }
  }
}

class ErrorModel {
  int errorCode;
  String errorMessageKey;
  String errorMessage;
  String? responseStatus;

  ErrorModel(this.errorCode, this.errorMessageKey, this.errorMessage,
      {this.responseStatus});

  @override
  String toString() {
    return 'ErrorModel{errorMessageKey: $errorMessageKey, errorMessage: $errorMessage, errorCode: $errorCode}';
  }
}
