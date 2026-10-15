
import UIKit

class MineController: UIViewController {

    @IBOutlet weak var mine_name: UILabel!
    @IBOutlet weak var mine_header: UIImageView!
    @IBOutlet weak var mine_id: UILabel!
    @IBOutlet weak var mine_bio: UILabel!
    @IBOutlet weak var following_label: UILabel!
    @IBOutlet weak var follower_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        mine_header.layer.cornerRadius = 34
        mine_header.layer.masksToBounds = true
    }

    @IBAction func otherAction(_ sender: UIButton) {
        if sender.tag == 1000 {
            
        }
        if sender.tag == 1001 {
            let vc = EditInforController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        if sender.tag == 1002 {
           let vc = MineFollowController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        if sender.tag == 1003 {
            let vc = MineFollowController()
             vc.hidesBottomBarWhenPushed = true
             navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func itemsAction(_ sender: UIButton) {
        if sender.tag == 1000 {
            
        }
        if sender.tag == 1001 {
            
        }
        if sender.tag == 1002 {
            
        }
        if sender.tag == 1003 {
            let deleteView = UINib(nibName: "DeleteView", bundle: nil).instantiate(withOwner: self, options: nil).first as! DeleteView
            deleteView.showDeleteView()
        }
        if sender.tag == 1004 {
            let deleteView = UINib(nibName: "DeleteView", bundle: nil).instantiate(withOwner: self, options: nil).first as! DeleteView
            deleteView.showDeleteView()
        }
    }
    
}
