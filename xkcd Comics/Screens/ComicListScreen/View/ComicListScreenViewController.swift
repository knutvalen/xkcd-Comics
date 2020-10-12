import UIKit

final class ComicListScreenViewController:
	UIViewController,
	ComicListScreenViewType
{
	var presenter: ComicListScreenPresenterType?
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		presenter?.viewDidAppear()
	}
}
