import UIKit

final class ComicListScreenRouter: ComicListScreenRouterType {
	static func create() -> UIViewController? {
		let view = UIStoryboard(name: "ComicListScreenStoryboard", bundle: .main)
			.instantiateViewController(identifier: "ComicListScreenViewController")
		
		return view
	}
	
}
