import SwiftUI
import AdComData

struct SaveInfoView: View {
	let gameModel: SaveGameModel
	
    var body: some View {
		let airdropInfo = gameModel.airdropInfo
		
		return List {
			Section(header: Text("META")) {
				line(label: "Last updated", gameModel.lastUpdated)
				line(label: "Save time", gameModel.saveTime)
				
				line(label: "Data version", gameModel.dataVersion)
				line(label: "Save version", gameModel.saveVersion)
			}
			
			Section(header: Text("GENERAL")) {
				line(label: "Rank", gameModel.rank)
				line(label: "Last Supreme", gameModel.lastEarnedSupremeID ?? "<none yet>")
			}
			
			Section(header: Text("AIRDROPS")) {
				line(label: "Next airdrop", airdropInfo.nextAirdrop)
				line(label: "Claim count", airdropInfo.claimCount)
				line(label: "Next claim count reset", airdropInfo.nextClaimCountReset)
				line(label: "Next ad reset", airdropInfo.nextAdReset)
				ForEach(airdropInfo.progresses, id: \.id.rawValue) { progress in
					line(label: "Claimed \(progress.id) ads", progress.watchCount)
				}
			}
		}
		.listStyle(GroupedListStyle())
	}
}

private func line<V: View>(label: String, _ value: V) -> AnyView {
	AnyView(HStack {
		Text("\(label):")
		Spacer()
		value
	})
}

private func line(label: String, _ value: Date) -> AnyView {
	line(label: label, TimeView(value))
}

private func line(label: String, _ value: String) -> AnyView {
	line(label: label, Text(verbatim: value))
}

private func line(label: String, _ value: Int) -> AnyView {
	line(label: label, Text(verbatim: "\(value)"))
}

#if DEBUG
struct SaveInfoView_Previews: PreviewProvider {
    static var previews: some View {
		SaveInfoView(gameModel: .example)
			.environmentObject(TimeProvider())
    }
}
#endif
