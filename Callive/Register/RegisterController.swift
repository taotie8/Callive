
import UIKit

class RegisterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
