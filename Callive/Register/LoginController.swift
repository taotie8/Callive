
import UIKit

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
        
    }
    
    @IBAction func signup(_ sender: Any) {
        navigationController?.pushViewController(RegisterController(), animated: true)
    }
    
    @IBAction func selectPrivacy(_ sender: UIButton) {
        
    }
}
