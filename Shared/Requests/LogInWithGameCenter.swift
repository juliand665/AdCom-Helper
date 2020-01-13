import Foundation

struct LogInWithGameCenter: Request {
	let requestURL = "LoginWithGameCenter"
	let requiresAuthentication = false
	
	let playerID: String
	let titleID = playFabTitleID
	let createAccount = false
	
	struct Response: Decodable {
		var playFabID: String
		var sessionTicket: String
		
		private enum CodingKeys: String, CodingKey {
			case playFabID = "PlayFabId"
			case sessionTicket = "SessionTicket"
		}
	}
	
	private enum CodingKeys: String, CodingKey {
		case playerID = "PlayerId"
		case titleID = "TitleId"
		case createAccount = "CreateAccount"
	}
}
