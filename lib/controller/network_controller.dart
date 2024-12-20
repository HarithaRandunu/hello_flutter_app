import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkController extends GetxController {
  bool isConnectedToInternet = false;

  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    _internetConnectionStreamSubscription = InternetConnection().onStatusChange.listen((event) {
      print(event);
      switch (event) {
        case InternetStatus.connected:
          isConnectedToInternet = true;
          break;
        case InternetStatus.disconnected:
          isConnectedToInternet = false;
          break;
        default:
          isConnectedToInternet = false;
          break;
      }
      _updateConnectionStatus();
    }
    );
  }

  void _updateConnectionStatus() {
    if (!isConnectedToInternet) {
      Get.rawSnackbar(
        messageText: const Text(
            'Please Connect to the Internet.',
            style: TextStyle(
              color: CupertinoColors.white,
              fontSize: 14,
            ),
        ),
        isDismissible: false,
        duration: const Duration(days: 1),
        backgroundColor: CupertinoColors.systemRed,
        icon: const Icon(CupertinoIcons.wifi_slash, color: CupertinoColors.white),
        margin: const EdgeInsets.all(8),
        snackStyle: SnackStyle.GROUNDED,
        borderRadius: 20,
      );
    }
    else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}