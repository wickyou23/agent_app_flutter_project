class NWResponseObject {
  NWResponseObject({
    required this.status,
    required this.error,
    required this.data,
  });

  factory NWResponseObject.formJson({required Map<String, dynamic> json}) {
    final errorInt = json['error'] as int;
    return NWResponseObject(
      status: json['status'] as int,
      error: errorInt,
      data: json['data'],
    );
  }

  final int status;
  final int error;
  final dynamic data;
}
