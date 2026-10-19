
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
    
    func moment_cellUpdateViews(model: SunriseScene) {
        cell_user_header.cal_setImage(model.petalMark)
        cell_user_name.text = model.nickname
        cell_moment_label.text = model.meadowScript
        cell_pic_image.cal_setImage(model.images.count > 0 ? model.images.first : "")
        cell_time_label.text = model.sunriseMoment
        cell_love_label.text = "\(model.seedTally)"
        cell_love_button.isSelected = model.blossomSignal == 1 ? true : false
    }
    
}
