import Flutter
import UIKit

public class SwiftEncryptionsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "encryptions", binaryMessenger: registrar.messenger())
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
        case "argon2i", "argon2d", "argon2id":
            let password = args["password"] as! FlutterStandardTypedData;
            let salt = args["salt"] as! FlutterStandardTypedData;
            let iterations = args["iterations"] as! UInt32;
            let memory = args["memory"] as! UInt32;
            let parallelism = args["parallelism"] as! UInt32;
            let hashLength = args["hashLength"] as! UInt32;
            do {
                let hash = try handleArgon2(iterations: iterations, memory: memory, parallelism: parallelism, hashLength: hashLength, password: password.data, salt: salt.data, method: call.method);
                result(hash);
            } catch let err as NSError {
                let error = FlutterError(code: "500", message:err.localizedDescription, details: err.description)
                result(error)
            }
        default:
            result(FlutterMethodNotImplemented);
        }
    }
    
    private func handleAes(key: Data, iv: Data, value: Data, mode: String, padding: String, method: String) throws->Data?{
        let aes = try AES(key: key, iv: iv, mode: mode, padding: padding);
        var result:Data?;
        switch(method) {
        case "aesEncrypt":
            return try aes.encrypt(raw: value);
        case "aesDecrypt":
            return try aes.decrypt(raw: value);
        default:
            return nil;
        }
    }
    
    private func handleArgon2(iterations: UInt32, memory: UInt32, parallelism: UInt32, hashLength: UInt32,
                              password: Data, salt: Data, method: String) throws -> Data?{
        let argon2 = Argon2(iterations: iterations, memory: memory, parallelism: parallelism, hashLength: hashLength);
        switch(method) {
        case "argon2i":
            return try argon2.argon2i(password: password, salt: salt);
        case "argon2d":
            return try argon2.argon2d(password: password, salt: salt);
        case "argon2id":
            return try argon2.argon2id(password: password, salt: salt);
        default:
            return nil;
        }
    }
}
