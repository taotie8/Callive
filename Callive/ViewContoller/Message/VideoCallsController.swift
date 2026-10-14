
import UIKit

class VideoCallsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func callingWndAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
