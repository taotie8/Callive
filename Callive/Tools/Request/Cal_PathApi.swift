
import Foundation

let cal_base_url = "https://app.zhegnidcg.com"      // 域名
let cal_privacy_url = "https://www.baidu.com"
let cal_useragreement_url = "https://www.baidu.com"

/// 登陆模块
let cal_login_api = "/api/garden/handset/entry"         // 登录
let cal_email_api = "/api/grove/letter/arrival"         // 邮箱登陆
let cal_user_token = "/api/river/seed/replenish"        // 更新token
let cal_app_config = "/api/grove/plan/unfold"           // app启动时，获取信息


/// 首页模块
let cal_home_all = "/api/garden/host/presence"          // 首页all接口
let cal_follow_list = "/api/v3/guest/companions/awake"       // 关注中在线主播(消息页直播栏)
let cal_video_list = "/api/r2/leaf/collection"          // 视频列表
let cal_search_list = "/api/r2/leaf/trail"              // 搜索列表


/// 用户模块
let cal_user_info = "/api/meadow/host/portrait"     // 用户详情
let cal_user_guest = "/api/v3/guest/companion/connect"   // 关注/取消关注/拉黑
let cal_moment_like = "/api/v3/daybook/heart"       // 点赞动态
let cal_feedback = "/api/r2/echo/keep"              // 举报、意见反馈提交



/// 语音房模块
let cal_room_list = "/roomlist/v3/jurassic2/scout/mural-cka"          // 语音房列表
let cal_gift_list = "/api/r2/leaf/treasure/index"         // 礼物列表

/// 我的模块
let cal_mine_info = "/api/v3/guest/story"           // 我的资料
let cal_update_info = "/api/v3/guest/refresh"       // 更新资料
let cal_block_list = "/api/v3/guest/fence/catalog"  // 黑名单列表
let cal_fans_list = "/api/v3/guest/circles"       // 关注、粉丝列表
let cal_sgin_detail = "/api/hearth/arrival/portrait"    // 签到详情
let cal_sgin_success = "/api/garden/arrival/mark"       // 发起签到
