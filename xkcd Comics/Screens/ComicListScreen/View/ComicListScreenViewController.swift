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
	}
	
	// MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 0
	}
	
	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "TableViewLoadingCell",
			for: indexPath
		)
		
		return cell
	}
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// TODO
	}
	
	// MARK: - UITableViewDataSourcePrefetching
	
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		presenter?.prefetch(indexPaths: indexPaths)
	}
}
