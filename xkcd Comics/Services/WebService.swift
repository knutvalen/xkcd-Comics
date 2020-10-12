import Foundation

final class WebService {
	var httpService: HTTPService
	
	// MARK: - Public functions
	
	init(httpService: HTTPService) {
		self.httpService = httpService
	}
	
	func request(
		path: String,
		method: HTTPMethod,
		headers: [String: String]?,
		parameters: [String: Any]?,
		body: Data?,
		completion: @escaping (Result<Data?, WebServiceError>) -> Void
	) {
		switch method {
		case .get:
			get(path: path, headers: headers, parameters: parameters, completion: completion)
			
		default:
			break
		}
	}
	
	// MARK: - Private functions
	
	private func get(
		path: String,
		headers: [String: String]? = nil,
		parameters: [String: Any]? = nil,
		completion: @escaping (Result<Data?, WebServiceError>) -> Void
	) {
		httpService.get(path: path, parameters: parameters, headers: headers) {
			(result: Result<Data?, WebServiceError>) in
			DispatchQueue.main.async {
				switch result {
				case let .success(data):
					completion(.success(data))
					
				case let .failure(error):
					completion(.failure(error))
				}
			}
		}
	}
	
}
