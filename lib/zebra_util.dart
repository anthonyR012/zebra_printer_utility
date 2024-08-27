import 'dart:async';
import 'package:flutter/services.dart';
import 'package:zebrautil/zebra_printer.dart';

class ZebraUtil {
  static const MethodChannel _channel = const MethodChannel('zebrautil');

  static Future<ZebraPrinter> getPrinterInstance(
      {Function(String, String?)? onDiscoveryError,
      Function? onPermissionDenied}) async {
    String id = await _channel.invokeMethod("getInstance");
    ZebraPrinter printer = ZebraPrinter(id,
        onDiscoveryError: onDiscoveryError,
        onPermissionDenied: onPermissionDenied);
    return printer;
  }
}
