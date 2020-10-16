import Foundation
import UIKit

final class ComicDetailsScreenInteractor: ComicDetailsScreenInteractorType {
	var webService: WebService
	
	init(webService: WebService) {
		self.webService = webService
	}
	
	func getComicImage(
		imageUri: String,
		completionHandler: @escaping (UIImage?, WebServiceError?) -> Void
	) {
		DispatchQueue.global(qos: .userInitiated).async { () in
			var data: Data? = nil
			
			if let url = URL(string: imageUri) {
				data = try? Data(contentsOf: url)
			}
			
			if let imageData = data {
				DispatchQueue.main.async {
					completionHandler(UIImage(data: imageData), nil)
				}
			} else {
				DispatchQueue.main.async {
					completionHandler(nil, .invalidResponse)
				}
			}
		}
	}
	
}
