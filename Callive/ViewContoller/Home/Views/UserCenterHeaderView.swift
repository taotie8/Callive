
import UIKit

class UserCenterHeaderView: UIView {

    @IBOutlet weak var user_header_image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        user_header_image.layer.cornerRadius = 36
        user_header_image.layer.masksToBounds = true
        user_header_image.layer.borderWidth = 2
        user_header_image.layer.borderColor = UIColor.white.cgColor
    }

}
