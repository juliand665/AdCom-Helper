import Foundation
import HandyOperators

protocol Request: Encodable {
	associatedtype Response: Decodable
	
	var requestURL: String { get }
	var requiresAuthentication: Bool { get }
}

extension Request {
	var requiresAuthentication: Bool { true }
}

struct ServerResponse<Contents>: Decodable where Contents: Decodable {
	var code: Int
	var status: String
	var contents: Contents?
	
	private enum CodingKeys: String, CodingKey {
		case code = "code"
		case status = "status"
		case contents = "data"
	}
}
