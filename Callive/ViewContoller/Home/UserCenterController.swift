
import UIKit

class UserCenterController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let headerView = Bundle.main.loadNibNamed("UserCenterHeaderView", owner: nil, options: nil)?.first as! UserCenterHeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 386)
        tableView.tableHeaderView = headerView
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserMomentTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreAction(_ sender: Any) {
        
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
    
}

extension UserCenterController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserMomentTableViewCell
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
