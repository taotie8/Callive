
import UIKit

class CallliveTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarConfig()
        setupUI()
    }
    
    func setupTabbarConfig() {
        tabBar.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        tabBar.itemPositioning = .fill

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]
        itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 100)
        itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 100)

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.stackedItemPositioning = .fill
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    func setupUI() {
        viewControllers = [
            setTabbar(vc: HomeController(), image_n: "tabbar_home_n", image_s: "tabbar_home_s"),
            setTabbar(vc: RoomListsController(), image_n: "tabbar_room_n", image_s: "tabbar_room_s"),
            setTabbar(vc: MessageListsController(), image_n: "tabbar_messages_n", image_s: "tabbar_messages_s"),
            setTabbar(vc: MineController(), image_n: "tabbar_mine_n", image_s: "tabbar_mine_s"),
        ]
        selectedIndex = 0
    }
    
    private func setTabbar(vc: UIViewController, image_n: String, image_s: String) -> UINavigationController {
        let controller = UINavigationController(rootViewController: vc)
        controller.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: image_n)?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: image_s)?.withRenderingMode(.alwaysOriginal)
        )
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return controller
    }
    
}
