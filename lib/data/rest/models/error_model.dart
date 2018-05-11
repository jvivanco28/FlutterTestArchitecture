class ErrorModel {
  // Could add other error fields...
  final String msg;

  ErrorModel({this.msg}); //  ErrorModel(Response httpResponse) {

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return new ErrorModel(
      // The ?? means use the first expression if not null, else use the second expression.
      msg: json['msg'] ?? "What!? The API didn't give us an error msg! :o",
    );
  }

  @override
  String toString() {
    return 'ErrorModel{msg: $msg}';
  }
}
