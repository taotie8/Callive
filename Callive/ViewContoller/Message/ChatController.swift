
import UIKit
import IQKeyboardManagerSwift
class ChatController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header_image: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var follow_button: UIButton!
    @IBOutlet weak var chat_textfiled: UITextField!
    
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
        header_image.layer.cornerRadius = 16
        header_image.layer.masksToBounds = true
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreAction(_ sender: Any) {
        
    }
    
    @IBAction func followAction(_ sender: UIButton) {
        
    }
    
    @IBAction func bottomSelectAction(_ sender: UIButton) {
        if sender.tag == 1000 {
            
        }
        if sender.tag == 1001 {
            
        }
        if sender.tag == 1002 {
            let vc = VideoCallsController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
