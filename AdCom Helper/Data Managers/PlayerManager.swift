import GameKit
import Combine

final class PlayerManager: ObservableObject {
	@Published var state = State.loading {
		didSet {
			if state.playerID != oldValue.playerID {
				client = state.playerID.map(Client.init(playerID:))
			}
		}
	}
	@Published var client: Client?
	
	init(for player: GKLocalPlayer) {
		player.authenticateHandler = { viewController, error in
			if let error = error {
				print("error while authenticating:", error)
				self.state = .error(error)
			} else if let viewController = viewController {
				print("sign in requested!")
				self.state = .signInRequested(viewController)
			} else {
				let playerID = player.deprecatedPlayerID
				print("authenticated as \(playerID)")
				self.state = .signedIn(playerID)
			}
		}
	}
	
	enum State {
		case loading
		case signedIn(_ playerID: String)
		case signInRequested(UIViewController)
		case error(Error)
		
		var playerID: String? {
			switch self {
			case .signedIn(let playerID):
				return playerID
			default:
				return nil
			}
		}
	}
}

// deprecated schmeprecated
private protocol PlayerIDProvider {
	var playerID: String { get }
}

extension GKLocalPlayer: PlayerIDProvider {}

extension GKLocalPlayer {
	var deprecatedPlayerID: String {
		(self as PlayerIDProvider).playerID
	}
}
