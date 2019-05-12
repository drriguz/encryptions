import XCTest
@testable import encryptions

class argon2_test: XCTestCase {
    func testArgon2i(){
        /*
         hfli@CNhfli ~ $ echo -n "password" | argon2 "helloworld" -i -t 2 -m 16 -p 1 -l 32
         Type:        Argon2i
         Iterations:    2
         Memory:        65536 KiB
         Parallelism:    1
         Hash:        1fe7d8ae9f8946a5170aa6b96e8eea69b5f9351cbe457c4776e01f0b72a1e40e
         Encoded:    $argon2i$v=19$m=65536,t=2,p=1$aGVsbG93b3JsZA$H+fYrp+JRqUXCqa5bo7qabX5NRy+RXxHduAfC3Kh5A4
         0.126 seconds
         */
        let password = "password".data(using: .utf8);
        let salt = "helloworld".data(using: .utf8);
        
        let argon2 = Argon2(iterations: 2, memory: (1 << 16), parallelism: 1, hashLength: 32);
        let argon2iHash = argon2.argon2i(password: password!, salt: salt!);
        
        XCTAssertEqual(argon2iHash.hexEncodedString(), "1fe7d8ae9f8946a5170aa6b96e8eea69b5f9351cbe457c4776e01f0b72a1e40e");
    }
    
    func testArgon2d(){
        /*
         hfli@CNhfli ~ $ echo -n "password" | argon2 "helloworld" -d -t 2 -m 16 -p 1 -l 32
         Type:        Argon2d
         Iterations:    2
         Memory:        65536 KiB
         Parallelism:    1
         Hash:        251c68a5591a838647b5afa7d1379cc63690daffcedb1e725528789014064fab
         Encoded:    $argon2d$v=19$m=65536,t=2,p=1$aGVsbG93b3JsZA$JRxopVkag4ZHta+n0TecxjaQ2v/O2x5yVSh4kBQGT6s
         0.129 seconds
         */
        let password = "password".data(using: .utf8);
        let salt = "helloworld".data(using: .utf8);
        
        let argon2 = Argon2(iterations: 2, memory: (1 << 16), parallelism: 1, hashLength: 32);
        let argon2dHash = argon2.argon2d(password: password!, salt: salt!);
        
        XCTAssertEqual(argon2dHash.hexEncodedString(), "251c68a5591a838647b5afa7d1379cc63690daffcedb1e725528789014064fab");
    }
}
