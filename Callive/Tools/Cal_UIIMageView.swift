
import Foundation
import SDWebImage

extension UIImageView {

    func cal_setImage(_ urlString: String?, placeholder: UIImage? = nil, completed: ((UIImage?, Error?, SDImageCacheType, URL?) -> Void)? = nil) {
        guard let urlString = urlString,
              !urlString.isEmpty,
              let url = URL(string: urlString) else {
            image = placeholder
            return
        }

        sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "cal_header"),
            options: [.retryFailed, .continueInBackground, .scaleDownLargeImages],
            completed: completed
        )
    }
}
