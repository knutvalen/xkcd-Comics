import UIKit

final class ComicDetailsScreenViewController:
	UIViewController,
	ComicDetailsScreenViewType
{
	var presenter: ComicDetailsScreenPresenterType?
	@IBOutlet weak var imageView: UIImageView!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter?.viewDidLoad()
	}
	
	// MARK: - ComicDetailsScreenViewType
	
	func refresh() {
		imageView.image = presenter?.image
	}
	
	func setLoading(_ loading: Bool) {
		
	}
	
}
