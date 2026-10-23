
import UIKit
import ZKProgressHUD

class EditInforController: UIViewController {

    @IBOutlet weak var user_header: UIImageView!
    @IBOutlet weak var user_name_text: UITextField!
    @IBOutlet weak var user_time_label: UITextField!
    @IBOutlet weak var signature_text: UITextView!
    @IBOutlet weak var desc_label: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        signature_text.delegate = self
        if let model = CalLoginStorage.shared.mineInfo {
            user_name_text.text = model.nickname
            user_header.cal_setImage(model.petalMark)
            signature_text.text = model.leafSeal
            user_time_label.text = String(model.sunriseDay.prefix(10))
            desc_label.text = signature_text.text.count > 0 ? "" : "You can add a short bio to teel people more about yourself."
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseUserHeaderAction(_ sender: UIButton) {
        let takePhoto = Bundle.main.loadNibNamed("TakePhotoView", owner: nil, options: nil)?.first as! TakePhotoView
        takePhoto.cal_self = self
        takePhoto.showTakePhotoView()
        takePhoto.takePhotoImageBlock = { [weak self] image in
            self?.user_header.image = image
        }
    }
    
    @IBAction func chooseCalenderAction(_ sender: Any) {
        let vc = DateOfBirthController()
        vc.mine_birth = user_time_label.text ?? "2000-01-01"
        vc.hidesBottomBarWhenPushed = true
        vc.selectedDateBlock = { [weak self] date in
            self?.user_time_label.text = date
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if check_stringNull(user_name_text.text) {
            ZKProgressHUD.showError("Nickname cannot be empty.")
            return
        }
        if check_stringNull(user_time_label.text) {
            ZKProgressHUD.showError("Birthday cannot be empty.")
            return
        }
        requestUpdateMineInfo()
    }
    
    func requestUpdateMineInfo() {
        var body = ["nickname": user_name_text.text!,
                    "sunriseDay": user_time_label.text!]
        
        if check_stringNull(signature_text.text) {
            body["leafSeal"] = "Still thinking of a bio. Let’s keep it mysterious for now."
        }else {
            body["leafSeal"] = signature_text.text
        }
        
        ZKProgressHUD.show()
        Cal_Alamofire.shared.postData(urlSuffix: cal_update_info, body: body) { result in
            ZKProgressHUD.dismiss()
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: Notification.Name("updateMineInformationNotification"), object: nil)
                ZKProgressHUD.showSuccess("Profile updated successfully. Your profile photo is under review.")
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                ZKProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    
}

extension EditInforController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        desc_label.text = ""
        if check_stringNull(signature_text.text) {
            desc_label.text = "You can add a short bio to teel people more about yourself."
        }
    }
}
