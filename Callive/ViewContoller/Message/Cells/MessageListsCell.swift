
import UIKit

class MessageListsCell: UITableViewCell {

    @IBOutlet weak var user_header: UIImageView!
    @IBOutlet weak var user_name_label: UILabel!
    @IBOutlet weak var last_message_label: UILabel!

    func message_cellUpdateViews(conversation: CalLocalChatConversation) {
        user_name_label.text = conversation.friendName
        last_message_label.text = conversation.lastMessage

        if conversation.friendAvatar.hasPrefix("http") {
            user_header.cal_setImage(
                conversation.friendAvatar,
                placeholder: UIImage(named: "cal_header")
            )
        } else {
            user_header.image = UIImage(named: conversation.friendAvatar)
                ?? UIImage(named: "cal_header")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        user_header.layer.cornerRadius = 26
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
