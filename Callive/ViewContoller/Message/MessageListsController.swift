
import UIKit

class MessageListsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var conversations: [CalLocalChatConversation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MessageListsCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        loadConversations()
    }

    private func loadConversations() {
        conversations = CalLocalChatStorage.shared.conversations()
        tableView.reloadData()
    }
}

extension MessageListsController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageListsCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        if indexPath.section == 0 {
            cell.user_header.image = UIImage(named: "system_icon")
            cell.user_name_label.text = "System"
            cell.last_message_label.text = "Welcome to Callive"
        } else {
            cell.message_cellUpdateViews(conversation: conversations[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = MessageSystemController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        let conversation = conversations[indexPath.row]
        let vc = ChatController()
        vc.user_id = conversation.friendId
        vc.user_name = conversation.friendName
        vc.user_avatar = conversation.friendAvatar
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
