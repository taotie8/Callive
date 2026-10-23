
import UIKit
import ZKProgressHUD
enum FollowAndBlockType: String, Decodable {
    case follow
    case fans
    case block
}

class MineFollowController: UIViewController {
    
    @IBOutlet weak var follow_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var followView: UIView!
    @IBOutlet weak var user_header: UIImageView!
    @IBOutlet weak var follow_desc: UILabel!
    @IBOutlet weak var cal_display: UIImageView!
    var classType: FollowAndBlockType = .follow
    var items : [BlacklistUser] = []
    var select_idx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cal_display.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MineFollowCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        if classType == .block {
            requestBlockList()
            follow_label.text = "Block"
        }
        else if classType == .follow {
            requestFollowAndFansList(type: 3)
            follow_label.text = "Following"
            
            view.addSubview(followView)
            followView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        else {
            requestFollowAndFansList(type: 2)
            follow_label.text = "Fans"
        }
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func keepFollowAction(_ sender: UIButton) {
        if sender.tag == 1000 {
            let model = items[select_idx]
            updateUserFollowStatus(userId: model.forestGuest, follow_type: 2) {
                self.items.remove(at: self.select_idx)
                self.tableView.reloadData()
                self.cal_display.isHidden = self.items.count == 0 ? false : true
                NotificationCenter.default.post(name: Notification.Name("updateMineInformationNotification"), object: nil)
            }
        }
        UIView.animate(withDuration: 0.28) {
            self.followView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    func requestBlockList() {
        ZKProgressHUD.show()
        Cal_Alamofire.shared.post(urlSuffix: cal_block_list) { [weak self] (result: Result<BlacklistResponse, NetworkError>) in
            ZKProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.items = response.meadowLines
                self.tableView.reloadData()
                self.cal_display.isHidden = self.items.count == 0 ? false : true
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestFollowAndFansList(type: Int) {
        ZKProgressHUD.show()
        Cal_Alamofire.shared.post(urlSuffix: cal_fans_list, body: ["type": type]) { [weak self] (result: Result<BlacklistResponse, NetworkError>) in
            ZKProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.items = response.meadowLines
                self.tableView.reloadData()
                self.cal_display.isHidden = self.items.count == 0 ? false : true
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func unfollowAndRemoveAction(_ sender: UIButton) {
        let model = items[sender.tag]
        select_idx = sender.tag
        if classType == .follow {
            UIView.animate(withDuration: 0.28) {
                self.followView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
            user_header.cal_setImage(model.petalMark)
            follow_desc.cal_partTextColor(text: "Are you sure you want to \(model.nickname)?", partText: model.nickname, partColor: .hex("#FF3366"), textColor: .hex("#111111"))
        }
    }
    
}

extension MineFollowController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MineFollowCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.black_cellUpdateViews(model: items[indexPath.item])
        cell.cell_button.tag = indexPath.item
        cell.cell_button.addTarget(self, action: #selector(unfollowAndRemoveAction(_ :)), for: .touchUpInside)
        if classType == .block {
            cell.cell_button.backgroundColor = .hex("#00F2FF", alpha: 1.0)
            cell.cell_button.setTitle("Remove", for: .normal)
            cell.cell_button.setTitleColor(.hex("#111111"), for: .normal)
        }
        else if classType == .follow {
            cell.cell_button.setTitle("Unfollow", for: .normal)
        }
        else {
            cell.cell_button.setTitle("Follow", for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = items[indexPath.item]
        let vc = UserCenterController()
        vc.userId = model.forestGuest
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
