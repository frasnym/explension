import 'package:flutter/material.dart';

class LoadingDialog<T> extends StatelessWidget {
  final Future<T> future;
  final WidgetBuilder builder;

  const LoadingDialog({
    Key? key,
    required this.future,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading...'),
              ],
            ),
          );
        } else {
          return builder(context);
        }
      },
    );
  }
}
