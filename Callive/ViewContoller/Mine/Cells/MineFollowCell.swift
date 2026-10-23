
import UIKit

class MineFollowCell: UITableViewCell {

    @IBOutlet weak var cell_user_header: UIImageView!
    @IBOutlet weak var cell_label: UILabel!
    @IBOutlet weak var cell_button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func black_cellUpdateViews(model: BlacklistUser) {
        cell_user_header.cal_setImage(model.petalMark)
        cell_label.text = model.nickname
    }
    
}
