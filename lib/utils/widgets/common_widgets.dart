import 'package:agent_app/res/res.dart';
import 'package:agent_app/utils/widgets/tp_button_widget.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// class LoadingViewWidget extends StatelessWidget {
//   const LoadingViewWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       child: const SpinKitCircle(
//         color: AppColors.primaryColor,
//         size: 80,
//       ),
//     );
//   }
// }

class ErrorViewWidget extends StatelessWidget {
  const ErrorViewWidget({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: const Alignment(0, -0.25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            message!,
            style: textTheme(context).bodyText1!.colorDart,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimens.spacing16),
          TPButton.filledButton(title: 'Retry', onPressed: onRetry),
        ],
      ),
    );
  }
}
