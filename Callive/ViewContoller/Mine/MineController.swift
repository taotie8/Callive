
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
        updateMineProfile()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMineInformation), name: Notification.Name("updateMineInformationNotification"), object: nil)
    }
    
    func updateMineProfile() {
        if let model = CalLoginStorage.shared.mineInfo {
            mine_name.text = model.nickname
            mine_header.cal_setImage(model.petalMark)
            mine_id.text = "ID \(model.forestGuest)"
            mine_bio.text = model.leafSeal
            following_label.text = "\(model.sproutCount)"
            follower_label.text = "\(model.guestTally)"
        }
    }
    
    @objc func updateMineInformation() {
        requestMineInformation {
            self.updateMineProfile()
        }
    }

    @IBAction func otherAction(_ sender: UIButton) {
        if sender.tag == 1000 {
            cal_pasteString(text: "\(mine_id.text ?? "")")
        }
        if sender.tag == 1001 {
            let vc = EditInforController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        if sender.tag == 1002 {
           let vc = MineFollowController()
            vc.classType = .follow
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        if sender.tag == 1003 {
            let vc = MineFollowController()
            vc.classType = .fans
             vc.hidesBottomBarWhenPushed = true
             navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func itemsAction(_ sender: UIButton) {
        if sender.tag == 1000 {
            let vc = MineFollowController()
            vc.classType = .block
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        if sender.tag == 1001 {
            let vc = UserAgreementController()
            vc.hidesBottomBarWhenPushed = true
            vc.pageTitle = "Privacy Policy"
            vc.urlString = cal_privacy_url
            navigationController?.pushViewController(vc, animated: true)
        }
        if sender.tag == 1002 {
            let vc = UserAgreementController()
            vc.hidesBottomBarWhenPushed = true
            vc.pageTitle = "User Agreement"
            vc.urlString = cal_useragreement_url
            navigationController?.pushViewController(vc, animated: true)
        }
        if sender.tag == 1003 {
            let deleteView = UINib(nibName: "DeleteView", bundle: nil).instantiate(withOwner: self, options: nil).first as! DeleteView
            deleteView.showDeleteView()
        }
        if sender.tag == 1004 {
            let deleteView = UINib(nibName: "DeleteView", bundle: nil).instantiate(withOwner: self, options: nil).first as! DeleteView
            deleteView.delete_button.setTitle("Log Out", for: .normal)
            deleteView.delete_content.text = "Are you sure you want to Log Out"
            deleteView.delete_title.text = "Log Out"
            deleteView.showDeleteView()
        }
    }
    
}
