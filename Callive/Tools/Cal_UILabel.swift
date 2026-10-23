
import UIKit

extension UILabel {
    
    func cal_partTextColor(text: String, partText: String, partColor: UIColor, textColor: UIColor = .label) {
        
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .foregroundColor: textColor,
                .font: self.font as Any
            ]
        )
        
        let range = (text as NSString).range(of: partText)
        
        guard range.location != NSNotFound else {
            self.text = text
            return
        }
        
        attributedString.addAttribute(
            .foregroundColor,
            value: partColor,
            range: range
        )
        
        self.attributedText = attributedString
    }
}
