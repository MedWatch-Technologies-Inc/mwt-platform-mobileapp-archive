import 'package:flutter/material.dart';

class KeepAliveFutureBuilder<T> extends StatefulWidget {
  final AsyncWidgetBuilder<T> builder;
  final Future<T>? future;
  final T? initialData;

  const KeepAliveFutureBuilder(
      {required this.builder, this.future, this.initialData, Key? key})
      : super(key: key);

  @override
  _KeepAliveFutureBuilderState<T> createState() =>
      _KeepAliveFutureBuilderState<T>();
}

class _KeepAliveFutureBuilderState<T> extends State<KeepAliveFutureBuilder<T>>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      builder: widget.builder,
      future: widget.future,
      initialData: widget.initialData,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
