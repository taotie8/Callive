
import UIKit
import AVFoundation

class TakePhotoView: UIView {
    var cal_self = UIViewController()
    var takePhotoImageBlock: ((_ photoImage: UIImage) -> Void)?
    
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
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
        
        if sender.tag == 1000 {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            cal_self.present(picker, animated: true)
        }
        else if sender.tag == 1001 {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            picker.modalPresentationStyle = .fullScreen
            cal_self.present(picker, animated: true)
        }
        hiddenTakePhotoView()
    }
    
}

extension TakePhotoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        picker.dismiss(animated: true) {
            if let image = image {
                self.hiddenTakePhotoView()
                self.takePhotoImageBlock?(image)
            }
        }
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
