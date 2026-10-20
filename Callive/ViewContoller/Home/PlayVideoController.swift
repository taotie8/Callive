
import UIKit
import AVFoundation
import IQKeyboardManagerSwift
class PlayVideoController: UIViewController {

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.isEnabled = true
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PlayVideoSayCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func updateUserViews() {
        user_header.cal_setImage(model.petalMark)
        user_name_label.text = model.nickname
        user_id_label.text = "\(model.forestGuest)"
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
        toolsView.cal_navigation = self.navigationController!
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
        player = nil

        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }

    deinit {
        stopVideo()
    }
    
}

extension PlayVideoController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayVideoSayCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.say_label.text = "She is my baby!"
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        say_text.resignFirstResponder()
        return true
    }
    
}
