import 'package:daily_task_app/models/app_model.dart';
import 'package:device_installed_apps/app_info.dart';
import 'package:device_installed_apps/device_installed_apps.dart';

import 'package:flutter/material.dart';

class DeviceAppScreen extends StatefulWidget {
  const DeviceAppScreen({super.key});

  @override
  State<DeviceAppScreen> createState() => _DeviceAppScreenState();
}

class _DeviceAppScreenState extends State<DeviceAppScreen> {
  List<AppInfo> _apps = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    DeviceInstalledApps.getApps(
      includeSystemApps: true,
      includeIcon: true,
      permissions: [
        'android.permission.NFC',
        'android.permission.ACCESS_FINE_LOCATION'
      ],
      shouldHasAllPermissions: false,
    ).then((value) => {
          _apps = value,
          isLoading = false,
          setState(() {}),
          // print("(DeviceInstalledApps) 1- ${value.length}"),
          // for (var i = 0; i < value.length; i++)
          //   {print("(DeviceInstalledApps) 1.$i- ${value[i].bundleId}")}
        });

    // DeviceInstalledApps.getSystemApps().then((value) => {
    //       print("(DeviceInstalledApps) 2- ${value.length}"),
    //       for (var i = 0; i < value.length; i++)
    //         {print("(DeviceInstalledApps) 2.$i- ${value[i].bundleId}")}
    //     });

    // DeviceInstalledApps.getAppsBundleIds()
    //     .then((value) => {print("(DeviceInstalledApps) 3- ${value.length}")});

    // DeviceInstalledApps.getAppInfo('com.hofinity')
    //     .then((value) => {print("(DeviceInstalledApps) 4- ${value.name}")});

    // DeviceInstalledApps.isSystemApp('com.hofinity')
    //     .then((value) => {print("(DeviceInstalledApps) 5- $value")});

    // DeviceInstalledApps.launchApp('com.hofinity')
    //     .then((value) => {print("(DeviceInstalledApps) 6- $value")});

    // DeviceInstalledApps.openAppSetting('com.hofinity');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Select App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: _apps.length,
                itemBuilder: (context, index) {
                  AppInfo app = _apps[index];
                  return ListTile(
                    leading: app.icon != null
                        ? Image.memory(app.icon!, width: 40, height: 40)
                        : null,
                    title: Text(app.name ?? 'Unknown'),
                    subtitle: Text(app.bundleId ?? 'Unknown package'),
                    onTap: () {
                      Navigator.pop(
                          context,
                          AppModel(
                            icon: app.icon,
                            name: app.name,
                            bundleId: app.bundleId,
                          ));
                      // _openApp(app.bundleId!);
                    }, // Open the app on tap
                  );
                },
              ),
      ),
    );
  }
}
