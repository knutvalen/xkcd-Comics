import UIKit

final class TableViewLoadingCell: UITableViewCell {
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	func configure() -> TableViewLoadingCell {
		activityIndicator.startAnimating()
		return self
	}
	
}
