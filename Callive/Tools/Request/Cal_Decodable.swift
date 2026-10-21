
import Foundation
import ZKProgressHUD

struct Cal_Codable: Codable {
    let message: String
    let code: Int
    let result: String?
}

struct LoginResponse: Codable {
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

/// 配置信息
struct GrovePlanUnfoldResponse: Decodable {
    let orchardMap: String
    let gardenIntent: Int           // 1=审核检测通过(真实形态) / 0=审核形态
    let gardenScheme: GardenScheme
}

struct GardenScheme: Decodable {
    let staticBaseUrl: String
    let orchardOrigin: String       //
    let bulletinKeeper: String
    let gardenRelay: String
    let groveChannel: String
    let groveClient: String
    let branchCipher: String
    let leafVector: String
}


/// 首页全部数据
struct HomeAllResponse: Decodable {
    let meadowLines: [MeadowLine]
}

struct MeadowLine: Decodable {
    let meadowLand: String      // 国家
    let petalForm: Int          // 性别
    let village: String         // 城市
    let villageCount: Int       // 人数
    let petalMark: String       // 头像地址
    let groveChamber: String    //
    let groveBadge: String      // 国家 ID
    let nickname: String        // 昵称
    let visitSignal: Int        // 是否关注 1是/0否
    let groveKey: String        // 房间数据 ID
    let tag: [String]           // 标签 ID
    let groveElite: Int         // VIP
    let tierLabel: String       // 主播级别名
    let guestTally: Int         // 粉丝人数
    let meadowRank: Int         // 主播级别 id
    let meadowHandle: String    // 云信 accid
    let liveroomstate: Int
    let orchardRank: String     // 等级名
    let gardenSignal: Int       // 组状态 1:在线/2:忙碌/3:不在线
    let forestGuest: Int64      // 用户 id
    let groveJoined: Int        // 是否关注
    let hearthToken: Int        // party 房 id
    let gardenRate: Int         // 视频通话价格/分钟
    let dailyTitle: String      // 用户名
    let meadowSignal: String    // 签名
    let seasons: Int            // 年龄
}

/// 首页Video列表
struct MeadowLinesResponse: Decodable {
    let meadowLines: [MeadowLineItem] // 草地/用户列表
}

struct MeadowLineItem: Decodable {
    let tierLabel: String?      // 等级名称
    let thornToken: Int?        // 荆棘令牌数量
    let willowNook: String?     // 房间标识
    let orchardHealth: Int?     // 房间健康值
    let gatheringKey: String?   // 聊天室或频道标识
    let villageCount: Int?      // 房间人数
    let meadowHandle: String?   // 用户标识
    let petalMark: String?      // 用户头像地址
    let onlineUsers: [String]?  // 在线用户列表
    let gardenLabel: String?    // 房间名称
    let gardenSignal: Int?      // 房间状态
    let forestGuest: Int64     // 用户 ID
    let nebulaBackdrop: String? // 房间背景图
    let groveBadge: String?     // 用户徽章
    let gardenStory: String?    // 房间简介或动态描述
    let videoUrl: String?       // 视频地址
    let meadowQuiet: Int?       // 静音状态
    let nickname: String?       // 用户昵称
    let visitSignal: Int?       // 关注状态
    let groveKey: Int64?        // 数据唯一 ID
    let meadowSignal: Int?      // 用户状态
    let seasons: Int?           // 用户等级或成长值
    let meadowImage: String?    // 房间封面图
}

/// 用户详情
struct MeadowHostResponse: Decodable {
    let sunriseScenes: [SunriseScene]   // 主播朋友圈动态列表
    let orchardView: UserDetailModel        //用户详情
}

/// 用户动态
struct SunriseScene: Decodable {
    let images: [String]           // 图片名称列表
    let petalForm: Int              // 性别
    let blossomLinks: [String]     // 图片地址列表
    let sparkTally: Int             // 互动数量
    let meadowRank: Int             // 用户等级
    let petalMark: String           // 用户头像地址
    let sparkMarker: Int            // 动态状态标识
    let meadowScript: String        // 动态文本内容
    let forestGuest: Int64          // 用户 ID
    var seedTally: Int              // 点赞数量
    let replyCount: Int             // 评论数量
    let createdAt: Int64            // 创建时间戳，毫秒
    let forestCrown: Int            // 是否置顶
    let videoUrl: String            // 视频地址
    let sunriseMoment: String       // 发布时间
    let sproutBundle: String        // 动态扩展内容
    var blossomSignal: Int          // 是否点赞：1是，0否
    let nickname: String            // 用户昵称
    let visitSignal: Int            // 是否关注：1是，0否
    let groveKey: Int64             // 动态 ID
    let signalTally: Int            // 其他互动数量
}

///用户详细资料
struct UserDetailModel: Decodable {

    let sunriseDay: String          // 生日，ISO8601 时间字符串
    let groveMarker: Int            // 直播状态：1直播中，0未直播
    let guestTally: Int             // 粉丝数量
    let petalForm: Int              // 性别
    let meadowRank: Int             // 用户等级 ID
    let leafSeal: String            // 用户签名
    let gardenCount: Int            // 好友数量
    let meadowHandle: String        // 云信账号 ID
    let petalMark: String           // 头像地址
    let groveChamber: Int64         // 直播间房间 ID
    let sproutCount: Int            // 关注数量
    let thornSealed: Int            // 是否被拉黑：0否，1是
    let gardenNotes: String         // 个人简介
    let orchardRank: String         // 等级名称
    let forestGuest: Int64          // 用户 ID
    let groveBadge: String          // 国家 ID
    let blossomPoints: Int          // 用户评分
    let sproutReach: Int            // 是否可以拨打：1可以，0不可以
    let gardenRate: Int             // 视频通话价格，每分钟
    let nickname: String            // 用户昵称
    let visitSignal: Int            // 是否关注：1是，0否
    let groveElite: Int             // VIP 状态：1是，0否
    let seasons: Int                // 年龄
    let gardenFlag: Int             // 用户状态：1在线，10000忙碌，3离线
}













/// 我的资料
func requestMineInformation() {
    Cal_Alamofire.shared.postData(urlSuffix: cal_mine_info) { result in
        ZKProgressHUD.dismiss()
        switch result {
        case .success(let data):
            print(String(data: data, encoding: .utf8) ?? "")

        case .failure(let error):
            print(error)
        }
    }
}

/**
 
 {"sunriseDay":"1997-03-17T07:26:22.410Z",
 "itemSmallImg":"lopez.png",
 "guestTally":0
 ,"petalForm":2,
 "leafSeal":"",
 "gardenCount":0,
 "meadowHandle":"",
 "petalMark":"lopez.png",
 "sproutCount":3,
 "forestGuest":10001,
 "gem":0,
 "groveBadge":"US",
 "elderDeadline":0,
 "gardenStanding":10,
 "seedCount":0,
 "forestTier":10,
 "gardenPass":"im_token_10001",
 "nickname":"Lopez",
 "groveElite":0,
 "groveEmblem":""}

 
 */


/// 更新token
func updateUserToken(completion: @escaping () -> Void) {
    var body = [String: String]()
    if let loginInfo = CalLoginStorage.shared.loginInfo {
        body["refreshToken"] = loginInfo.forestPass
    }
    Cal_Alamofire.shared.post(urlSuffix: cal_user_token, body: body) { (result: Result<LoginResponse, NetworkError>) in
        switch result {
        case .success(let response):
            CalLoginStorage.shared.save(response)
            completion()
        case .failure(let error):
            print(error)
        }
    }
}

/// 更新关注、取消关注、拉黑
func updateUserFollowStatus(userId: Int64, follow_type: Int, completion: @escaping () -> Void) {
    ZKProgressHUD.show()
    Cal_Alamofire.shared.postData(urlSuffix: cal_user_guest, body: ["followUserId": userId, "followType": follow_type]) { result in
        ZKProgressHUD.dismiss()
        switch result {
        case .success(_):
            completion()
        case .failure(let error):
            print(error)
        }
    }
}


//Cal_Alamofire.shared.postData(urlSuffix: cal_home_all) { result in
//    ZKProgressHUD.dismiss()
//    switch result {
//    case .success(let data):
//        print(String(data: data, encoding: .utf8) ?? "")
//
//    case .failure(let error):
//        print(error)
//    }
//}
