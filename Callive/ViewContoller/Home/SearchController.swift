
import UIKit
import ZKProgressHUD

class SearchController: UIViewController {

    @IBOutlet weak var search_text: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var display_image: UIImageView!
    private var items: [MeadowLine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        if check_stringNull(search_text.text) {
            ZKProgressHUD.showError("Please enter name or uid")
            return
        }
        requestSearchMedatas()
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
    
    func requestSearchMedatas() {
        ZKProgressHUD.show()
        Cal_Alamofire.shared.post(urlSuffix: cal_search_list, body: ["condition": search_text.text!, "groveMode": ""]) { [weak self] (result: Result<HomeAllResponse, NetworkError>) in
            ZKProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.items = response.meadowLines
                self.display_image.isHidden = self.items.count > 0 ? true : false
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeControllerCell
        cell.backgroundColor = .clear
        let model = items[indexPath.item]
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
        let cell_width = (UIScreen.main.bounds.width - 32.08)/2
        return CGSize(width: cell_width, height: cell_width * 1.17)
    }
}

