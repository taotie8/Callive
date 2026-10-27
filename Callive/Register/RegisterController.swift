
import UIKit

class RegisterController: UIViewController {

    @IBOutlet weak var privacy_tap: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectPrivacy(_ sender: UIButton) {
        if sender.tag == 1001 {
            let vc = UserAgreementController()
            vc.hidesBottomBarWhenPushed = true
            vc.pageTitle = "User Agreement"
            vc.urlString = cal_useragreement_url
            navigationController?.pushViewController(vc, animated: true)
        }
        else if sender.tag == 1002 {
            let vc = UserAgreementController()
            vc.hidesBottomBarWhenPushed = true
            vc.pageTitle = "Privacy Policy"
            vc.urlString = cal_privacy_url
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            privacy_tap.isSelected = !privacy_tap.isSelected
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
    }
    
    
}
