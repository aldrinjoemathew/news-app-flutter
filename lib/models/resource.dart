class Resource<T> {
  String error;
  Status status;
  int code;
  T data;

  Resource.success(this.data) {
    this.status = Status.Success;
    this.error = null;
  }

  Resource.failure(this.error) {
    this.status = Status.Error;
    this.data = null;
  }

  Resource.loading() {
    this.status = Status.Loading;
    this.data = null;
    this.error = null;
  }

  Resource.empty() {
    this.status = Status.Empty;
    this.data = null;
  }

  bool isSuccess() => this.status == Status.Success;

  bool isFailure() => this.status == Status.Error;

  bool isEmpty() => this.status == Status.Empty;
}

enum Status { Success, Error, Loading, Refreshing, LoadingMore, Empty }
