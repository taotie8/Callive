

import UIKit

class HomeControllerCell: UICollectionViewCell {

    @IBOutlet weak var cell_cover_image: UIImageView!
    @IBOutlet weak var cell_user_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func home_cellUpdateViews(model: MeadowLine) {
        cell_cover_image.cal_setImage(model.petalMark, placeholder: UIImage(named: "cal_header"))
        cell_user_name.text = model.dailyTitle
    }

}
