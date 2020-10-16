import UIKit

final class ComicDetailsScreenViewController:
	UIViewController,
	ComicDetailsScreenViewType
{
	var presenter: ComicDetailsScreenPresenterType?
	@IBOutlet weak var imageView: UIImageView!
	
	// MARK: - UIViewController
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter?.viewWillAppear()
	}
	
	// MARK: - ComicDetailsScreenViewType
	
	func refresh() {
		
	}
	
	func setLoading(_ loading: Bool) {
		
	}
	
}
