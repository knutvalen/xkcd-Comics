import Foundation

final class ComicListScreenPresenter: ComicListScreenPresenterType {
	private var view: ComicListScreenViewType
	private var interactor: ComicListScreenInteractorType
	private var router: ComicListScreenRouterType
	private var isLoading: [Int: Bool]
	private var totalNumberOfComics: Int?
	
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
		isLoading = [:]
		buildViewModels()
		view.refresh()
	}
	
	private func buildViewModels() {
		let sortedComicModels = comicModels.sorted(by: { (firstComic, secondComic) -> Bool in
			guard let firstComicNumber = firstComic.number,
				let secondComicNumber = secondComic.number
				else { return false }
			
			return firstComicNumber > secondComicNumber
		})
		
		var titlesSection = TableViewSectionViewModel(title: "Titles", rows: [])
		
		for comic in sortedComicModels {
			guard let title = comic.title,
				let number = comic.number
				else { continue }
			
			titlesSection.rows.append(
				TableViewRowViewModel(ID: number, message: title)
			)
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
				self.totalNumberOfComics = latestComicNumber
				
				// load the latest comics
				for i in 0 ..< 30 {
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
		let titlesSection = viewModels.first(where: { sectionViewModel -> Bool in
			return sectionViewModel.title.elementsEqual("Titles")
		})
		
		guard let totalNumberOfComics = totalNumberOfComics,
			let lastViewModelID = titlesSection?.rows.last?.ID
			else { return }
		
		for indexPath in indexPaths {
			guard indexPath.section == 0 else { continue }
			let comicNumber = totalNumberOfComics - indexPath.row
			
			if comicNumber < lastViewModelID {
				if isLoading[comicNumber] == true { continue }
				print("prefetch comicNumber " + comicNumber.description)
				isLoading[comicNumber] = true
				
				interactor.getComic(comicNumber: comicNumber) { (data, error) in
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
	
	func getViewModel(for indexPath: IndexPath) -> TableViewRowViewModel? {
		if viewModels.count >= indexPath.section {
			if indexPath.section < viewModels.count {
				let section = viewModels[indexPath.section]
				
				if section.rows.endIndex > indexPath.row {
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
		guard let viewModel = getViewModel(for: indexPath) else { return }
		
		let comic = comicModels.first(where: { comic -> Bool in
			return comic.number == viewModel.ID
		})
		
		if let comic = comic {
			router.navigateToComicDetailsScreen(from: view, comicModel: comic)
		}
	}
	
	func getNumberOfRowsInSection(_ section: Int) -> Int {
		guard section == 0,
			let totalNumberOfComics = totalNumberOfComics
			else { return 0 }
		
		return totalNumberOfComics
	}
	
}
