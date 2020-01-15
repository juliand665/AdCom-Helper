import SwiftUI
import HandyOperators

private let formatter = DateFormatter() <- {
	$0.dateStyle = .short
	$0.timeStyle = .medium
}

struct TimeView: View {
	@EnvironmentObject var timeProvider: TimeProvider
	var time: Date
	@State var showAsRelative: Bool
	
	init(_ time: Date, showAsRelative: Bool = true) {
		self.time = time
		self._showAsRelative = .init(initialValue: showAsRelative)
	}
	
	var body: some View {
		Text(verbatim: text)
			.onTapGesture { self.showAsRelative.toggle() }
	}
	
	private var text: String {
		guard showAsRelative else { return formatter.string(from: time) }
		let difference = abs(time.timeIntervalSince(timeProvider.time))
		
		let formattedTime: String
		if difference < 60 {
			formattedTime = "\(Int(difference))s"
		} else if difference < 3600 {
			formattedTime = "\(Int(difference / 60))m"
		} else {
			return formatter.string(from: time)
		}
		
		if time < timeProvider.time {
			return "\(formattedTime) ago"
		} else {
			return "in \(formattedTime)"
		}
	}
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
		TimeView(Date(timeIntervalSinceNow: -30))
			.environmentObject(TimeProvider())
    }
}
