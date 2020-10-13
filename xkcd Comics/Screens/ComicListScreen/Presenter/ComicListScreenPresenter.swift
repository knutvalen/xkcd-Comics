import Foundation

final class ComicListScreenPresenter: ComicListScreenPresenterType {
	
	private var view: ComicListScreenViewType
	private var interactor: ComicListScreenInteractorType
	private var router: ComicListScreenRouterType
	private var comicModelEntity: ComicModel?
	
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
			if let data = data,
			   let entity = try? JSONDecoder().decode(ComicModel.self, from: data)
			{
				self.comicModelEntity = entity
			}
		}
	}
	
	func prefetch(indexPaths: [IndexPath]) {
		// TODO
	}
	
	func getViewModel() -> TableViewRowViewModel? {
		return nil
	}
	
	func getViewModels() -> [TableViewSectionViewModel] {
		return []
	}
	
	func getSectionViewModel(for section: Int) -> TableViewSectionViewModel? {
		return nil
	}
	
	func didSelectTableViewCell(at indexPath: IndexPath) {
		// TODO
	}
	
}
