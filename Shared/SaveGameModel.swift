import Foundation

struct SaveGameModel {
	var airdropServiceProgress: AirdropServiceProgress
	
	init(_ raw: AdCom.SaveGameModel) {
		airdropServiceProgress = .init(raw.airDropServiceProgress!)
	}
}

struct AirdropServiceProgress {
	var nextAdReset: Date
	var nextClaimCountReset: Date
	var nextAirdrop: Date
	var claimCount: Int
	var progresses: [Progress]
	
	init(_ raw: AdCom.AirDropServiceProgress) {
		nextAdReset = BinaryDate(ticks: raw.nextAdResetData).date
		nextClaimCountReset = BinaryDate(ticks: raw.nextClaimCountResetData).date
		nextAirdrop = BinaryDate(ticks: raw.nextAirDropDate).date
		claimCount = Int(raw.claimCount)
		
		progresses = (0..<raw.airDropProgressCount)
			.map(raw.airDropProgress(at:))
			.map { Progress($0!) }
	}
	
	struct Progress {
		var watchCount: Int
		var watchCountID: Int
		
		init(_ raw: AdCom.AirDropModelProgress) {
			watchCount = Int(raw.airDropWatchCount)
			watchCountID = Int(raw.airDropWatchCountId)
		}
	}
}
