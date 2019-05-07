import Flutter
import UIKit

public class SwiftEncryptionsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "encryptions", binaryMessenger: registrar.messenger())
    let instance = SwiftEncryptionsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let bytes:[UInt8] = [1, 2, 3, 4, 5];
    let data = NSData(bytes:bytes, length: 5);
    switch call.method {
    case "aesEncrypt","aesDecrypt","argon2i":
        result(FlutterStandardTypedData(bytes: data as Data));
    default:
        result(FlutterMethodNotImplemented);
    }
    
    result("iOS " + UIDevice.current.systemVersion)
  }
}
