import UIKit

final class TableViewComicCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!
	
	func configure(viewModel: TableViewRowViewModel) -> TableViewComicCell {
		label.text = viewModel.message
		return self
	}
	
	static func loadXIB() -> TableViewComicCell? {
		guard let view = UINib(nibName: "TableViewComicCell", bundle: .main)
			.instantiate(withOwner: self, options: nil)
			.first
			as? TableViewComicCell
			else { return nil }
		
		return view
	}
	
}
