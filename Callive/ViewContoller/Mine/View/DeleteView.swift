
import UIKit
import ZKProgressHUD
class DeleteView: UIView {

    @IBOutlet weak var delete_title: UILabel!
    @IBOutlet weak var delete_content: UILabel!
    @IBOutlet weak var delete_button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func showDeleteView() {
        UIApplication.shared.cal_window?.addSubview(self)
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.alpha = 1.0
        UIView.animate(withDuration: 0.28) {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }

    func hiddenDeleteView() {
        UIView.animate(withDuration: 0.28) {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } completion: { _ in
            self.alpha = 0.0
            UIApplication.shared.cal_window?.removeFromSuperview()
        }
    }
    
    @IBAction func deleteAction() {
        hiddenDeleteView()
        ZKProgressHUD.show()
        UserDefaults.standard.removeObject(forKey: "login_token")
        UserDefaults.standard.synchronize()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ZKProgressHUD.dismiss()
            UIApplication.shared.cal_window?.rootViewController = LoginController()
        }
    }
    
    @IBAction func cancelAction() {
        hiddenDeleteView()
    }
    
}
