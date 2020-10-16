import UIKit

final class ComicDetailsScreenPresenter: ComicDetailsScreenPresenterType {
	private var view: ComicDetailsScreenViewType
	private var interactor: ComicDetailsScreenInteractorType
	private var router: ComicDetailsScreenRouterType
	
	// MARK: - Entities
	
	private var comicModel: ComicModel
	
	// MARK: - View models
	
	var image: UIImage?
	
	// MARK: - Public functions
	
	init(
		view: ComicDetailsScreenViewType,
		interactor: ComicDetailsScreenInteractorType,
		router: ComicDetailsScreenRouterType,
		comicModel: ComicModel
	) {
		self.view = view
		self.interactor = interactor
		self.router = router
		self.comicModel = comicModel
	}
	
	// MARK: - ComicDetailsScreenPresenterType
	
	func viewDidLoad() {
		refresh()
	}
		
	func refresh() {
		guard let image = comicModel.image else { return }
		view.setLoading(true)
		
		interactor.getComicImage(imageUri: image) { (image, error) in
			self.image = image
			self.view.refresh()
			self.view.setLoading(false)
		}
	}
	
}
