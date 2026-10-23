
import UIKit

class FriendsChatCell: UITableViewCell {

    @IBOutlet weak var user_header: UIImageView!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var chat_content_label: UILabel!

    func chat_cellUpdateViews(message: CalLocalChatMessage) {
        time_label.text = Self.timeFormatter.string(from: message.createdAt)
        chat_content_label.text = message.content

        if message.senderAvatar.hasPrefix("http") {
            user_header.cal_setImage(message.senderAvatar, placeholder: UIImage(named: "cal_header"))
        } else {
            user_header.image = UIImage(named: message.senderAvatar) ?? UIImage(named: "cal_header")
        }
    }

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        user_header.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
