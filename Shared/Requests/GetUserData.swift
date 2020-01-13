import Foundation

struct GetUserData: Request {
	let requestURL = "GetUserData"
	
	struct Response: Decodable {
		var dataVersion: Int
		var data: Contents
		
		struct Contents: Codable {
			var sharedGamedModel: GameModel
			var motherlandGameModel: GameModel
			var eventGameModel: GameModel
			
			struct GameModel: Codable {
				var data: Data // base64-encoded
				var lastUpdated: Date
				
				private enum CodingKeys: String, CodingKey {
					case data = "Value"
					case lastUpdated = "LastUpdated"
				}
			}
			
			private enum CodingKeys: String, CodingKey {
				case sharedGamedModel = "sharedGameModel"
				case motherlandGameModel = "gameModel"
				case eventGameModel = "gameModelLte"
			}
		}
		
		private enum CodingKeys: String, CodingKey {
			case dataVersion = "DataVersion"
			case data = "Data"
		}
	}
	
	private enum CodingKeys: CodingKey {} // don't code anything
}
