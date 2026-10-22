
import UIKit

class RoomChatCell: UITableViewCell {

    @IBOutlet weak var user_header: UIImageView!
    @IBOutlet weak var user_name_label: UILabel!
    @IBOutlet weak var content_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func room_cellUpdateViews(model: ChatRoomModel) {
        user_header.cal_setImage("https://app.zhegnidcg.com/file/\(model.avatar)")
        user_name_label.text = model.nickname
        content_label.text = model.content
    }
    
}
