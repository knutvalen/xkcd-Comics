import UIKit

final class TableViewSectionHeader: UIView {
	@IBOutlet weak var label: UILabel!
	
	static func loadXIB(viewModel: TableViewSectionViewModel) -> TableViewSectionHeader? {
		guard let view = UINib(nibName: "TableViewSectionHeader", bundle: .main)
			.instantiate(withOwner: self, options: nil)
			.first
			as? TableViewSectionHeader
			else { return nil }
		
		view.label.text = viewModel.title
		return view
	}
	
}
