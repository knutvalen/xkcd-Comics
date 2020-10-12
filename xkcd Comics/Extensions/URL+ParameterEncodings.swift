import Foundation

// Source: https://github.com/Alamofire/Alamofire/blob/master/Source/ParameterEncoding.swift
extension URL {
	
	// MARK: - Public
	
	func encoded(with parameters: [String: Any]?) -> URL {
		guard let parameters = parameters else { return self }
		guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return self }
		let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
		urlComponents.percentEncodedQuery = percentEncodedQuery
		return urlComponents.url ?? self
	}
	
	// MARK: - Private
	
	/// Configures how `Array` parameters are encoded.
	///
	/// - brackets:        An empty set of square brackets is appended to the key for every value.
	///                    This is the default behavior.
	/// - noBrackets:      No brackets are appended. The key is encoded as is.
	private enum ArrayEncoding {
		case brackets, noBrackets
		
		func encode(key: String) -> String {
			switch self {
			case .brackets:
				return "\(key)[]"
			case .noBrackets:
				return key
			}
		}
	}
	
	/// Configures how `Bool` parameters are encoded.
	///
	/// - numeric:         Encode `true` as `1` and `false` as `0`. This is the default behavior.
	/// - literal:         Encode `true` and `false` as string literals.
	private enum BoolEncoding {
		case numeric, literal
		
		func encode(value: Bool) -> String {
			switch self {
			case .numeric:
				return value ? "1" : "0"
			case .literal:
				return value ? "true" : "false"
			}
		}
	}
	
	/// Creates percent-escaped, URL encoded query string components
	/// from the given key-value pair using recursion.
	///
	/// - parameter key:   The key of the query component.
	/// - parameter value: The value of the query component.
	///
	/// - returns: The percent-escaped, URL encoded query string
	/// components.
	private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
		var components: [(String, String)] = []
		let boolEncoding: BoolEncoding = .numeric
		let arrayEncoding: ArrayEncoding = .brackets
		if let dictionary = value as? [String: Any] {
			for (nestedKey, value) in dictionary {
				components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
			}
		}
		else if let array = value as? [Any] {
			for value in array {
				components += queryComponents(fromKey: arrayEncoding.encode(key: key), value: value)
			}
		}
		else if let value = value as? NSNumber {
			if value.isBool {
				components.append((escape(key), escape(boolEncoding.encode(value: value.boolValue))))
			}
			else {
				components.append((escape(key), escape("\(value)")))
			}
		}
		else if let bool = value as? Bool {
			components.append((escape(key), escape(boolEncoding.encode(value: bool))))
		}
		else {
			components.append((escape(key), escape("\(value)")))
		}
		
		return components
	}
	
	/// Returns a percent-escaped string following RFC 3986 for a
	/// query string key or value.
	///
	/// RFC 3986 states that the following characters are "reserved"
	/// characters.
	///
	/// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
	/// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ","
	/// , ";", "="
	///
	/// In RFC 3986 - Section 3.4, it states that the "?" and "/"
	/// characters should not be escaped to allow query strings to
	/// include a URL. Therefore, all "reserved" characters with the
	/// exception of "?" and "/" should be percent-escaped in the
	/// query string.
	///
	/// - parameter string: The string to be percent-escaped.
	///
	/// - returns: The percent-escaped string.
	private func escape(_ string: String) -> String {
		return string.addingPercentEncodingQueryParameter()
	}
	
	private func query(_ parameters: [String: Any]) -> String {
		var components: [(String, String)] = []
		
		for key in parameters.keys.sorted(by: <) {
			let value = parameters[key]!
			components += queryComponents(fromKey: key, value: value)
		}
		return components.map { "\($0)=\($1)" }.joined(separator: "&")
	}
}

extension NSNumber {
	fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
