import UIKit

final class ComicListScreenRouter: ComicListScreenRouterType {
	static func create() -> UIViewController? {
		let viewController = UIStoryboard(name: "ComicListScreenStoryboard", bundle: .main)
			.instantiateViewController(identifier: "ComicListScreenViewController")
		
		guard let view = viewController as? ComicListScreenViewController,
			let webService = Constants.App?.webService
			else { return nil }
		
		let interactor = ComicListScreenInteractor(webService: webService)
		let router = ComicListScreenRouter()
		let presenter = ComicListScreenPresenter(view: view, interactor: interactor, router: router)
		view.presenter = presenter
		return view
	}
	
	func navigateToComicDetailsScreen(
		from view: ComicListScreenViewType,
		comicModel: ComicModel
	) {
		guard let comicDetailsScreen = ComicDetailsScreenRouter.create(comicModel: comicModel) else { return }
		(view as? UIViewController)?.navigationController?
			.pushViewController(comicDetailsScreen, animated: true)
	}
	
}
