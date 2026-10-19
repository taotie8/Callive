
import UIKit
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        window = UIWindow(frame: UIScreen.main.bounds)
//        if UserDefaults.standard.object(forKey: "login_token") as? String != nil {
            window?.rootViewController = CallliveTabBarController()
//        }else {
//            window?.rootViewController = UINavigationController(rootViewController: LoginController())
//        }
        window?.makeKeyAndVisible()
        return true
    }
}

extension UIApplication {
    var cal_window: UIWindow? {
        return connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
    }
}
