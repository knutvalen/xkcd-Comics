import UIKit

final class TableViewComicCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!
	
	func configure(viewModel: TableViewRowViewModel) -> TableViewComicCell {
		label.text = viewModel.message
		return self
	}
	
}
