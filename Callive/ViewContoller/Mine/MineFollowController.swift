
import UIKit

class MineFollowController: UIViewController {
    
    @IBOutlet weak var follow_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var followView: UIView!
    @IBOutlet weak var user_header: UIImageView!
    @IBOutlet weak var follow_desc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MineFollowCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        view.addSubview(followView)
        followView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func keepFollowAction(_ sender: UIButton) {
        
    }
    
}

extension MineFollowController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MineFollowCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
