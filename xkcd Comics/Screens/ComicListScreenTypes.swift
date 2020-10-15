import Foundation

protocol ComicListScreenViewType {
	func refresh()
}

protocol ComicListScreenInteractorType {
	func getLatestComic(
		completionHandler: @escaping (Data?, WebServiceError?) -> Void
	)
	func getComic(
		comicNumber: Int,
		completionHandler: @escaping (Data?, WebServiceError?) -> Void
	)
}

protocol ComicListScreenPresenterType {
	func viewDidAppear()
	func prefetch(indexPaths: [IndexPath])
	func getViewModel(for indexPath: IndexPath) -> TableViewRowViewModel?
	func getViewModels() -> [TableViewSectionViewModel]
	func getSectionViewModel(for section: Int) -> TableViewSectionViewModel?
	func didSelectTableViewCell(at indexPath: IndexPath)
}

protocol ComicListScreenRouterType {
	
}
