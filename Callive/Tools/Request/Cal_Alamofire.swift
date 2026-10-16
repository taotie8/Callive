
import Foundation
import Alamofire

enum NetworkError: Error {
    case unknown(String)
    case requestFailed(Error)
}

class Cal_Alamofire {
    static let shared: Cal_Alamofire = {
        let instance = Cal_Alamofire()
        return instance
    }()
    
    func post<T: Decodable>(urlSuffix: String, body: [String: Any] = [:], completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        
        postData(urlSuffix: urlSuffix, body: body ) { result in

            switch result {
            case .success(let decryptedData):
                do {
                    let model = try JSONDecoder().decode(T.self, from: decryptedData)

                    completionHandler(.success(model))

                } catch {
                    print("模型解析失败：\(error)")
                    print("解密后的数据：",String(data: decryptedData, encoding: .utf8) ?? "")

                    completionHandler(.failure(.unknown("模型解析失败：\(error.localizedDescription)")))
                }

            case .failure(let error):
                completionHandler(.failure(error))
            }
        }

    }
    
    func cal_requestHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Accept": "application/json, text/plain",
            "Content-Type": "application/json;charset=UTF-8",
            "appId": "26737235",
            "X-Handset-Count": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "X-Grove-Edition": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0",
            "X-Entry-Pass": UserDefaults.standard.object(forKey: "login_token") as? String ?? "",
            "X-Sprout-Signal": "", // pushToken
        ]
        return headers
    }
    
    func postData(urlSuffix: String, body: [String: Any] = [:], completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let urlString = "\(cal_base_url)\(urlSuffix)"
        let encryptedData: Data

        do {
            encryptedData = try encryptedBody(from: body)
        } catch let error as NetworkError {
            completion(.failure(error))
            return
        } catch {
            completion(.failure(.unknown(error.localizedDescription)))
            return
        }
        
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.httpBody = encryptedData

        for header in cal_requestHeaders() {
            request.setValue(
                header.value,
                forHTTPHeaderField: header.name
            )
        }
        
        print(cal_requestHeaders())
        print("加密后的body：\(encryptedData)")
        print(body)
        print(urlString)

        AF.request(request).validate().responseData { response in
            switch response.result {
            case .success(let data):

                print(String(data: data, encoding: .utf8) ?? "")
                
                do {
                        let decryptedData = try self.decryptResponseData(data)

                        completion(.success(decryptedData))

                        print(String(data: decryptedData, encoding: .utf8) ?? "")

                    } catch let error as NetworkError {
                        completion(.failure(error))

                    } catch {
                        completion(
                            .failure(
                                .unknown(error.localizedDescription)
                            )
                        )
                    }

            case .failure(let error):
                completion(.failure(.requestFailed(error)))
            }
        }
    }
    
    /// 加密
    private func encryptedBody(
        from body: [String: Any]
    ) throws -> Data {

        guard JSONSerialization.isValidJSONObject(body) else {
            throw NetworkError.unknown("Body 格式无效")
        }

        let jsonData = try JSONSerialization.data(
            withJSONObject: body,
            options: []
        )

        guard let jsonString = String(
            data: jsonData,
            encoding: .utf8
        ) else {
            throw NetworkError.unknown("JSON 转字符串失败")
        }

        guard let encryptedString = AESCoder.encrypt(jsonString),
              let encryptedData = encryptedString.data(using: .utf8) else {
            throw NetworkError.unknown("Body 加密失败")
        }

        return encryptedData
    }
    
    /// 解密
    private func decryptResponseData(_ data: Data) throws -> Data {
        guard let object = try JSONSerialization.jsonObject(
            with: data,
            options: []
        ) as? [String: Any] else {
            throw NetworkError.unknown("返回数据不是 JSON")
        }

        let value = object["result"] ?? object["data"]

        guard let encryptedString = value as? String else {
            throw NetworkError.unknown("没有找到加密字段")
        }

        guard let decryptedString = AESCoder.decrypt(encryptedString),
              let decryptedData = decryptedString.data(using: .utf8) else {
            throw NetworkError.unknown("返回数据解密失败")
        }

        return decryptedData
    }
    
}
