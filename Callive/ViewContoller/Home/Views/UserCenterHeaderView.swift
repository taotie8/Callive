
import UIKit
import ZKProgressHUD

class UserCenterHeaderView: UIView {

    @IBOutlet weak var user_header_image: UIImageView!
    @IBOutlet weak var user_name_label: UILabel!
    @IBOutlet weak var user_id_label: UILabel!
    @IBOutlet weak var user_sign_label: UILabel!
    @IBOutlet weak var user_following_label: UILabel!
    @IBOutlet weak var user_followers_label: UILabel!
    @IBOutlet weak var user_follow_button: UIButton!
    
    var user_id: Int64 = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        user_header_image.layer.cornerRadius = 36
        user_header_image.layer.masksToBounds = true
        user_header_image.layer.borderWidth = 2
        user_header_image.layer.borderColor = UIColor.white.cgColor
    }
    
    func updateUserInformation(model: UserDetailModel) {
        user_id = model.forestGuest
        user_header_image.cal_setImage(model.petalMark)
        user_name_label.text = model.nickname
        user_sign_label.text = model.gardenNotes.isEmpty ? "Still thinking of a bio. Let’s keep it mysterious for now." : model.gardenNotes
        user_id_label.text = "ID \(model.forestGuest)"
        user_following_label.text = "\(model.sproutCount)"
        user_followers_label.text = "\(model.guestTally)"
        user_follow_button.setImage(UIImage(named: model.visitSignal == 1 ? "user_follow" : "user_unfollow"), for: .normal)
        user_follow_button.isSelected = model.visitSignal == 1 ? true : false
    }
    
    @IBAction func followStatusAction(_ sender: UIButton) {
        if user_follow_button.isSelected == true {
            updateUserFollowStatus(userId: user_id, follow_type: 2) { [weak self] in
                self?.user_follow_button.isSelected = false
                self?.user_follow_button.setImage(UIImage(named: "user_unfollow"), for: .normal)
            }
        }
        else {
            updateUserFollowStatus(userId: user_id, follow_type: 1) { [weak self] in
                self?.user_follow_button.isSelected = true
                self?.user_follow_button.setImage(UIImage(named: "user_follow"), for: .normal)
            }
        }
    }
    
    @IBAction func pasteUserIdAction(_ sender: Any) {
        cal_pasteString(text: "\(user_id)")
    }
    
    
    
}
