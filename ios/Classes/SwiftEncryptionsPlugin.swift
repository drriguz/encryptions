import Flutter
import UIKit

public class SwiftEncryptionsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "encryptions_aes", binaryMessenger: registrar.messenger())
        let instance = SwiftEncryptionsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any];
        switch call.method {
        case "aesEncrypt", "aesDecrypt":
            let key = args["key"] as! FlutterStandardTypedData;
            let iv = args["iv"] as! FlutterStandardTypedData;
            let value = args["value"] as! FlutterStandardTypedData;
            let padding = args["padding"] as! String;
            let mode = args["mode"] as! String;
            
            do {
                let cipher = try handleAes(key: key.data, iv: iv.data, value: value.data, mode: mode, padding: padding, method: call.method);
                result(cipher);
            } catch let err as NSError{
            
                let error = FlutterError(code: "500", message:err.localizedDescription, details: err.description)
                result(error)
            };
        default:
            result(FlutterMethodNotImplemented);
        }
    }
    
    private func handleAes(key: Data, iv: Data, value: Data, mode: String, padding: String, method: String) throws->Data?{
        let aes = try AES(key: key, iv: iv, mode: mode, padding: padding);
        var result:Data?;
        switch(method) {
        case "aesEncrypt":
            result = try aes.encrypt(raw: value);
        case "aesDecrypt":
            result = try aes.decrypt(raw: value);
        default:
            result = nil;
        }
        return result;
    }
    
}
