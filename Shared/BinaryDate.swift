import Foundation
import HandyOperators

/// 0001-01-01 00:00:00
private let theStartOfTime = DateComponents(
	calendar: .current,
	timeZone: TimeZone(secondsFromGMT: 0)
).date!

struct BinaryDate {
	var ticks: Int64
	
	var date: Date {
		Date(timeInterval: TimeInterval(ticks) / 1e7, since: theStartOfTime)
	}
}

extension BinaryDate: Codable {
	init(decoder: Decoder) throws {
		ticks = try decoder.singleValueContainer().decode(Int64.self)
	}
	
	func encode(to encoder: inout Encoder) throws {
		try encoder.singleValueContainer() <- { try $0.encode(ticks) }
	}
}
