
import UIKit
import ZKProgressHUD

let signDateKey = "dailySignDate"
var hasSignedToday: Bool {
    let savedDate = UserDefaults.standard.string(forKey: signDateKey)
    return savedDate == todayString()
}

class DailyCheckView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var checkin_button: UIButton!
    private var select_idx = 0
    private var seasonTurn: Int = 0
    private var sproutSeal: Int = 0
    private var items: [DailyCheckDay] = []
    private var coins: [String] = ["10", "10", "20", "20", "30", "30", "50"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        requestSignDetails()
        if hasSignedToday {
            self.checkin_button.isEnabled = false
        }
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "DailyCheckCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    @IBAction func check_inAction(_ sender: Any) {
        if sproutSeal == 1 {
            self.requestSign()
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        hiddenDailyCheckView()
    }
    
    private func requestSignDetails() {
        Cal_Alamofire.shared.post(urlSuffix: cal_sgin_detail) { [weak self] (result: Result<DailyCheckResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.select_idx = response.seasonTurn
                self.sproutSeal = response.sproutSeal
                self.items = response.sunriseSpan
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func requestSign() {
        ZKProgressHUD.show()
        Cal_Alamofire.shared.postData(urlSuffix: cal_sgin_success) { result in
            ZKProgressHUD.dismiss()
            switch result {
            case .success(_):
                UserDefaults.standard.set(todayString(), forKey: signDateKey)
                updateCoinsNumber(coins: 10)
                self.requestSignDetails()
                if hasSignedToday {
                    self.checkin_button.isEnabled = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showDailyCheckView() {
        UIApplication.shared.cal_window?.addSubview(self)
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.alpha = 1.0
        UIView.animate(withDuration: 0.28) {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }

    func hiddenDailyCheckView() {
        UIView.animate(withDuration: 0.28) {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } completion: { _ in
            self.alpha = 0.0
            UIApplication.shared.cal_window?.removeFromSuperview()
        }
    }

}

extension DailyCheckView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DailyCheckCell
        cell.check_coins_label.text = "+\(coins[indexPath.item])"
        cell.time_label.text = "Day \(indexPath.item + 1)"
        cell.check_icon.image = UIImage(named: "check_coins_coin")
        
        cell.layer.borderColor = UIColor.hex("#17DCFF").cgColor
        cell.layer.borderWidth = 0
        if select_idx == indexPath.item {
            if sproutSeal == 1 {
                cell.layer.borderWidth = 1
            }
        }
        if select_idx >= indexPath.item {
            if hasSignedToday {
                cell.layer.borderWidth = 0
                cell.check_icon.image = UIImage(named: "sgin_success")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 6 {
            return CGSize(width: 124, height: 84)
        }
        return CGSize(width: 59, height: 84)
    }
}
