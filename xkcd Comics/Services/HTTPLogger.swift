import Foundation

final class HTTPLogger {
	private var dateFormatter: ISO8601DateFormatter
	private var simpleLog: Bool
	private var redactableHeaders: [String]
	private var redactHeaders: Bool
	private var hideBody: Bool
	private var prettyPrintBody: Bool
	
	// MARK: - Public functions
	
	init(
		simpleLog: Bool,
		redactableHeaders: [String],
		redactHeaders: Bool,
		hideBody: Bool,
		prettyPrintBody: Bool
	) {
		let dateFormatter = ISO8601DateFormatter()
		
		dateFormatter.formatOptions = [
			.withFullDate,
			.withDashSeparatorInDate,
			.withFullTime,
			.withFractionalSeconds
		]
		
		self.dateFormatter = dateFormatter
		self.simpleLog = simpleLog
		self.redactableHeaders = redactableHeaders
		self.redactHeaders = redactHeaders
		self.hideBody = hideBody
		self.prettyPrintBody = prettyPrintBody
	}
	
	func intercept(request: inout URLRequest) {
		let now = Date()
		let requestMethod = request.httpMethod ?? "NO-OP"
		let requestUrl = request.url?.absoluteString ?? "NO URL"
		let requestHeaders = extractHeaderString(from: request.allHTTPHeaderFields as [String: AnyObject]?)
		let requestBody = extractBodyString(from: request.httpBody)
		
		var logMessage = "\n"
		logMessage += dateFormatter.string(from: now) + ": REQUEST \n"
		logMessage += "--> \(requestMethod) \(requestUrl) \n"
		
		if simpleLog == false {
			logMessage += "\(requestHeaders) \n"
			logMessage += "\(requestBody) \n"
		}
		
		logMessage += "--> END \(requestMethod)"
		
		print(logMessage)
	}
	
	func intercept(data: Data?, response: HTTPURLResponse, error: Error?) throws {
		let now = Date()
		let statusCode = response.statusCode
		let statusString = HTTPURLResponse.localizedString(forStatusCode: statusCode).capitalized
		let url = response.url?.absoluteString ?? "NO URL"
		let headers = extractHeaderString(from: response.allHeaderFields as? [String: AnyObject])
		let body = extractBodyString(from: data)
		
		var logMessage = "\n"
		logMessage += dateFormatter.string(from: now) + ": RESPONSE \n"
		logMessage += "<-- \(statusCode) \(statusString) \(url)\n"
		logMessage += "\(headers)\n"
		logMessage += "\(body)\n"
		
		if let error = error as NSError? {
			let description = error.localizedDescription
			let reason = error.localizedFailureReason ?? "NO REASON"
			let suggestion = error.localizedRecoverySuggestion ?? "NO SUGGESTION"
			
			logMessage += "Error! Description: '\(description)', Reason: '\(reason)', suggestion: '\(suggestion)'\n"
		}
		
		logMessage += "<-- END HTTP"
		
		print(logMessage)
	}
	
	// MARK: - Private functions
	
	private func extractHeaderString(from headers: [String: AnyObject]?) -> String {
		guard let headers = headers else { return "NO HEADERS" }
		
		if redactHeaders {
			let redactedHeaders = redactableHeaders.map { $0.lowercased() }
			return headers
				.map { redactedHeaders.contains($0.key.lowercased()) ? ($0.key, "<REMOVED>") : ($0.key, "\($0.value)") }
				.map { "\($0.0): \($0.1)" }
				.joined(separator: "\n")
		} else {
			return headers
				.map { "\($0.0): \($0.1)" }
				.joined(separator: "\n")
		}
	}
	
	private func extractBodyString(from data: Data?) -> String {
		guard hideBody == false else { return "Body: <REMOVED>" }
		
		var body = "NO BODY"
		
		if let data = data {
			if prettyPrintBody,
			   let jsonObject = try? JSONSerialization.jsonObject(
					with: data,
					options: JSONSerialization.ReadingOptions.allowFragments
				),
				let jsonData = try? JSONSerialization.data(
					withJSONObject: jsonObject,
					options: JSONSerialization.WritingOptions.prettyPrinted
				),
				let json = String(data: jsonData, encoding: .utf8)
			{
				body = json
			} else if let json = String(data: data, encoding: .utf8) {
				body = json
			}
		}
		
		return "Body: \n\(body)"
		
	}
	
}
