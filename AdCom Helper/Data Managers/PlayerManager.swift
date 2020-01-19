import GameKit
import Combine
import AdComData

final class PlayerManager: ObservableObject {
	@Published private(set) var state = State.loading {
		didSet {
			if state.playerID != oldValue.playerID {
				client = state.playerID.map(Client.init(playerID:))
			}
		}
	}
	
	@Published private(set) var client: Client? {
		didSet { loadGameModel() }
	}
	
	@Published private(set) var userData: UserData?
	
	@Published private(set) var isLoadingModel = false
	private var request: AnyCancellable? {
		didSet { isLoadingModel = request != nil }
	}
	
	var canLoadModel: Bool {
		!isLoadingModel && client != nil
	}
	
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
	
	func loadGameModel() {
		guard let client = client else { return }
		
		isLoadingModel = true
		request?.cancel()
		request = client.getUserData().receive(on: RunLoop.main).sink(
			receiveCompletion: ({
				self.request = nil
				switch $0 {
				case .finished:
					break
				case .failure(let error):
					self.userData = nil
					print("error while loading game model:", error)
				}
			}),
			receiveValue: ({
				self.userData = $0.decoded()
			})
		)
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
