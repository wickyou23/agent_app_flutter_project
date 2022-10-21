import 'package:agent_app/bloc/value_cubit.dart';
import 'package:agent_app/res/res.dart';
import 'package:agent_app/views/camera/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _version = '0';
  String _buildNumber = '0';

  final _isShowLoading = ValueCubit.value(false);

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((value) {
      _version = value.version;
      _buildNumber = value.buildNumber;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${context.localization.dashboard} v$_version($_buildNumber)'),
            const SizedBox(height: 20),
            BlocBuilder(
              bloc: _isShowLoading,
              builder: (context, state) {
                return Column(
                  children: [
                    if (_isShowLoading.value) const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // context.navigator.pushNamed(CameraScreen.keyName);
                        _isShowLoading.value = !_isShowLoading.value;
                      },
                      child: Text(context.localization.touchMe),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
