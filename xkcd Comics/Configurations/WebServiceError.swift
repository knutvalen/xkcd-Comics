import Foundation

enum WebServiceError: Swift.Error {
	case invalidPath
	case invalidResponse
	case noNetwork
	case requestError(NSError)
	case responseError(httpStatusCode: Int)
}
