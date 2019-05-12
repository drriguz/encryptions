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
    
    private func handleArgon2(){
        
    }
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any];
        switch call.method {
        case "aesEncrypt", "aesDecrypt":
            let key = args["key"] as! FlutterStandardTypedData;
            let iv = args["iv"] as! FlutterStandardTypedData;
            let value = args["value"] as! FlutterStandardTypedData;
            
            do {
                let cipher = try handleAes(key: key.data, iv: iv.data, value: value.data, method: call.method);
                result(cipher);
            } catch {
                result(nil);
            };
            
            
        case "argon2i":
            let password = args["password"] as! FlutterStandardTypedData;
            let salt = args["salt"] as! FlutterStandardTypedData;
            
            print(password.data.hexEncodedString(), salt.data.hexEncodedString());
            let argon2 = Argon2(iterations: 2, memory: (1 << 16), parallelism: 1, hashLength: 32);
            let hash = argon2.argon2i(password: password.data, salt: salt.data);
            result(hash);
            
        case "argon2d":
            let password = args["password"] as! FlutterStandardTypedData;
            let salt = args["salt"] as! FlutterStandardTypedData;
            
            let argon2 = Argon2(iterations: 2, memory: (1 << 16), parallelism: 1, hashLength: 32);
            let hash = argon2.argon2d(password: password.data, salt: salt.data);
            result(hash);
        default:
            result(FlutterMethodNotImplemented);
        }
    }
}
