
import UIKit
import ZKProgressHUD

enum HomeType: Int, CaseIterable {
    case all = 0
    case video
    case new
    case follow
}

class HomeController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleView: UIView!
    private var items: [MeadowLine] = []
    private var videos: [MeadowLineItem] = []
    private var currentPage = 1
    private var home_type: HomeType = .all
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getAppNewConfig()
        requestMineInformation { }
        
        let checkView = Bundle.main.loadNibNamed("DailyCheckView", owner: nil, options: nil)?.first as! DailyCheckView
        checkView.showDailyCheckView()
    }
    
    func getAppNewConfig() {
        ZKProgressHUD.show()
        Cal_Alamofire.shared.postData(urlSuffix: cal_app_config) { [weak self] result in
            ZKProgressHUD.dismiss()
            switch result {
            case .success(_):
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
        items.removeAll()
        videos.removeAll()
        home_type = .all
        if sender.titleLabel?.text == "All" {
            homeAllMedatas()
            home_type = .all
        }else if sender.titleLabel?.text == "Video" {
            homeVideoLists()
            home_type = .video
        }
        else if sender.titleLabel?.text == "Follow" {
            homeFollowUserList()
            home_type = .follow
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let vc = SearchController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 首页All
    func homeAllMedatas() {
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
    
    
    func homeVideoLists() {
        ZKProgressHUD.show()
        Cal_Alamofire.shared.post(urlSuffix: cal_video_list) { [weak self] (result: Result<MeadowLinesResponse, NetworkError>) in
            ZKProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if self.currentPage == 1 {
                    self.videos = response.meadowLines
                } else {
                    self.videos.append(contentsOf: response.meadowLines)
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func homeFollowUserList() {
        ZKProgressHUD.show()
        Cal_Alamofire.shared.post(urlSuffix: cal_follow_list) { [weak self] (result: Result<HomeAllResponse, NetworkError>) in
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
        if home_type == .video {
            return videos.count
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeControllerCell
        cell.backgroundColor = .clear
        if home_type == .video {
            let model = videos[indexPath.item]
            cell.home_cellUpdateVideoViews(model: model)
        }
        else {
            let model = items[indexPath.item]
            cell.home_cellUpdateViews(model: model)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if home_type == .video {
            let model = videos[indexPath.item]
            let vc = PlayVideoController()
            vc.model = model
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        let model = items[indexPath.item]
        let vc = UserCenterController()
        vc.userId = model.forestGuest
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell_width = (UIScreen.main.bounds.width - 32.08)/2
        if home_type == .all {
            if indexPath.row == 0 {
                return CGSize(width: UIScreen.main.bounds.width - 24, height: (UIScreen.main.bounds.width - 24) * 0.62)
            }
            return CGSize(width: cell_width, height: cell_width * 1.17)
        }
        return CGSize(width: cell_width, height: cell_width * 1.17)
    }
}

