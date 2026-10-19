
import Foundation
import ZKProgressHUD

func check_stringNull(_ text: String?) -> Bool {
    text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != false
}

func check_validEmail(_ email: String) -> Bool {
    let str = email.trimmingCharacters(in: .whitespacesAndNewlines)
    let type = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return str.range(
        of: type,
        options: .regularExpression
    ) != nil
}

/// Copy
func cal_pasteString(text: String) {
    guard text.count > 0 else {
        return
    }

    UIPasteboard.general.string = "\(text)"
    ZKProgressHUD.showSuccess("Copy Successfully")
}


final class CalLoginStorage {

    static let shared = CalLoginStorage()
    private init() {}

    private let storageKey = "cal_login_info"
    private let loginExpireTimestampKey = "loginExpireTimestamp"
    
    var loginInfo: LoginResponse? {
        guard let data = UserDefaults.standard.data(forKey: storageKey ) else {
            print("没有找到登录缓存")
            return nil
        }
        do {
            return try JSONDecoder().decode(LoginResponse.self, from: data)
        } catch {
            print("登录缓存解码失败：\(error)")
            print("缓存内容：", String(data: data, encoding: .utf8) ?? "")
            return nil
        }
    }

    var isLogin: Bool {
        return loginInfo != nil
    }

    func save(_ loginInfo: LoginResponse) {
        do {
            let data = try JSONEncoder().encode(loginInfo)
            UserDefaults.standard.set(data, forKey: storageKey)
            saveLoginTime(seasonWindow: loginInfo.seasonWindow ?? 0)
        } catch {
            print("登录信息保存失败：\(error)")
        }
    }
    
    func saveLoginTime(seasonWindow: Int) {
        let expireTimestamp =
            Date().timeIntervalSince1970 + Double(seasonWindow)

        UserDefaults.standard.set(
            expireTimestamp,
            forKey: loginExpireTimestampKey
        )
    }
    
    func needRefreshToken() -> Bool {
        let expireTimestamp = UserDefaults.standard.double(
            forKey: loginExpireTimestampKey
        )

        let currentTimestamp = Date().timeIntervalSince1970
        let remainingTime = expireTimestamp - currentTimestamp

        return remainingTime <= 60
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
