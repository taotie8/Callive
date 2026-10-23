
import UIKit

class MessageSystemController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MessageSystemCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}

extension MessageSystemController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageSystemCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.item == 0 {
            cell.cell_content_label.text = "Welcome aboard!Hi there👋, glad you’re here.To keep our community safe:When you haven’t become mutual friends with someone, you can send one opening message. You may keep chatting after they reply. Full unlimited messaging is available for mutual‑friend connections.Have fun making genuine connections!"
        }
        else {
            cell.cell_content_label.text = "📢 AnnouncementWe’ve adjusted our messaging rules to create a safer, low‑harassment environment for all users."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
