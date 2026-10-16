
import UIKit
import ZKProgressHUD

class LoginController: UIViewController {

    @IBOutlet weak var email_text: UITextField!
    @IBOutlet weak var pass_text: UITextField!
    @IBOutlet weak var privacy_tap: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if check_validEmail(email_text.text!) {
            ZKProgressHUD.showError("Please enter a valid email address.")
            return
        }
        
        if check_stringNull(pass_text.text) {
            ZKProgressHUD.showError("Password cannot be empty.")
            return
        }
        
        
//        Cal_Alamofire.shared.postData(urlSuffix: cal_login_api, body: ["deviceNo": UIDevice.current.identifierForVendor?.uuidString ?? ""]) { result in
//            ZKProgressHUD.dismiss()
//            switch result {
//            case .success(let data):
//                print(String(data: data, encoding: .utf8) ?? "")
//
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        ZKProgressHUD.show()
        Cal_Alamofire.shared.post(urlSuffix: cal_login_api, body: ["deviceNo": UIDevice.current.identifierForVendor?.uuidString ?? ""]) { (result: Result<LoginResponse, NetworkError>) in
            ZKProgressHUD.dismiss()
            switch result {
            case .success(let response):
                print(response.welcomePass)
                UserDefaults.standard.setValue(response.welcomePass, forKey: "login_token")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        navigationController?.pushViewController(RegisterController(), animated: true)
    }
    
    @IBAction func selectPrivacy(_ sender: UIButton) {
        if sender.tag == 1001 {
            
        }
        else if sender.tag == 1002 {
            
        }
        else {
            privacy_tap.isSelected = !privacy_tap.isSelected
        }
    }
}
