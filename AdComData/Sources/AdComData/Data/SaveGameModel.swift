import Foundation
import FlatBuffers

public struct SaveGameModel {
	public let lastUpdated: Date
	
	public let dataVersion: Int
	public let saveVersion: Int
	public let saveTime: Date
	
	public let resources: [Resource]
	public let industries: [Industry]
	public let generators: [Generator]
	public let missions: [Mission]
	public let experiments: [Experiment]
	public let researchers: [Researcher]
	public let tradeLevels: [TradeLevel]
	public let gachaScripts: [GachaScript]
	public let storePromos: [StorePromo]
	public let ads: [Ad]
	public let flags: [Flag]
	public let statistics: [Statistic]
	
	public let rank: Int
	public let airdropInfo: AirdropInfo
	public let lastEarnedSupremeID: String?
}

extension SaveGameModel: GameModel {
	init(from buffer: ByteBuffer, lastUpdated: Date) {
		let raw = AdCom.SaveGameModel.getRootAsSaveGameModel(bb: buffer)
		
		self.lastUpdated = lastUpdated
		
		self.dataVersion = Int(raw.dataVersion)
		self.saveVersion = Int(raw.saveVersion)
		self.saveTime = BinaryDate(ticks: raw.saveTime).date
		
		self.resources = .init(count: raw.resourcesCount, accessor: raw.resources(at:))
		self.industries = .init(count: raw.industriesCount, accessor: raw.industries(at:))
		self.generators = .init(count: raw.generatorsCount, accessor: raw.generators(at:))
		self.missions = .init(count: raw.missionsCount, accessor: raw.missions(at:))
		self.experiments = .init(count: raw.experimentsCount, accessor: raw.experiments(at:))
		self.researchers = .init(count: raw.researchersCount, accessor: raw.researchers(at:))
		self.tradeLevels = .init(count: raw.tradeLevelsCount, accessor: raw.tradeLevels(at:))
		self.gachaScripts = .init(count: raw.gachaScriptsCount, accessor: raw.gachaScripts(at:))
		self.storePromos = .init(count: raw.storePromosCount, accessor: raw.storePromos(at:))
		self.ads = .init(count: raw.adsCount, accessor: raw.ads(at:))
		self.flags = .init(count: raw.flagsCount, accessor: raw.flags(at:))
		self.statistics = .init(count: raw.statisticsCount, accessor: raw.statistics(at:))
		
		self.rank = Int(raw.rank)
		self.airdropInfo = .init(raw.airDropServiceProgress!)
		self.lastEarnedSupremeID = nil //raw.lastEarnedSupremeId
	}
}

#if DEBUG
public extension SaveGameModel {
	static let example = SaveGameModel(
		lastUpdated: Date(),
		dataVersion: 10,
		saveVersion: 100,
		saveTime: Date(timeIntervalSinceNow: -1),
		resources: [],
		industries: [],
		generators: [],
		missions: [],
		experiments: [],
		researchers: [],
		tradeLevels: [],
		gachaScripts: [],
		storePromos: [],
		ads: [],
		flags: [],
		statistics: [],
		rank: 42,
		airdropInfo: .example,
		lastEarnedSupremeID: nil
	)
}
#endif
