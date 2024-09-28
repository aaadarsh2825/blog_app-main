class ResponseOb<T> {
  T? data; // Make this field generic
  MsgState? message;
  ErrState? errState;
  PageLoad? pageLoad;

  ResponseOb({this.data, this.message, this.errState, this.pageLoad});
}

enum MsgState {
  data,
  loading,
  error
}

enum ErrState {
  userErr,
  tooMany,
  serverError,
  internetError
}

enum PageLoad {
  first,
  nextPage,
  noMore,
}
