import Foundation
import AdComData

func dumpData(for userData: UserData) {
	dump(userData.data.eventGameModel!.decode())
}
//dumpData(for: response.contents!)

let playerID = ProcessInfo.processInfo.environment["playerID"]!
let client = Client(playerID: playerID)
let userData = client.getUserData().sink(
	receiveCompletion: { _ in exit(0) },
	receiveValue: dumpData(for:)
)

dispatchMain()
