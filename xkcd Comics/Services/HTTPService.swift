import Foundation
import UIKit
import Reachability

final class HTTPService:
	NSObject,
	URLSessionDelegate,
	ReachabilityActionDelegate
{
	private var endpoint: String
	private var httpLogger: HTTPLogger
	private var reachabilityService: ReachabilityService
	private var networkIsReachable: Bool?
	
	private lazy var session: URLSession = {
		let configuration = URLSessionConfiguration.ephemeral
		configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
		configuration.urlCache = nil
		return URLSession(
			configuration: configuration,
			delegate: self,
			delegateQueue: OperationQueue.main
		)
	}()
	
	// MARK: - Public functions
	
	init(endpoint: String, httpLogger: HTTPLogger) {
		self.endpoint = endpoint
		self.httpLogger = httpLogger
		self.reachabilityService = ReachabilityService()
		super.init()
		try? reachabilityService.configure(delegate: self)
	}
	
	func get(
		path: String,
		parameters: [String: Any]? = nil,
		headers: [String: String]? = nil,
		completion: @escaping (Result<Data?, WebServiceError>) -> Void
	) {
		guard let url = url(for: path) else {
			return completion(.failure(.invalidPath))
		}
		
		let request = createRequest(
			url: url.encoded(with: parameters),
			method: .get,
			headers: headers
		)

		perform(
			request: request,
			successCompletion: { statusCode, data in
				if let data = data, data.count > 0 {
					completion(.success(data))
				} else {
					completion(.success(nil))
				}
			},
			errorCompletion: { error in
				completion(.failure(error))
			}
		)
	}
	
	// MARK: - Private functions
	
	private func perform(
		request: URLRequest,
		successCompletion: @escaping ((Int, Data?) -> Void),
		errorCompletion: @escaping ((WebServiceError) -> Void)
	) {
		if networkIsReachable == nil {
			try? reachabilityService.configure(delegate: self)
		}
		
		guard networkIsReachable == true else {
			errorCompletion(.noNetwork)
			return
		}
		
		let task = session.dataTask(with: request) { (data, response, error) in
			if let response = response as? HTTPURLResponse {
				do {
					try self.httpLogger.intercept(data: data, response: response, error: error)
				} catch let interceptError as NSError {
					errorCompletion(.requestError(interceptError))
					return
				}
				
				switch response.statusCode {
				case 200...299:
					successCompletion(response.statusCode, data)
					
				default:
					guard data != nil else {
						return errorCompletion(.invalidResponse)
					}
					
					errorCompletion(.responseError(httpStatusCode: response.statusCode))
				}
			} else if let error = error as NSError? {
				errorCompletion(.requestError(error))
			} else {
				errorCompletion(.invalidResponse)
			}
		}
		
		task.resume()
	}
	
	private func createRequest(
		url: URL,
		method: HTTPMethod,
		headers: [String: String]? = nil,
		body: Data? = nil
	) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.httpBody = body
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		if let headers = headers {
			for (key, value) in headers {
				if request.value(forHTTPHeaderField: key) != nil {
					request.setValue(value, forHTTPHeaderField: key)
				} else {
					request.addValue(value, forHTTPHeaderField: key)
				}
			}
		}
		
		httpLogger.intercept(request: &request)
		
		return request
	}
	
	private func url(for path: String) -> URL? {
		if path.starts(with: "https://") || path.starts(with: "http://") {
			return URL(string: path)
		}
		
		var correctedPath = path
		if endpoint.last == "/" && path.first == "/" {
			correctedPath = String(path.dropFirst())
		} else if endpoint.last != "/" && path.first != "/" {
			correctedPath = "/" + path
		}
		
		return URL(string: endpoint + correctedPath)
	}
	
	// MARK: - ReachabilityActionDelegate
	
	func reachabilityChanged(_ isReachable: Bool) {
		networkIsReachable = isReachable
	}
	
}
