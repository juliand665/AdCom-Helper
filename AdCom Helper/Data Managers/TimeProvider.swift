import Foundation
import Combine

final class TimeProvider: ObservableObject {
	@Published var time = Date()
	
	private lazy var updater = Timer.publish(every: 1, on: .main, in: .common)
		.autoconnect()
		.sink { self.time = $0 }
	
	init() {
		_ = updater
	}
}
