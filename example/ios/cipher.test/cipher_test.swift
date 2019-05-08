import XCTest
@testable import encryptions

class cipher_test: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    // http://tomeko.net/online_tools/hex_to_base64.php
    // https://medium.com/@vialyx/security-data-transforms-with-swift-aes256-on-ios-6509917497d
    // https://github.com/shyandsy/cipher2/blob/master/ios/Classes/SwiftCipher2Plugin.swift
    // https://gist.github.com/hfossli/7165dc023a10046e2322b0ce74c596f8
    // http://extranet.cryptomathic.com/aescalc/index?key=DCE60234D641F71F377ECAFB5A566CE954D26C03FD3B5B23E9ED092EF42B5290&iv=C1F6FD873E14050697C168B3E9DA5DB2&input=01040000000300000002400000008B2E&mode=ecb&action=Encrypt&output=9A0106470245744F9121BBAFA5DD10DF
    
    
    func testAES256CBCNoPadding() {
        // key:dce60234d641f71f377ecafb5a566ce954d26c03fd3b5b23e9ed092ef42b5290
        // iv :c1f6fd873e14050697c168b3e9da5db2
        // raw:01040000000300000002400000008B2E
        // => :9a0106470245744f9121bbafa5dd10df
        let key = Data(base64Encoded: "3OYCNNZB9x83fsr7WlZs6VTSbAP9O1sj6e0JLvQrUpA=");
        let iv =  Data(base64Encoded: "wfb9hz4UBQaXwWiz6dpdsg==");
        let value = Data(base64Encoded: "AQQAAAADAAAAAkAAAACLLg==");
        
        let aes = try? AES(key: key!, iv: iv!);
        let encrypted = try! aes?.encrypt(raw: value!);
        XCTAssertEqual(encrypted!.hexEncodedString(), "9a0106470245744f9121bbafa5dd10df");
        
        let decrypted = try! aes?.decrypt(raw: encrypted!);
        XCTAssertEqual(decrypted!.hexEncodedString(), "01040000000300000002400000008b2e");
    }
    
    func testAES128CBCNoPaddingEnrypt(){
        // key:dce60234d641f71f377ecafb5a566ce9
        // iv :c1f6fd873e14050697c168b3e9da5db2
        // raw:01040000000300000002400000008B2E
        // => :64FB88A3F1A4D75D05C5508B2F2D4893
        let key = Data(base64Encoded: "3OYCNNZB9x83fsr7WlZs6Q==");
        let iv =  Data(base64Encoded: "wfb9hz4UBQaXwWiz6dpdsg==");
        let value = Data(base64Encoded: "AQQAAAADAAAAAkAAAACLLg==");
        
        let aes = try? AES(key: key!, iv: iv!);
        let encrypted = try? aes?.encrypt(raw: value!);
        
        XCTAssertEqual(encrypted?.hexEncodedString(), "64fb88a3f1a4d75d05c5508b2f2d4893");
        
        let decrypted = try! aes?.decrypt(raw: encrypted!);
        XCTAssertEqual(decrypted!.hexEncodedString(), "01040000000300000002400000008b2e");
    }
}
