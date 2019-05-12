import Foundation

struct Argon2 {
    private let iterations: UInt32;
    private let memory: UInt32;
    private let parallelism: UInt32;
    private let hashLength: Int;
    
    init(iterations: UInt32,
         memory: UInt32,
         parallelism: UInt32,
         hashLength: Int){
        self.iterations = iterations;
        self.memory = memory;
        self.parallelism = parallelism;
        self.hashLength = hashLength;
    }
    
    func argon2i(password: Data, salt: Data)-> Data {
        var outputBytes  = [UInt8](repeating: 0, count: hashLength);
        
        password.withUnsafeBytes { passwordBytes in
            salt.withUnsafeBytes {
                saltBytes in
                argon2i_hash_raw(iterations, memory, parallelism, passwordBytes, password.count, saltBytes, salt.count, &outputBytes, hashLength);
            }
        }
        
        return Data(bytes: UnsafePointer<UInt8>(outputBytes), count: hashLength);
    }
    
    func argon2d(password: Data, salt: Data)-> Data {
        var outputBytes  = [UInt8](repeating: 0, count: hashLength);
        
        password.withUnsafeBytes { passwordBytes in
            salt.withUnsafeBytes {
                saltBytes in
                argon2d_hash_raw(iterations, memory, parallelism, passwordBytes, password.count, saltBytes, salt.count, &outputBytes, hashLength);
            }
        }
        
        return Data(bytes: UnsafePointer<UInt8>(outputBytes), count: hashLength);
    }
}
