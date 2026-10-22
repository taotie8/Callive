
import UIKit

class GiftGivingCell: UICollectionViewCell {

    @IBOutlet weak var gift_icon: UIImageView!
    @IBOutlet weak var select_color: UIImageView!
    @IBOutlet weak var gift_name: UILabel!
    @IBOutlet weak var count_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        select_color.layer.cornerRadius = 8
        select_color.layer.masksToBounds = true
    }

}
