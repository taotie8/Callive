
import UIKit

class RoomChatGiftCell: UITableViewCell {

    @IBOutlet weak var user_header: UIImageView!
    @IBOutlet weak var user_name_label: UILabel!
    @IBOutlet weak var send_label: UILabel!
    @IBOutlet weak var gift_icon: UIImageView!
    @IBOutlet weak var count_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func room_cellUpdateViews(model: ChatRoomModel) {
        user_header.cal_setImage("https://app.zhegnidcg.com/file/\(model.avatar)")
        gift_icon.cal_setImage(model.giftImage)
        user_name_label.text = model.nickname
        count_label.text = "\(model.giftCount ?? 1)"
        send_label.text = "Send \(model.giftName ?? "Gift")"
    }
    
}
