final class ComicDetailsScreenPresenter: ComicDetailsScreenPresenterType {
	private var view: ComicDetailsScreenViewType
	private var interactor: ComicDetailsScreenInteractorType
	private var router: ComicDetailsScreenRouterType
	
	// MARK: - Public functions
	
	init(
		view: ComicDetailsScreenViewType,
		interactor: ComicDetailsScreenInteractorType,
		router: ComicDetailsScreenRouterType
	) {
		self.view = view
		self.interactor = interactor
		self.router = router
	}
	
	// MARK: - ComicDetailsScreenPresenterType
	
	func viewWillAppear() {
		// TODO
	}
	
}
