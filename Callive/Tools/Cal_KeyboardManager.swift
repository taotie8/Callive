
import UIKit

final class Cal_KeyboardManager: NSObject {

    private weak var targetView: UIView?
    private var bottomConstraint: NSLayoutConstraint?
    private let adjustment: CGFloat
    
    init(targetView: UIView, bottomConstraint: NSLayoutConstraint, adjustment: CGFloat = 0) {
        self.targetView = targetView
        self.bottomConstraint = bottomConstraint
        self.adjustment = adjustment
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc private func keyboardChanged(_ notification: Notification) {
        guard let targetView,
              let keyboardValue = notification.userInfo?[
                UIResponder.keyboardFrameEndUserInfoKey
              ] as? NSValue
        else {
            return
        }

        let keyboardFrame = targetView.convert(keyboardValue.cgRectValue, from: nil)

        let keyboardHeight = targetView.bounds.intersection(keyboardFrame).height

        bottomConstraint?.constant = keyboardHeight + adjustment

        UIView.animate(withDuration: 0.25) {
            targetView.layoutIfNeeded()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
