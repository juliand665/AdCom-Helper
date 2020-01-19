import Foundation

public struct AirdropInfo {
	public var nextAdReset: Date
	public var nextClaimCountReset: Date
	public var nextAirdrop: Date
	public var claimCount: Int
	public var progresses: [Progress]
	
	public struct Progress {
		public var watchCount: Int
		public var id: ID
		
		public enum ID: Codable {
			case comrades
			case science
			case other(Int)
			
			public var rawValue: Int {
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
			
			public init(from decoder: Decoder) throws {
				self.init(try Int(from: decoder))
			}
			
			public func encode(to encoder: Encoder) throws {
				try rawValue.encode(to: encoder)
			}
		}
	}
}

extension AirdropInfo: Model {
	init(_ raw: AdCom.AirDropServiceProgress) {
		nextAdReset = BinaryDate(ticks: raw.nextAdResetData).date
		nextClaimCountReset = BinaryDate(ticks: raw.nextClaimCountResetData).date
		nextAirdrop = BinaryDate(ticks: raw.nextAirDropDate).date
		claimCount = Int(raw.claimCount)
		
		progresses = .init(count: raw.airDropProgressCount, accessor: raw.airDropProgress(at:))
	}
}

extension AirdropInfo.Progress: Model {
	init(_ raw: AdCom.AirDropModelProgress) {
		watchCount = Int(raw.airDropWatchCount)
		id = .init(Int(raw.airDropWatchCountId))
	}
}

#if DEBUG
public extension AirdropInfo {
	static let example = AirdropInfo(
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
}
#endif
