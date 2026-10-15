
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

        // Configure the view for the selected state
    }
    
}
