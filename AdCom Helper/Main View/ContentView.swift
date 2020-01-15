import SwiftUI
import Combine
import HandyOperators

struct ContentView: View {
	@EnvironmentObject var playerManager: PlayerManager
	@EnvironmentObject var timeProvider: TimeProvider
	@State var gameModel: SaveGameModel?
	@State var isLoadingModel = false
	
	var body: some View {
		VStack(spacing: 20) {
			TimeView(timeProvider.time, showAsRelative: false)
				.font(.largeTitle)
				.opacity(0.5)
				.padding()
			
			ZStack {
				((
					gameModel.map { AnyView(SaveInfoView(gameModel: $0)) }
						?? AnyView(Text("No data loaded yet!"))
				))
					.opacity(isLoadingModel ? 0.25 : 1)
				ActivityIndicator(isAnimating: $isLoadingModel, style: .large)
			}
			
			Spacer()
			
			statusView
				.padding()
		}
	}
	
	var statusView: AnyView {
		switch playerManager.state {
		case .loading:
			return AnyView(
				Text("Loading…")
			)
		case .signedIn:
			return AnyView(
				VStack(spacing: 8) {
					Text("Signed in")
					Button("Load Data", action: loadGameModel)
						.onAppear(perform: loadGameModel)
						.disabled(isLoadingModel)
				}
			)
		case .signInRequested(let viewController):
			return AnyView(
				NavigationLink(
					"Sign in Requested!",
					destination: ControllerView(viewController)
				)
			)
		case .error(let error):
			return AnyView(
				Text("Error while signing in: \(error.localizedDescription)")
			)
		}
	}
	
	@State var request: AnyCancellable? // TODO: not sure if this is the right way to do it
	
	func loadGameModel() {
		print("loading…")
		isLoadingModel = true
		request = playerManager.client!.send(GetUserData())
			.map { $0.data.motherlandGameModel.decode() }
			.sink(
				receiveCompletion: ({
					self.isLoadingModel = false
					switch $0 {
					case .finished:
						break
					case .failure(let error):
						self.gameModel = nil
						print("error while loading game model:", error)
					}
				}),
				receiveValue: ({
					self.gameModel = $0
				})
		)
	}
}

extension AirdropServiceProgress.Progress.ID: CustomStringConvertible {
	var description: String {
		switch self {
		case .comrades:
			return "comrade"
		case .science:
			return "science"
		case .other(let id):
			return "<unknown id \(id)>"
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ContentView()
			ContentView(isLoadingModel: true)
		}
		.environmentObject(PlayerManager(for: .local))
		.environmentObject(TimeProvider())
	}
}

