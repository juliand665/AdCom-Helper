import Foundation

struct SaveGameModel {
	var lastUpdated: Date
	
	var airdropServiceProgress: AirdropServiceProgress
}

struct AirdropServiceProgress {
	var nextAdReset: Date
	var nextClaimCountReset: Date
	var nextAirdrop: Date
	var claimCount: Int
	var progresses: [Progress]
	
	struct Progress {
		var watchCount: Int
		var id: ID
		
		enum ID {
			case comrades
			case science
			case other(Int)
			
			var rawValue: Int {
				switch self {
				case .comrades:
					return 10003
				case .science:
					return 10004
				case .other(let value):
					return value
				}
			}
			
			init(_ rawValue: Int) {
				switch rawValue {
				case 10003:
					self = .comrades
				case 10004:
					self = .science
				default:
					self = .other(rawValue)
				}
			}
		}
	}
}

extension SaveGameModel {
	init(_ raw: AdCom.SaveGameModel, lastUpdated: Date) {
		airdropServiceProgress = .init(raw.airDropServiceProgress!)
		self.lastUpdated = lastUpdated
	}
}

extension AirdropServiceProgress {
	init(_ raw: AdCom.AirDropServiceProgress) {
		nextAdReset = BinaryDate(ticks: raw.nextAdResetData).date
		nextClaimCountReset = BinaryDate(ticks: raw.nextClaimCountResetData).date
		nextAirdrop = BinaryDate(ticks: raw.nextAirDropDate).date
		claimCount = Int(raw.claimCount)
		
		progresses = (0..<raw.airDropProgressCount)
			.map(raw.airDropProgress(at:))
			.map { Progress($0!) }
	}
}

extension AirdropServiceProgress.Progress {
	init(_ raw: AdCom.AirDropModelProgress) {
		watchCount = Int(raw.airDropWatchCount)
		id = .init(Int(raw.airDropWatchCountId))
	}
}
