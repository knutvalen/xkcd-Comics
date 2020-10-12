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
}

protocol ComicListScreenRouterType {
	
}
