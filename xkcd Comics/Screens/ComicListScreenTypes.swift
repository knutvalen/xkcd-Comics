import Foundation

protocol ComicListScreenViewType {
	
}

protocol ComicListScreenInteractorType {
	func getComic(
		comicNumber: Int,
		completionHandler: @escaping (Data?, WebServiceError?) -> Void
	)
}

protocol ComicListScreenPresenterType {
	func viewDidAppear()
	func prefetch(indexPaths: [IndexPath])
	func getViewModel() -> TableViewRowViewModel?
	func getViewModels() -> [TableViewSectionViewModel]
	func getSectionViewModel(for section: Int) -> TableViewSectionViewModel?
	func didSelectTableViewCell(at indexPath: IndexPath)
}

protocol ComicListScreenRouterType {
	
}
