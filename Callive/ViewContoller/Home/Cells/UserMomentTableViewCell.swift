
import UIKit

class UserMomentTableViewCell: UITableViewCell {

    @IBOutlet weak var cell_user_header: UIImageView!
    @IBOutlet weak var cell_user_name: UILabel!
    @IBOutlet weak var cell_moment_label: UILabel!
    @IBOutlet weak var cell_pic_image: UIImageView!
    @IBOutlet weak var cell_time_label: UILabel!
    @IBOutlet weak var cell_love_label: UILabel!
    @IBOutlet weak var cell_love_button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        cell_user_header.layer.cornerRadius = 16
        cell_pic_image.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
