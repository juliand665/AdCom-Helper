import SwiftUI

private func line<V: View>(label: String, _ value: V) -> AnyView {
	AnyView(HStack {
		Text("\(label):")
		Spacer()
		value
	})
}

struct SaveInfoView: View {
	let gameModel: SaveGameModel
	
    var body: some View {
		let airdropInfo = gameModel.airdropServiceProgress
		
		return List {
			Section(header: Text("General")) {
				line(label: "Last updated", TimeView(gameModel.lastUpdated))
			}
			
			Section(header: Text("Airdrops")) {
				line(label: "Next airdrop", TimeView(airdropInfo.nextAirdrop))
				line(label: "Claim count", Text(verbatim: "\(airdropInfo.claimCount)"))
				line(label: "Next claim count reset", TimeView(airdropInfo.nextClaimCountReset))
				line(label: "Next ad reset", TimeView(airdropInfo.nextAdReset))
				ForEach(airdropInfo.progresses, id: \.id.rawValue) { progress in
					line(label: "Claimed \(progress.id) ads", Text("\(progress.watchCount)"))
				}
			}
		}
		.listStyle(GroupedListStyle())
	}
}

struct SaveInfoView_Previews: PreviewProvider {
	static let exampleModel = SaveGameModel(
		lastUpdated: Date(),
		airdropServiceProgress: AirdropServiceProgress(
			nextAdReset: Date(timeIntervalSinceNow: 3600),
			nextClaimCountReset: Date(timeIntervalSinceNow: 1800),
			nextAirdrop: Date(timeIntervalSinceNow: 30),
			claimCount: 5,
			progresses: [
				.init(watchCount: 3, id: .comrades),
				.init(watchCount: 5, id: .science),
				.init(watchCount: 1, id: .other(42)),
			]
		)
	)
	
    static var previews: some View {
        SaveInfoView(gameModel: exampleModel)
    }
}
