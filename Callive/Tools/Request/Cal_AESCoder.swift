
import Foundation
import CommonCrypto

enum AESCoder {
    static func encrypt(_ text: String) -> String? {
        guard let data = text.data(using: .utf8) else { return nil }
        return crypt(data, operation: CCOperation(kCCEncrypt))?.hexString
    }

    static func decrypt(_ text: String) -> String? {
        guard let data = Data(hexString: text) else { return nil }
        return crypt(data, operation: CCOperation(kCCDecrypt)).flatMap {
            String(data: $0, encoding: .utf8)
        }
    }

    static func encryptBase64(_ text: String, key: String, iv: String) -> String? {
        guard let data = text.data(using: .utf8) else { return nil }
        return crypt(data, operation: CCOperation(kCCEncrypt), key: key, iv: iv)?.base64EncodedString()
    }

    static func decryptHex(_ text: String, key: String, iv: String) -> String? {
        guard let data = Data(hexString: text) else { return nil }
        return crypt(data, operation: CCOperation(kCCDecrypt), key: key, iv: iv).flatMap {
            String(data: $0, encoding: .utf8)
        }
    }

    static func decryptBase64(_ text: String, key: String, iv: String) -> String? {
        guard let data = Data(base64Encoded: text) else { return nil }
        return crypt(data, operation: CCOperation(kCCDecrypt), key: key, iv: iv).flatMap {
            String(data: $0, encoding: .utf8)
        }
    }

    private static func crypt(_ data: Data, operation: CCOperation) -> Data? {
        crypt(data, operation: operation, key: "fog580znqjtgkber", iv: "n70a309m7w4wfmw8")
    }

    private static func crypt(_ data: Data, operation: CCOperation, key: String, iv: String) -> Data? {
        guard key.utf8.count == kCCKeySizeAES128, iv.utf8.count == kCCBlockSizeAES128 else {
            return nil
        }

        let key = Array(key.utf8)
        let iv = Array(iv.utf8)
        var output = Data(count: data.count + kCCBlockSizeAES128)
        let outputCount = output.count
        var outputLength = 0

        let status = output.withUnsafeMutableBytes { outputBytes in
            data.withUnsafeBytes { dataBytes in
                key.withUnsafeBufferPointer { keyBytes in
                    iv.withUnsafeBufferPointer { ivBytes in
                        CCCrypt(
                            operation,
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress,
                            kCCKeySizeAES128,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress,
                            data.count,
                            outputBytes.baseAddress,
                            outputCount,
                            &outputLength
                        )
                    }
                }
            }
        }

        guard status == kCCSuccess else { return nil }
        output.removeSubrange(outputLength..<output.count)
        return output
    }
}

private extension Data {
    init?(hexString: String) {
        guard hexString.count.isMultiple(of: 2) else { return nil }

        var data = Data()
        var index = hexString.startIndex
        while index < hexString.endIndex {
            let next = hexString.index(index, offsetBy: 2)
            guard let byte = UInt8(hexString[index..<next], radix: 16) else { return nil }
            data.append(byte)
            index = next
        }

        self = data
    }

    var hexString: String {
        map { String(format: "%02x", $0) }.joined()
    }
}
