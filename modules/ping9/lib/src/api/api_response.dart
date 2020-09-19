import 'dart:async';
import 'dart:core';

class ApiResponse<T> {
  StreamController onStatusChanged;

  String message;

  T _data;

  T get data => _data;

  Status _status;

  Status get status => _status;

  set status(Status value) {
    _status = value;
    onStatusChanged.add(_status);
  }

  bool get isLoading => _status == Status.loading;

  bool get isCompleted => _status == Status.success;

  bool get isError => _status == Status.error;

  set loading(String message) {
    this.message = message;
    status = Status.loading;
    _data = null;
  }

  set completed(T data) {
    this._data = data;
    this.message = '';

    status = Status.success;
  }

  set error(String message) {
    this.message = message;
    _data = null;
    status = Status.error;
  }

  ApiResponse() {
    message = 'Not load yet';
    _status = Status.none;
    _data = null;
    onStatusChanged = StreamController<Status>.broadcast();
  }

  bool isLoadFinish() {
    return this._status == Status.success;
  }
}

enum Status { none, loading, error, success }
