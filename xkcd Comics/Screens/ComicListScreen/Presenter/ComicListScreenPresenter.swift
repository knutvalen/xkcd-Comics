import Foundation

final class ComicListScreenPresenter: ComicListScreenPresenterType {
	private var view: ComicListScreenViewType
	private var interactor: ComicListScreenInteractorType
	private var router: ComicListScreenRouterType
	private var isLoading: [Int: Bool]
	
	// MARK: - Entities
	
	private var comicModels: [ComicModel]
	
	// MARK: - View models
	
	private var viewModels: [TableViewSectionViewModel]
	
	// MARK: - Public functions
	
	init(
		view: ComicListScreenViewType,
		interactor: ComicListScreenInteractorType,
		router: ComicListScreenRouterType
	) {
		self.view = view
		self.interactor = interactor
		self.router = router
		comicModels = []
		viewModels = []
		isLoading = [:]
	}
	
	// MARK: - Private functions
	
	private func onLoaded(comicNumber: Int) {
		isLoading[comicNumber] = false
		if isLoading.values.contains(true) { return }
		buildViewModels()
		view.refresh()
	}
	
	private func buildViewModels() {
		let sortedComicModels = comicModels.sorted(by: { $0.number! > $1.number! })// TODO remove !
		var titlesSection = TableViewSectionViewModel(title: "Titles", rows: [])
		
		for comic in sortedComicModels {
			guard let title = comic.title else { continue }
			titlesSection.rows.append(TableViewRowViewModel(message: title))
		}
		
		self.viewModels = [titlesSection]
	}
	
	// MARK: - ComicListScreenPresenterType
	
	func viewDidAppear() {
		// reset data source
		comicModels = []
		buildViewModels()
		
		interactor.getLatestComic() { (data, error) in
			if let data = data,
			   let entity = try? JSONDecoder().decode(ComicModel.self, from: data),
			   let latestComicNumber = entity.number
			{
				// load 50 latest comics
				for i in 0 ..< 50 {
					let comicNumber = latestComicNumber - i
					self.isLoading[comicNumber] = true
					
					self.interactor.getComic(comicNumber: comicNumber) { (data, error) in
						if let data = data,
						   let entity = try? JSONDecoder().decode(ComicModel.self, from: data),
						   let comicNumber = entity.number
						{
							self.comicModels.append(entity)
							self.onLoaded(comicNumber: comicNumber)
						}
					}
				}
			}
		}
	}
	
	func prefetch(indexPaths: [IndexPath]) {
		print("prefetch(indexPaths:) -> " + indexPaths.debugDescription)
		// TODO
	}
	
	func getViewModel(for indexPath: IndexPath) -> TableViewRowViewModel? {
		if viewModels.count >= indexPath.section {
			if indexPath.section < viewModels.count {
				let section = viewModels[indexPath.section]
				
				if section.rows.count >= indexPath.row {
					return section.rows[indexPath.row]
				}
			}
		}
		
		return nil
	}
	
	func getViewModels() -> [TableViewSectionViewModel] {
		return viewModels
	}
	
	func getSectionViewModel(for section: Int) -> TableViewSectionViewModel? {
		if viewModels.count > section {
			return viewModels[section]
		}
		
		return nil
	}
	
	func didSelectTableViewCell(at indexPath: IndexPath) {
		// TODO
	}
	
}
