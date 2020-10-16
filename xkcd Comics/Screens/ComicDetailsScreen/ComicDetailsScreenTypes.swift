import Foundation
import UIKit

protocol ComicDetailsScreenViewType {
	
}

protocol ComicDetailsScreenPresenterType {
	func viewWillAppear()
}

protocol ComicDetailsScreenRouterType {
	static func create() -> UIViewController?
}
