import Foundation
import UIKit

protocol ComicListScreenViewType {
	func refresh()
	func setLoading(_ loading: Bool)
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
	func viewDidLoad()
	func prefetch(indexPaths: [IndexPath])
	func getViewModel(for indexPath: IndexPath) -> TableViewRowViewModel?
	func getViewModels() -> [TableViewSectionViewModel]
	func getSectionViewModel(for section: Int) -> TableViewSectionViewModel?
	func didSelectTableViewCell(at indexPath: IndexPath)
	func getNumberOfRowsInSection(_ section: Int) -> Int
	func refresh()
}

protocol ComicListScreenRouterType {
	static func create() -> UIViewController?
	func navigateToComicDetailsScreen(from view: ComicListScreenViewType, comicModel: ComicModel)
}
