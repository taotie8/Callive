
import UIKit
import AVFoundation
import IQKeyboardManagerSwift
class PlayVideoController: UIViewController {

    private struct SayMessage {
        let nickname: String
        let content: String
    }

    @IBOutlet weak var user_header: UIImageView!
    @IBOutlet weak var user_name_label: UILabel!
    @IBOutlet weak var user_id_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var say_text: UITextField!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var video_inputView: UIView!
    @IBOutlet weak var input_bottom_layout: NSLayoutConstraint!
    var model: MeadowLineItem!
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playbackObserver: NSObjectProtocol?
    private var cal_keyboard: Cal_KeyboardManager!
    private var messageLists: [SayMessage] = []
    private var waitingMessages: [SayMessage] = []
    private var messageTimer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = false
        changeLists()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.isEnabled = true
        stopVideo()
        messageTimer?.invalidate()
        messageTimer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserViews()
        cal_keyboard = Cal_KeyboardManager(targetView: view, bottomConstraint: input_bottom_layout, adjustment: -16)
        say_text.cal_placeholderColor(.hex("#FFFFFF", alpha: 0.3), text: "Say Hi...")
        user_header.layer.cornerRadius = 16
        user_header.layer.masksToBounds = true
        user_header.layer.borderWidth = 1
        user_header.layer.borderColor = UIColor.white.cgColor
        
        say_text.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PlayVideoSayCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func updateUserViews() {
        let userId = String(model.forestGuest)
        user_header.cal_setImage(model.petalMark)
        user_name_label.text = model.nickname
        user_id_label.text = "ID:\(String(userId.suffix(8)))"
        playVideo(urlString: model.videoUrl ?? "")
    }

    @IBAction func closeAction(_ sender: Any) {
        let exitView = Bundle.main.loadNibNamed("ExitRoomView", owner: nil, options: nil)?.first as! ExitRoomView
        exitView.cal_navigation = self.navigationController!
        exitView.user_id = model.forestGuest
        exitView.follow_button.isSelected = ((model.visitSignal ?? 0) != 0)
        exitView.follow_button.setTitle(model.visitSignal == 1 ? "Followed" : "Follow", for: .normal)
        exitView.showExitRoomView()
    }
    
    @IBAction func moreAction(_ sender: Any) {
        let toolsView = Bundle.main.loadNibNamed("ToolsReportView", owner: nil, options: nil)?.first as! ToolsReportView
        toolsView.user_id = model.forestGuest
        toolsView.cal_self = self
        toolsView.showToolsReportView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoView.bounds
    }
    
    func playVideo(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        stopVideo()

        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)

        playbackObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            self?.player?.seek(to: .zero) { _ in
                self?.player?.play()
            }
        }

        let layer = AVPlayerLayer(player: player)
        layer.frame = videoView.bounds
        layer.videoGravity = .resizeAspectFill

        videoView.layer.addSublayer(layer)
        playerLayer = layer

        player?.play()
    }

    func stopVideo() {
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil

        playerLayer?.removeFromSuperlayer()
        playerLayer = nil

        if let playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver)
            self.playbackObserver = nil
        }
    }

    deinit {
        stopVideo()
        messageTimer?.invalidate()
    }
    func changeLists() {
        let allMessages: [SayMessage] = [
            SayMessage(nickname: "Lopez", content: "I can't decide between a peachy look and a rosy makeup look today."),
            SayMessage(nickname: "Josea Alvm", content: "Peach tones are perfect for a fresh and natural everyday look."),
            SayMessage(nickname: "Renteria", content: "Do you prefer cream blush or powder blush?"),
            SayMessage(nickname: "SKNbyKiki", content: "I love cream blush because it looks more natural and blends easily."),
            SayMessage(nickname: "Thiago Jsus", content: "I always apply moisturizer before starting my makeup."),
            SayMessage(nickname: "David bird", content: "Good skin prep makes the makeup look much smoother."),
            SayMessage(nickname: "Lvy", content: "I'm still practicing eyeliner. Both eyes never look exactly the same."),
            SayMessage(nickname: "Lopez", content: "Try brown eyeliner first. It looks softer and is easier to control."),
            SayMessage(nickname: "Josea Alvm", content: "Natural lighting makes it easier to choose the right foundation shade."),
            SayMessage(nickname: "Renteria", content: "I prefer a lightweight base and only use concealer where I need it."),
            SayMessage(nickname: "SKNbyKiki", content: "A nude lip liner with clear gloss is my favorite simple lip look."),
            SayMessage(nickname: "Thiago Jsus", content: "Setting spray is a lifesaver when I wear makeup all day."),
            SayMessage(nickname: "David bird", content: "Do you use eye primer before applying eye makeup?"),
            SayMessage(nickname: "Lvy", content: "Yes, especially when I want my eyeshadow to last all day."),
            SayMessage(nickname: "Lopez", content: "If you have oily skin, a light layer of setting powder works really well."),
            SayMessage(nickname: "Josea Alvm", content: "I love adding a little highlighter to the inner corners of my eyes."),
            SayMessage(nickname: "Renteria", content: "That small detail makes the whole makeup look brighter."),
            SayMessage(nickname: "SKNbyKiki", content: "Makeup doesn't have to be perfect. Trying different styles is the fun part."),
            SayMessage(nickname: "Thiago Jsus", content: "I'm going to try a soft glam look this weekend."),
            SayMessage(nickname: "David bird", content: "Share your makeup looks later. I need some new inspiration.")
        ]

        let shuffledMessages = allMessages.shuffled()
        messageLists = Array(shuffledMessages.prefix(5))
        waitingMessages = Array(shuffledMessages.dropFirst(5))

        tableView.reloadData()
        scheduleNextMessage()
    }

    private func scheduleNextMessage() {
        messageTimer?.invalidate()

        guard !waitingMessages.isEmpty else {
            return
        }

        messageTimer = Timer.scheduledTimer(
            withTimeInterval: Double.random(in: 3...4),
            repeats: false
        ) { [weak self] _ in
            guard let self = self,
                  !self.waitingMessages.isEmpty else {
                return
            }

            let index = Int.random(in: 0..<self.waitingMessages.count)
            let message = self.waitingMessages.remove(at: index)
            self.messageLists.append(message)

            self.tableView.reloadData()

            let indexPath = IndexPath(
                row: self.messageLists.count - 1,
                section: 0
            )

            self.tableView.scrollToRow(
                at: indexPath,
                at: .bottom,
                animated: true
            )

            self.scheduleNextMessage()
        }
    }
    
}

extension PlayVideoController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayVideoSayCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        let message = messageLists[indexPath.row]
        cell.user_name_label.text = "\(message.nickname):"
        cell.say_label.text = message.content

        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !text.isEmpty else {
            textField.resignFirstResponder()
            return true
        }

        messageLists.append(
            SayMessage(nickname: "Me", content: text)
        )

        textField.text = ""
        textField.resignFirstResponder()
        tableView.reloadData()

        let indexPath = IndexPath(row: messageLists.count - 1, section: 0)

        tableView.scrollToRow( at: indexPath, at: .bottom, animated: true)

        return true
    }
    
}
