
import UIKit
import IQKeyboardManagerSwift

class ChatRoomController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.isEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func dissmisAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
