import SwiftUI
import AdComData

struct GameAreaView: View {
	@EnvironmentObject var playerManager: PlayerManager
	
	let area: GameArea
	let gameModel: SaveGameModel?
	
	var body: some View {
		NavigationView {
			ZStack {
				((
					gameModel.map { AnyView(SaveInfoView(gameModel: $0)) }
						?? AnyView(Text("No data loaded yet!"))
				))
					.opacity(playerManager.isLoadingModel ? 0.25 : 1)
				
				ActivityIndicator(isAnimating: playerManager.isLoadingModel, style: .large)
			}
			.navigationBarTitle(area.name)
			.navigationBarItems(
				trailing: Button(
					action: playerManager.loadGameModel
				) {
					Image(systemName: "arrow.clockwise")
						.frame(width: 44, height: 44)
				}
				.disabled(!playerManager.canLoadModel)
			)
		}
		.tabItem {
			Image(systemName: "\(area.name.first!.lowercased()).square.fill")
			Text(area.name)
		}
	}
}

enum GameArea: String, Identifiable, CaseIterable {
	case motherland
	case event
	
	var id: String { rawValue }
	
	var name: String {
		switch self {
		case .motherland:
			return "Motherland"
		case .event:
			return "Event"
		}
	}
}

extension UserData {
	func model(for area: GameArea) -> SaveGameModel? {
		switch area {
		case .motherland:
			return motherlandGameModel
		case .event:
			return eventGameModel
		}
	}
}

#if DEBUG
struct GameAreaView_Previews: PreviewProvider {
    static var previews: some View {
		GameAreaView(
			area: .motherland,
			gameModel: .example
		)
    }
}
#endif
