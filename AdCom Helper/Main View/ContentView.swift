import SwiftUI
import AdComData
import HandyOperators

struct ContentView: View {
	@EnvironmentObject var playerManager: PlayerManager
	@EnvironmentObject var timeProvider: TimeProvider
	
	var body: some View {
		TabView {
			ForEach(GameArea.allCases) { area in
				GameAreaView(
					area: area,
					gameModel: self.playerManager.userData?.model(for: area)
				)
			}
			
			accountView.tabItem {
				Image(systemName: "person.crop.circle")
				Text("Account")
			}
		}
		.edgesIgnoringSafeArea(.top)
	}
	
	var accountView: AnyView {
		switch playerManager.state {
		case .loading:
			return AnyView(
				Text("Loading…")
			)
		case .signedIn:
			return AnyView(
				VStack(spacing: 8) {
					Text("Signed in")
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
}

extension AirdropInfo.Progress.ID: CustomStringConvertible {
	public var description: String {
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
			//ContentView(userData: .example) gotta figure out a way to test this
			ContentView()
		}
		.environmentObject(PlayerManager(for: .local))
		.environmentObject(TimeProvider())
	}
}
