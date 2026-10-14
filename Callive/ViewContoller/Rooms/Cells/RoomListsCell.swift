
import UIKit

class RoomListsCell: UITableViewCell {

    @IBOutlet weak var cell_bgView: UIView!
    @IBOutlet weak var cell_room_header: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cell_bgView.layer.cornerRadius = 12
        cell_bgView.layer.masksToBounds = true
        cell_bgView.layer.borderWidth = 2
        cell_bgView.layer.borderColor = UIColor.hex("#DDA6FF", alpha: 1.0).cgColor
        
        cell_room_header.layer.cornerRadius = 20
        cell_room_header.layer.masksToBounds = true
        cell_room_header.layer.borderWidth = 2
        cell_room_header.layer.borderColor = UIColor.hex("#00FFEE").cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
