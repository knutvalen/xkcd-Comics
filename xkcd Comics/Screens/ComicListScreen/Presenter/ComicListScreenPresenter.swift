import Foundation

final class ComicListScreenPresenter: ComicListScreenPresenterType {
	private var view: ComicListScreenViewType
	private var interactor: ComicListScreenInteractorType
	private var router: ComicListScreenRouterType
	
	// MARK: - Public functions
	
	init(
		view: ComicListScreenViewType,
		interactor: ComicListScreenInteractorType,
		router: ComicListScreenRouterType
	) {
		self.view = view
		self.interactor = interactor
		self.router = router
	}
	
	// MARK: - ComicListScreenPresenterType
	
	func viewDidAppear() {
		interactor.getComic(comicNumber: 666) { (data, error) in
			// TODO
		}
	}
	
}
