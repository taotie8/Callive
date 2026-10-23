
import UIKit
import ZKProgressHUD

class ToolsReportView: UIView {
    var cal_self = UIViewController()
    var user_id: Int64 = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func closeAction(_ sender: Any) {
        hiddenToolsReportView()
    }
    
    @IBAction func toolsReportAndBlockAction(_ sender: UIButton) {
        if sender.tag == 1000 {
            let vc = ToolsReportController()
            vc.userId = user_id
            vc.hidesBottomBarWhenPushed = true
            if (cal_self.navigationController != nil) {
                cal_self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                vc.modalPresentationStyle = .fullScreen
                cal_self.present(vc, animated: true)
            }
            hiddenToolsReportView()
        }
        else {
            ZKProgressHUD.show()
            Cal_Alamofire.shared.postData(urlSuffix: cal_user_guest, body: ["followUserId": user_id, "followType": 3]) { result in
                ZKProgressHUD.dismiss()
                switch result {
                case .success(_):
                    ZKProgressHUD.showSuccess()
                    if (self.cal_self.navigationController != nil) {
                        self.cal_self.navigationController?.popViewController(animated: true)
                        
                        guard let navigationController = self.cal_self.navigationController else { return }
                        for vc in navigationController.viewControllers {
                            if vc is HomeController {
                                navigationController.popToViewController(vc, animated: true)
                                break
                            }
                            if vc is MineController {
                                navigationController.popToViewController(vc, animated: true)
                                break
                            }
                            if vc is MessageListsController {
                                navigationController.popToViewController(vc, animated: true)
                                break
                            }
                        }
                        
                    }
                    else {
                        self.cal_self.dismiss(animated: true, completion: nil)
                    }
                    self.hiddenToolsReportView()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
    @IBAction func tapBgimageViewAction(_ sender: Any) {
        hiddenToolsReportView()
    }
    
    
    func showToolsReportView() {
        UIApplication.shared.cal_window?.addSubview(self)
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.alpha = 1.0
        UIView.animate(withDuration: 0.28) {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }

    func hiddenToolsReportView() {
        UIView.animate(withDuration: 0.28) {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } completion: { _ in
            self.alpha = 0.0
            UIApplication.shared.cal_window?.removeFromSuperview()
        }
    }
}
