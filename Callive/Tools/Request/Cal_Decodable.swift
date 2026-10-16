
import Foundation

struct Cal_Codable: Codable {
    let message: String
    let code: Int
    let result: String?
}

struct LoginResponse: Decodable {
    let welcomePass: String        //登陆token
    let seasonWindow: Int?      //token 有效秒数
    let harvestShare: Int?      //balance
    let seedArchive: String?    // 老 weidou t_user_token,/sapi BagShop 交换 auth_token 用,仅登录下发
    let gardenPass: String?     // IM(云信) token
    let meadowHandle: String?   // 云信账号 ID
    let groveSeal: String?      // 令牌类型(Bearer)
    let forestGuest: Int?    // 用户 ID
    let forestPass: String?     // 刷新令牌
    let dawnBoundary: Int?   // refreshToken 有效秒数
}
