
import UIKit

class TakePhotoView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func showTakePhotoView() {
        UIApplication.shared.cal_window?.addSubview(self)
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.alpha = 1.0
        UIView.animate(withDuration: 0.28) {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }

    func hiddenTakePhotoView() {
        UIView.animate(withDuration: 0.28) {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } completion: { _ in
            self.alpha = 0.0
            UIApplication.shared.cal_window?.removeFromSuperview()
        }
    }
}
