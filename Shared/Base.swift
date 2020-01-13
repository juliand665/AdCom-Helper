import Foundation
import HandyOperators

typealias AdCom = AdComm.Saves

private let formatter = ISO8601DateFormatter() <- {
	$0.formatOptions.insert(.withFractionalSeconds)
}

let decoder = JSONDecoder() <- {
	$0.dataDecodingStrategy = .base64
	$0.dateDecodingStrategy = .custom { decoder in
		let raw = try String(from: decoder)
		return try formatter.date(from: raw) ??? DecodingError.dataCorruptedError(
			in: try decoder.singleValueContainer(),
			debugDescription: "invalid iso-8601 date: \(raw)"
		)
	}
}
