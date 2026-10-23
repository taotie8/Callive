
import UIKit
import IQKeyboardManagerSwift
class ChatController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header_image: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var follow_button: UIButton!
    @IBOutlet weak var chat_textfiled: UITextField!
    @IBOutlet weak var input_bottom_layout: NSLayoutConstraint!
    
    var user_id: Int64 = 0
    var user_name: String = ""
    var user_avatar: String = ""
    var isfollow: Int = 0
    private var cal_keyboard: Cal_KeyboardManager!
    private var messages: [CalLocalChatMessage] = []
    private var chatTipsView: ChatTipsView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = false
        loadMessages()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cal_keyboard = Cal_KeyboardManager(targetView: view, bottomConstraint: input_bottom_layout, adjustment: -80, hiddenConstant: 0)
        
        header_image.layer.cornerRadius = 16
        header_image.layer.masksToBounds = true
        
        follow_button.isSelected = isfollow == 1 ? true : false
        header_image.cal_setImage(user_avatar)
        name_label.text = user_name
        chat_textfiled.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FriendsChatCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    private func loadMessages() {
        messages = CalLocalChatStorage.shared.messages(for: user_id)
        tableView.reloadData()
        scrollToBottom(animated: false)
    }

    func showChatTipsView() {
        guard chatTipsView == nil,
              let tipsView = Bundle.main.loadNibNamed(
                "ChatTipsView",
                owner: nil,
                options: nil
              )?.first as? ChatTipsView else {
            return
        }

        chatTipsView = tipsView
        tipsView.onClose = { [weak self] in
            self?.chatTipsView = nil
        }
        tipsView.show(in: view)
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreAction(_ sender: Any) {
        let toolsView = Bundle.main.loadNibNamed("ToolsReportView", owner: nil, options: nil)?.first as! ToolsReportView
        toolsView.user_id = user_id
        toolsView.cal_self = self
        toolsView.showToolsReportView()
    }
    
    @IBAction func followAction(_ sender: UIButton) {
        if follow_button.isSelected == true {
            updateUserFollowStatus(userId: user_id, follow_type: 2) { [weak self] in
                self?.follow_button.isSelected = false
                self?.follow_button.setImage(UIImage(named: "cal_chat_unfollow"), for: .normal)
            }
        }
        else {
            updateUserFollowStatus(userId: user_id, follow_type: 1) { [weak self] in
                self?.follow_button.isSelected = true
                self?.follow_button.setImage(UIImage(named: "cal_chat_follow"), for: .normal)
            }
        }
    }
    
    @IBAction func bottomSelectAction(_ sender: UIButton) {
        if sender.tag == 1000 {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            picker.modalPresentationStyle = .fullScreen
            self.present(picker, animated: true)
        }
        if sender.tag == 1001 {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            picker.modalPresentationStyle = .fullScreen
            self.present(picker, animated: true)
        }
        if sender.tag == 1002 {
            showChatTipsView()
            chatTipsView?.content_label.text = "You're not friends yet. You can't start a video call until the other person replies."
//            return
//            let vc = VideoCallsController()
//            vc.hidesBottomBarWhenPushed = true
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ChatController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendsChatCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.chat_cellUpdateViews(message: messages[indexPath.row])
        
        return cell
    }
}

extension ChatController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if messages.count > 0 {
            showChatTipsView()
            textField.resignFirstResponder()
            return false
        }
        sendMessage()
        textField.resignFirstResponder()
        return true
    }

    private func sendMessage() {
        guard let text = chat_textfiled.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {

            return
        }

        let mineInfo = CalLoginStorage.shared.mineInfo
        let message = CalLocalChatMessage(
            id: UUID().uuidString,
            friendId: user_id,
            friendName: user_name,
            friendAvatar: user_avatar,
            senderName: mineInfo?.nickname ?? "Me",
            senderAvatar: mineInfo?.itemSmallImg ?? "",
            isMine: true,
            content: text,
            createdAt: Date()
        )

        CalLocalChatStorage.shared.append(message)
        messages.append(message)
        chat_textfiled.text = ""
        tableView.reloadData()
        scrollToBottom(animated: true)
    }

    private func scrollToBottom(animated: Bool) {
        guard !messages.isEmpty else {
            return
        }

        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToRow(
                at: indexPath,
                at: .bottom,
                animated: animated
            )
        }
    }
}

extension ChatController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        picker.dismiss(animated: true) {
            if let image = image {
                self.showChatTipsView()
                self.chatTipsView?.content_label.text = "You're not friends yet. You can't send photos until the other person replies."
            }
        }
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
