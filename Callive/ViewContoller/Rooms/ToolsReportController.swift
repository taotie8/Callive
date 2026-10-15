
import UIKit

class ToolsReportController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var specific_label: UILabel!
    @IBOutlet weak var remarks_label: UITextView!
    @IBOutlet var remarkView: UIView!
    var items = [String]()
    var idx = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ToolsReportCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.tableFooterView = remarkView
        items = ["Pornographic", "Involving politics or religions", "Violent or bloody behaviour", "Insulting words", "Advertisement or third-party recharge"]
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
    }
}

extension ToolsReportController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ToolsReportCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.cell_label.text = items[indexPath.row]
        cell.cell_select_image.image = UIImage(named: "check_normal")
        if idx == indexPath.row {
            cell.cell_select_image.image = UIImage(named: "check_select")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.item
        tableView.reloadData()
    }
}
