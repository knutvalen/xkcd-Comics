import UIKit

struct Constants {
	static let App = UIApplication.shared.delegate as? AppDelegate
	
	struct BackendAPI {
		static let endpoint = "http://xkcd.com"
		static let comicNumber = "/%@/info.0.json"
	}
}
