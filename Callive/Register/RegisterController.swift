
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
