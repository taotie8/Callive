

import UIKit

class HomeControllerCell: UICollectionViewCell {

    @IBOutlet weak var cell_cover_image: UIImageView!
    @IBOutlet weak var cell_user_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }

}
