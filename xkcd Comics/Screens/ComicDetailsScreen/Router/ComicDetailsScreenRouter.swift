import UIKit

final class ComicDetailsScreenRouter: ComicDetailsScreenRouterType {
	static func create(comicModel: ComicModel) -> UIViewController? {
		let viewController = UIStoryboard(name: "ComicDetailsScreenStoryboard", bundle: .main)
			.instantiateViewController(identifier: "ComicDetailsScreenViewController")
		
		guard let view = viewController as? ComicDetailsScreenViewController,
			let webService = Constants.App?.webService
			else { return nil }
		
		let interactor = ComicDetailsScreenInteractor(webService: webService)
		let router = ComicDetailsScreenRouter()
		let presenter = ComicDetailsScreenPresenter(
			view: view,
			interactor: interactor,
			router: router,
			comicModel: comicModel
		)
		view.presenter = presenter
		return view
	}
	
}
