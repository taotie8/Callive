
import UIKit

class GiftGivingView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var count_label: UILabel!
    @IBOutlet weak var coins_label: UILabel!
    private var items: [GiftItemModel] = []
    private var select_idx = 0
    private var giftCount = 1 {
        didSet {
            count_label.text = "\(giftCount)"
        }
    }
    var onSendGift: ((GiftItemModel, Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        Cal_Alamofire.shared.post(urlSuffix: cal_gift_list) { (result: Result<GiftListResponse, NetworkError>) in
//            ZKProgressHUD.dismiss()
            switch result {
            case .success(let data):
//                print(String(data: data, encoding: .utf8) ?? "")
                self.items = data.meadowLines
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 48.05)/4, height: 102)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "GiftGivingCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    @IBAction func closeAction(_ sender: Any) {
        hiddenGiftGivingView()
    }
    
    @IBAction func reduceCountAction(_ sender: Any) {
        giftCount = max(1, giftCount - 1)
    }
    
    @IBAction func insertCountAction(_ sender: Any) {
        giftCount = min(999, giftCount + 1)
    }
    
    @IBAction func sendGiftAction(_ sender: Any) {
        let model = items[select_idx]
        onSendGift?(model, giftCount)
    }
    
    @IBAction func supplementCoinsAction(_ sender: Any) {
        
    }

    func hiddenGiftGivingView() {
        UIView.animate(withDuration: 0.28) {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } completion: { _ in
        }
    }

}

extension GiftGivingView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GiftGivingCell
        cell.backgroundColor = .clear
        let model = items[indexPath.row]
        cell.gift_icon.cal_setImage(model.leafMiniature)
        cell.gift_name.text = model.dailyTitle
        cell.count_label.text = "\(model.meadowCost)"
        cell.select_color.backgroundColor = .clear
        
        if indexPath.item == select_idx {
            cell.select_color.backgroundColor = .hex("#384143", alpha: 1.0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        select_idx = indexPath.row
        collectionView.reloadData()
    }
}
