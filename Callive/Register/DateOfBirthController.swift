
import UIKit

class DateOfBirthController: UIViewController {

    @IBOutlet weak var birth_label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    var selectedDateBlock: ((String) -> Void)?
    var mine_birth = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = Calendar(identifier: .gregorian)
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.calendar = calendar
        datePicker.maximumDate = Date()
        datePicker.maximumDate = calendar.date(byAdding: .year, value: -18, to: Date())
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        
        birth_label.text = mine_birth
        setDate(mine_birth)
    }
    
    func setDate(_ dateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: dateString) else {
            return
        }

        datePicker.setDate(date,animated: false)
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        birth_label.text = formatter.string( from: sender.date)
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        selectedDateBlock?(birth_label.text ?? "")
        navigationController?.popViewController(animated: true)
    }
    
    
}
