import Foundation
import FlatBuffers

public struct SharedGameModel {
	public let lastUpdated: Date
	
	public let dataVersion: Int
	public let saveVersion: Int
	public let saveTime: Date
	
	let gold: Int
	// TODO: others
}

extension SharedGameModel: GameModel {
	init(from buffer: ByteBuffer, lastUpdated: Date) {
		let raw = AdCom.SharedSaveGameModel.getRootAsSharedSaveGameModel(bb: buffer)
		
		self.lastUpdated = lastUpdated
		
		self.dataVersion = Int(raw.dataVersion)
		self.saveVersion = Int(raw.saveVersion)
		self.saveTime = BinaryDate(ticks: raw.saveTime).date
		
		self.gold = Int(raw.gold)
	}
}

#if DEBUG
public extension SharedGameModel {
	static let example = SharedGameModel(
		lastUpdated: Date(),
		dataVersion: 10,
		saveVersion: 100,
		saveTime: Date(timeIntervalSinceNow: -1),
		gold: Int(1337)
	)
}
#endif
