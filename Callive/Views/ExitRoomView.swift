
import UIKit
import ZKProgressHUD

class ExitRoomView: UIView {
    var cal_navigation = UINavigationController()
    var user_id: Int64 = 0
    var follow_status = 0
    @IBOutlet weak var follow_button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func closeAction(_ sender: Any) {
        hiddenExitRoomView()
    }
    
    @IBAction func exitRoomAction(_ sender: Any) {
        hiddenExitRoomView()
        cal_navigation.popViewController(animated: true)
    }
    
    @IBAction func followAction(_ sender: Any) {
        follow_button.setTitle("Followed", for: .normal)
        var body = ["followUserId": user_id, "followType": 1]
        if follow_button.isSelected == true {
            body = ["followUserId": user_id, "followType": 2]
        }
        else {
            body = ["followUserId": user_id, "followType": 1]
        }
        
        ZKProgressHUD.show()
        Cal_Alamofire.shared.postData(urlSuffix: cal_user_guest, body: body) { result in
            ZKProgressHUD.dismiss()
            switch result {
            case .success(_):
                self.follow_button.isSelected = !self.follow_button.isSelected
                self.follow_button.setTitle(self.follow_button.isSelected == true ? "Followed" : "Follow", for: .normal)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showExitRoomView() {
        UIApplication.shared.cal_window?.addSubview(self)
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.alpha = 1.0
        UIView.animate(withDuration: 0.28) {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }

    func hiddenExitRoomView() {
        UIView.animate(withDuration: 0.28) {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } completion: { _ in
            self.alpha = 0.0
            UIApplication.shared.cal_window?.removeFromSuperview()
        }
    }

}
