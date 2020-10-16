import Foundation
import UIKit

protocol ComicDetailsScreenViewType {
	func refresh()
	func setLoading(_ loading: Bool)
}

protocol ComicDetailsScreenInteractorType {
	func getComicImage(
		imageUri: String,
		completionHandler: @escaping (UIImage?, WebServiceError?) -> Void
	)
}

protocol ComicDetailsScreenPresenterType {
	func viewDidLoad()
	var image: UIImage? { get }
}

protocol ComicDetailsScreenRouterType {
	static func create(comicModel: ComicModel) -> UIViewController?
}
