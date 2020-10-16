import Foundation
import UIKit

protocol ComicDetailsScreenViewType {
	func refresh()
	func setLoading(_ loading: Bool)
}

protocol ComicDetailsScreenInteractorType {
	func getComicImage(
		completionHandler: @escaping (UIImage?, WebServiceError?) -> Void
	)
}

protocol ComicDetailsScreenPresenterType {
	func viewWillAppear()
}

protocol ComicDetailsScreenRouterType {
	static func create(comicModel: ComicModel) -> UIViewController?
}
