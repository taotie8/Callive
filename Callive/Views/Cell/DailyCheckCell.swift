
import UIKit

class DailyCheckCell: UICollectionViewCell {

    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var check_icon: UIImageView!
    @IBOutlet weak var check_coins_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .hex("#E8FBFF")
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }

}
