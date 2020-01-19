import Foundation

public struct Ad {
	public var id: Int
	public var currentViews: Int
	public var viewsToLimit: Int
	public var timeRemaining: TimeInterval
}

extension Ad: Model {
	init(_ raw: AdCom.Ad) {
		id = Int(raw.id)
		currentViews = Int(raw.currentViews)
		viewsToLimit = Int(raw.viewsToLimit)
		timeRemaining = raw.timeRemaining
	}
}
