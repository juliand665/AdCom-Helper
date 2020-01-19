import Foundation
import FlatBuffers
import Combine

public extension Client {
	func getUserData() -> AnyPublisher<RawUserData, Error> {
		send(GetUserData())
	}
}

private struct GetUserData: Request {
	let requestURL = "GetUserData"
	
	typealias Response = RawUserData
	
	private enum CodingKeys: CodingKey {} // don't code anything
}

public struct RawUserData: Decodable {
	public var dataVersion: Int
	var data: Contents

	public func decoded() -> UserData {
		.init(
			dataVersion: dataVersion,
			sharedGameModel: data.sharedGameModel.decoded(),
			motherlandGameModel: data.motherlandGameModel.decoded(),
			eventGameModel: data.eventGameModel?.decoded()
		)
	}
	
	struct Contents: Decodable {
		var sharedGameModel: RawGameModel
		var motherlandGameModel: RawGameModel
		var eventGameModel: RawGameModel?
		
		struct RawGameModel: Decodable {
			var data: Data // base64-encoded
			var lastUpdated: Date
			
			func decoded<M>() -> M where M: GameModel {
				M(from: ByteBuffer(data: data), lastUpdated: lastUpdated)
			}
			
			private enum CodingKeys: String, CodingKey {
				case data = "Value"
				case lastUpdated = "LastUpdated"
			}
		}
		
		private enum CodingKeys: String, CodingKey {
			case sharedGameModel = "sharedGameModel"
			case motherlandGameModel = "gameModel"
			case eventGameModel = "gameModelLte"
		}
	}
	
	private enum CodingKeys: String, CodingKey {
		case dataVersion = "DataVersion"
		case data = "Data"
	}
}

public struct UserData: Codable {
	public var dataVersion: Int
	
	public var sharedGameModel: SharedGameModel
	public var motherlandGameModel: SaveGameModel
	public var eventGameModel: SaveGameModel?
}

#if DEBUG
public extension UserData {
	static let example = UserData(
		dataVersion: 42,
		sharedGameModel: .example,
		motherlandGameModel: .example,
		eventGameModel: .example
	)
}
#endif
