
import UIKit
import ZKProgressHUD

class UserCenterController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var user_image: UIImageView!
    private var items: [SunriseScene] = []
    var userId: Int64 = 0
    let headerView = Bundle.main.loadNibNamed("UserCenterHeaderView", owner: nil, options: nil)?.first as! UserCenterHeaderView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 390)
        tableView.tableHeaderView = headerView
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserMomentTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        getUserInformation(userId: userId)
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreAction(_ sender: Any) {
        let toolsView = Bundle.main.loadNibNamed("ToolsReportView", owner: nil, options: nil)?.first as! ToolsReportView
        toolsView.user_id = userId
        toolsView.cal_navigation = self.navigationController!
        toolsView.showToolsReportView()
    }
    
    @IBAction func chatAndVideoCallsAction(_ sender: UIButton) {
        if sender.tag == 1000 {
            let vc = ChatController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
           let vc = VideoCallsController()
           vc.hidesBottomBarWhenPushed = true
           navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getUserInformation(userId: Int64) {
        ZKProgressHUD.show()
        Cal_Alamofire.shared.post(urlSuffix: cal_user_info, body: ["userId": userId]) { [weak self] (result: Result<MeadowHostResponse, NetworkError>) in
            ZKProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                headerView.updateUserInformation(model: response.orchardView)
                self.user_image.cal_setImage(response.orchardView.petalMark)
                self.items = response.sunriseScenes
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func momentLikesAction(_ sender: UIButton) {
        var model = items[sender.tag]
        
        ZKProgressHUD.show()
        Cal_Alamofire.shared.postData(urlSuffix: cal_moment_like, body: ["groveKey": model.groveKey, "seedKind": model.blossomSignal == 1 ? 0 : 1]) { [weak self] result in
            ZKProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(_):
                model.blossomSignal = model.blossomSignal == 1 ? 0 : 1
                if model.blossomSignal == 1 {
                    model.seedTally = model.seedTally + 1
                }else {
                    model.seedTally = model.seedTally - 1
                }
                items[sender.tag] = model
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension UserCenterController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserMomentTableViewCell
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        cell.moment_cellUpdateViews(model: items[indexPath.row])
        cell.cell_love_button.tag = indexPath.row
        cell.cell_love_button.addTarget(self, action: #selector(momentLikesAction(_ :)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
