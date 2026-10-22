
import UIKit
import IQKeyboardManagerSwift

enum LocalChatMessageType: String, Decodable {
    case text
    case gift
}

class ChatRoomController: UIViewController {
    
    @IBOutlet weak var say_text: UITextField!
    @IBOutlet weak var user_header: UIImageView!
    @IBOutlet weak var room_name: UILabel!
    @IBOutlet weak var room_id: UILabel!
    @IBOutlet weak var room_people: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var input_bottom_layout: NSLayoutConstraint!
    private var messages: [ChatRoomModel] = []
    private var mockMessages: [ChatRoomModel] = []
    private var messageTimer: Timer?
    private var cal_keyboard: Cal_KeyboardManager!
    
    let giftView = Bundle.main.loadNibNamed("GiftGivingView", owner: nil, options: nil)?.first as! GiftGivingView
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = false
        loadRandomMessages()
        startMessageTimer()
    }

    private func loadRandomMessages() {
        guard let fileURL = Bundle.main.url(forResource: "LocalChatMessages", withExtension: "json")
        else {
            mockMessages = []
            messages = []
            tableView.reloadData()
            print("LocalChatMessages.json not found in the app bundle")
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let allMessages = try JSONDecoder().decode([ChatRoomModel].self, from: data)

            mockMessages = allMessages
            messages = Array(allMessages.shuffled().prefix(10))
            tableView.reloadData()
        } catch {
            mockMessages = []
            messages = []
            tableView.reloadData()
            print("Failed to load local chat messages: \(error)")
        }
    }

    private func startMessageTimer() {
        messageTimer?.invalidate()

        messageTimer = Timer.scheduledTimer(
            withTimeInterval: 2.0,
            repeats: true
        ) { [weak self] _ in
            self?.appendRandomMessage()
        }
    }

    private func appendRandomMessage() {
        guard let message = mockMessages.randomElement() else {
            return
        }

        appendMessage(message)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.isEnabled = true
        messageTimer?.invalidate()
        messageTimer = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        say_text.delegate = self
        user_header.layer.cornerRadius = 16
        cal_keyboard = Cal_KeyboardManager(targetView: view, bottomConstraint: input_bottom_layout, adjustment: -16)
        say_text.cal_placeholderColor(.hex("#FFFFFF", alpha: 0.3), text: "Say Hi...")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "RoomChatCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "RoomChatGiftCell", bundle: nil), forCellReuseIdentifier: "gift")
        
        giftView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(giftView)
        giftView.onSendGift = { [weak self] model, count in
            self?.sendGift(model: model, count: count)
        }
    }

    @IBAction func dissmisAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectGiftAction(_ sender: Any) {
        UIView.animate(withDuration: 0.28) {
            self.giftView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    @IBAction func moreAction(_ sender: Any) {
        let toolsView = Bundle.main.loadNibNamed("ToolsReportView", owner: nil, options: nil)?.first as! ToolsReportView
        toolsView.user_id = 100000001
        toolsView.cal_self = self
        toolsView.showToolsReportView()
    }

    private func sendMessage() {
        guard let text = say_text.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            return
        }

        let mineInfo = CalLoginStorage.shared.mineInfo
        let message = ChatRoomModel(
            nickname: mineInfo?.nickname ?? "Me",
            avatar: mineInfo?.itemSmallImg ?? "",
            content: text,
            giftImage: nil,
            giftName: nil,
            giftCount: nil,
            type: .text
        )

        appendMessage(message)
        say_text.text = ""
    }

    private func sendGift(model: GiftItemModel, count: Int) {
        guard count > 0 else {
            return
        }

        let mineInfo = CalLoginStorage.shared.mineInfo
        let message = ChatRoomModel(
            nickname: mineInfo?.nickname ?? "Me",
            avatar: mineInfo?.itemSmallImg ?? "",
            content: model.dailyTitle,
            giftImage: model.leafMiniature,
            giftName: model.dailyTitle,
            giftCount: count,
            type: .gift
        )

        appendMessage(message)
        giftView.hiddenGiftGivingView()
    }

    private func appendMessage(_ message: ChatRoomModel) {
        messages.append(message)
        tableView.reloadData()

        let lastIndexPath = IndexPath(row: messages.count - 1, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToRow(
                at: lastIndexPath,
                at: .bottom,
                animated: true
            )
        }
    }
    
    
}

extension ChatRoomController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = messages[indexPath.row]

        if model.type == .gift {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gift", for: indexPath) as! RoomChatGiftCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.room_cellUpdateViews(model: model)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoomChatCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.room_cellUpdateViews(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ChatRoomController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        say_text.resignFirstResponder()
        
        return true
    }
}
