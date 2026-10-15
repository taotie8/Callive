
import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleView: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
}

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeControllerCell
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UserCenterController()
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

