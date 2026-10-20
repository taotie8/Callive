
import UIKit

extension UITextField {
    
    func cal_placeholderColor(_ color: UIColor, text: String? = nil) {
        let placeholderText = text ?? placeholder ?? ""
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: color])
    }
}
