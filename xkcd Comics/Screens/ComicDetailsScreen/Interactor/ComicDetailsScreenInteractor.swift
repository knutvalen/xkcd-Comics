import Foundation
import UIKit

final class ComicDetailsScreenInteractor: ComicDetailsScreenInteractorType {
	var webService: WebService
	
	init(webService: WebService) {
		self.webService = webService
	}
	
	func getComicImage(
		completionHandler: @escaping (UIImage?, WebServiceError?) -> Void
	) {
		// TODO
	}
	
}
