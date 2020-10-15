import Foundation

final class ComicListScreenInteractor: ComicListScreenInteractorType {
	var webService: WebService
	
	init(webService: WebService) {
		self.webService = webService
	}
	
	func getLatestComic(
		completionHandler: @escaping (Data?, WebServiceError?) -> Void
	) {
		let path = String(format: Constants.BackendAPI.current)
		
		webService.request(
			path: path,
			method: .get,
			headers: nil,
			parameters: nil,
			body: nil
		) { (result: Result<Data?, WebServiceError>) in
			switch result {
			case let .success(data):
				completionHandler(data, nil)
				
			case let .failure(error):
				completionHandler(nil, error)
			}
		}
	}
	
	func getComic(
		comicNumber: Int,
		completionHandler: @escaping (Data?, WebServiceError?) -> Void
	) {
		let path = String(format: Constants.BackendAPI.comicNumber, comicNumber.description)
		
		webService.request(
			path: path,
			method: .get,
			headers: nil,
			parameters: nil,
			body: nil
		) { (result: Result<Data?, WebServiceError>) in
			switch result {
			case let .success(data):
				completionHandler(data, nil)
				
			case let .failure(error):
				completionHandler(nil, error)
			}
		}
	}
	
}
