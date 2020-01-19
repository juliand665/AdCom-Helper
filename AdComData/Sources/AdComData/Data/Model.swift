import Foundation
import FlatBuffers

protocol Model: Codable {
	associatedtype Raw
	
	init(_ raw: Raw)
}

extension Array where Element: Model {
	init(
		of type: Element.Type = Element.self,
		count: Int32,
		accessor: (Int32) -> Element.Raw?
	) {
		self = (0..<count).map { .init(accessor($0)!) }
	}
}

protocol GameModel: Codable {
	init(from buffer: ByteBuffer, lastUpdated: Date)
}
