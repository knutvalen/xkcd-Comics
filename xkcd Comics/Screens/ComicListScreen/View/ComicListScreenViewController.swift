import UIKit

final class ComicListScreenViewController:
	UIViewController,
	ComicListScreenViewType,
	UITableViewDataSource,
	UITableViewDelegate,
	UITableViewDataSourcePrefetching
{
	var presenter: ComicListScreenPresenterType?
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: - UIViewController
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		presenter?.viewDidAppear()
		
		tableView.backgroundColor = .clear
		
		tableView.register(
			UINib(
				nibName: "TableViewLoadingCell",
				bundle: .main
			),
			forCellReuseIdentifier: "TableViewLoadingCell"
		)
		
		tableView.register(
			UINib(
				nibName: "TableViewComicCell",
				bundle: .main
			),
			forCellReuseIdentifier: "TableViewComicCell"
		)
	}
	
	// MARK: - ComicListScreenViewType
	
	func refresh() {
		tableView.reloadData()
	}
	
	// MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.getNumberOfRowsInSection(section) ?? 0
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return presenter?.getViewModels().count ?? 0
	}
	
	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		if let viewModel = presenter?.getViewModel(for: indexPath) {
			if let cell = tableView.dequeueReusableCell(
				withIdentifier: "TableViewComicCell",
				for: indexPath
			) as? TableViewComicCell {
				return cell.configure(viewModel: viewModel)
			}
		}
		
		return tableView.dequeueReusableCell(
			withIdentifier: "TableViewLoadingCell",
			for: indexPath
		)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if presenter?.getViewModel(for: indexPath) == nil {
			return CGFloat(80)
		}
		
		return UITableView.automaticDimension
	}
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let viewModel = presenter?.getSectionViewModel(for: section),
		   viewModel.rows.count > 0,
		   let sectionHeader = TableViewSectionHeader.loadXIB(viewModel: viewModel)
		{
			return sectionHeader
		}
		
		return UIView(frame: .zero)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard let sectionHeader = self.tableView(tableView, viewForHeaderInSection: section)
			as? TableViewSectionHeader
			else { return CGFloat() }
		
		let optimalSize = sectionHeader
			.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		
		return optimalSize.height
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter?.didSelectTableViewCell(at: indexPath)
	}
	
	// MARK: - UITableViewDataSourcePrefetching
	
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		presenter?.prefetch(indexPaths: indexPaths)
	}
}
