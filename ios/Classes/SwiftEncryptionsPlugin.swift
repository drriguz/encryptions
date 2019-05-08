import Flutter
import UIKit
import CoreFoundation

public class SwiftEncryptionsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "encryptions", binaryMessenger: registrar.messenger())
        let instance = SwiftEncryptionsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func handleAes(key: Data, iv: Data, value: Data, method: String) throws->Data?{
        let aes = try AES(key: key, iv: iv);
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
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "aesEncrypt", "aesDecrypt":
            if let args = call.arguments as? [String: Any] {
                let key = args["key"] as! FlutterStandardTypedData;
                let iv = args["iv"] as! FlutterStandardTypedData;
                let value = args["value"] as! FlutterStandardTypedData;
                
                do {
                    let cipher = try handleAes(key: key.data, iv: iv.data, value: value.data, method: call.method);
                    result(cipher);
                } catch {
                    result(nil);
                };
            }
            
        case "argon2i":
            result(Data(bytes: [1, 2, 3, 4, 5]));
        default:
            result(FlutterMethodNotImplemented);
        }
    }
}
