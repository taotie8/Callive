
import UIKit
import ZKProgressHUD

class LoginController: UIViewController {

    @IBOutlet weak var email_text: UITextField!
    @IBOutlet weak var pass_text: UITextField!
    @IBOutlet weak var privacy_tap: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        email_text.text = "lopez@gmail.com"
//        pass_text.text = "1234qwer"
        
        email_text.text = "alexm4827@gmail.com"
        pass_text.text = "123456"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func login(_ sender: Any) {
        if privacy_tap.isSelected == false {
            ZKProgressHUD.showError("Please read and agree to the agreement.")
            return
        }
        
        if check_stringNull(email_text.text) {
            ZKProgressHUD.showError("Email cannot be empty.")
            return
        }
        
        if check_validEmail(email_text.text!) == false {
            ZKProgressHUD.showError("Please enter a valid email address.")
            return
        }
        
        if check_stringNull(pass_text.text) {
            ZKProgressHUD.showError("Password cannot be empty.")
            return
        }
        
        ZKProgressHUD.show()
        Cal_Alamofire.shared.post(urlSuffix: cal_email_api, body: ["guestLetter": email_text.text!, "grovePass": pass_text.text!]) { (result: Result<LoginResponse, NetworkError>) in
            ZKProgressHUD.dismiss()
            switch result {
            case .success(let response):
                UserDefaults.standard.setValue(response.welcomePass, forKey: "login_token")
                CalLoginStorage.shared.save(response)
                
                UIApplication.shared.cal_window?.rootViewController = CallliveTabBarController()
                
            case .failure(let error):
                print(error)
            }
        }
        
//        ZKProgressHUD.show()
//        Cal_Alamofire.shared.post(urlSuffix: cal_login_api, body: ["deviceNo": UIDevice.current.identifierForVendor?.uuidString ?? ""]) { (result: Result<LoginResponse, NetworkError>) in
//            ZKProgressHUD.dismiss()
//            switch result {
//            case .success(let response):
//                UserDefaults.standard.setValue(response.welcomePass, forKey: "login_token")
//                CalLoginStorage.shared.save(response)
//                
//                UIApplication.shared.cal_window?.rootViewController = CallliveTabBarController()
//                
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    @IBAction func signup(_ sender: Any) {
        navigationController?.pushViewController(RegisterController(), animated: true)
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
}
