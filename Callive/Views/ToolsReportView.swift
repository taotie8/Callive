
import UIKit
import ZKProgressHUD

class ToolsReportView: UIView {
    var cal_navigation = UINavigationController()
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
            cal_navigation.pushViewController(vc, animated: true)
            hiddenToolsReportView()
        }
        else {
            ZKProgressHUD.show()
            Cal_Alamofire.shared.postData(urlSuffix: cal_user_guest, body: ["followUserId": user_id, "followType": 3]) { result in
                ZKProgressHUD.dismiss()
                switch result {
                case .success(_):
                    ZKProgressHUD.showSuccess()
                    self.cal_navigation.navigationController?.popViewController(animated: true)
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
