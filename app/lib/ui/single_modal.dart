import 'package:flutter/material.dart';

final _activeOrigins = <ModalRoute<dynamic>>{};
final _activeActions = <(Object, Object)>{};

Future<T?> runSingleModalAction<T>({
  required BuildContext context,
  required Object action,
  required Future<T?> Function() body,
}) async {
  final token = (ModalRoute.of(context) ?? context, action);
  if (!_activeActions.add(token)) return null;
  try {
    return await body();
  } finally {
    _activeActions.remove(token);
  }
}

Future<T?> showSingleDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) => _showSingle(
  context,
  () => showDialog<T>(context: context, builder: builder),
);

Future<T?> showSingleModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) => _showSingle(
  context,
  () => showModalBottomSheet<T>(context: context, builder: builder),
);

Future<T?> _showSingle<T>(
  BuildContext context,
  Future<T?> Function() open,
) async {
  final origin = ModalRoute.of(context);
  if (origin == null || !_activeOrigins.add(origin)) return null;
  try {
    return await open();
  } finally {
    _activeOrigins.remove(origin);
  }
}
