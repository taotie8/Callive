
import UIKit

class ChatTipsView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var content_label: UILabel!
    var onClose: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        alpha = 0
        contentView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }

    func show(in containerView: UIView) {
        frame = containerView.bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(self)

        alpha = 0
        contentView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        UIView.animate(
            withDuration: 0.28,
            delay: 0,
            usingSpringWithDamping: 0.78,
            initialSpringVelocity: 0.2,
            options: [.curveEaseOut]
        ) { [weak self] in
            self?.alpha = 1
            self?.contentView.transform = .identity
        }
    }

    private func hide() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.alpha = 0
            self?.contentView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { [weak self] _ in
            self?.removeFromSuperview()
            self?.onClose?()
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        hide()
    }
    
}
