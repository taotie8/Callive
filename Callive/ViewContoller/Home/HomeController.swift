
import UIKit
import ZKProgressHUD

class HomeController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleView: UIView!
    private var items: [MeadowLine] = []
    private var currentPage = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        homeAllMedatas()
        
        getAppNewConfig()
//        updateUserToken() {
//            
//        }
    }
    
    func getAppNewConfig() {
        ZKProgressHUD.show()
        Cal_Alamofire.shared.postData(urlSuffix: cal_app_config) { [weak self] result in
            ZKProgressHUD.dismiss()
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8) ?? "")
                self?.backExpiresInStatus()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func backExpiresInStatus() {
        if CalLoginStorage.shared.needRefreshToken() { // token过期，获取新的token
            updateUserToken {
                self.homeAllMedatas()
            }
        }
        else {
            self.homeAllMedatas()
        }
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeControllerCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    @IBAction func selectTitlesAction(_ sender: UIButton) {
        for view in titleView.subviews {
            if let btn = view as? UIButton {
                btn.setTitleColor(.hex("#A5A7A6"), for: .normal)
                btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
                if btn == sender {
                    btn.setTitleColor(.hex("#111111"), for: .normal)
                    btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
                }
            }
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let vc = SearchController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 首页All
    func homeAllMedatas() {
//        Cal_Alamofire.shared.postData(urlSuffix: cal_home_all) { result in
//            ZKProgressHUD.dismiss()
//            switch result {
//            case .success(let data):
//                print(String(data: data, encoding: .utf8) ?? "")
//
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        
        ZKProgressHUD.show()
        Cal_Alamofire.shared.post(urlSuffix: cal_home_all) { [weak self] (result: Result<HomeAllResponse, NetworkError>) in
            ZKProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if self.currentPage == 1 {
                    self.items = response.meadowLines
                } else {
                    self.items.append(contentsOf: response.meadowLines)
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeControllerCell
        cell.backgroundColor = .clear
        cell.home_cellUpdateViews(model: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = items[indexPath.item]
        let vc = UserCenterController()
        vc.userId = model.forestGuest
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: UIScreen.main.bounds.width - 24, height: (UIScreen.main.bounds.width - 24) * 0.62)
        }
        let cell_width = (UIScreen.main.bounds.width - 32.08)/2
        return CGSize(width: cell_width, height: cell_width * 1.17)
    }
}

