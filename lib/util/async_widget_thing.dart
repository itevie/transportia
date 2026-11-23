class AsyncWidgetThingResponse {
  final dynamic error;
  final bool loading;

  const AsyncWidgetThingResponse({this.error, this.loading = false});
}

Future<T?> handleAsync<T>(
  String label,
  Future<T> future, {
  void Function(AsyncWidgetThingResponse)? callback,
}) async {
  callback?.call(AsyncWidgetThingResponse(loading: true));

  try {
    final result = await future;
    callback?.call(AsyncWidgetThingResponse());
    return result;
  } catch (e) {
    callback?.call(AsyncWidgetThingResponse(error: e));
    return null;
  }
}

// class AsyncWidgetThingDisplay extends StatelessWidget {
//   final dynamic object;
//   const AsyncWidgetThingDisplay({super.key, this.object});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: object == null
//           ? Text("Request was ok, something is wrong with widget tree.")
//           : object is AsyncWidgetThingLoading
//           ? Expanded(child: CircularProgressIndicator())
//           : Text("Error: $object"),
//     );
//   }
// }
