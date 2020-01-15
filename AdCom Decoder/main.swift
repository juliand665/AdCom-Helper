import Foundation
import FlatBuffers

let documentsURL = try FileManager.default.url(
	for: .documentDirectory,
	in: .userDomainMask,
	appropriateFor: nil,
	create: false
)
let responseURL = documentsURL
	.appendingPathComponent("Games")
	.appendingPathComponent("AdVenture Communist")
	.appendingPathComponent("Reverse Engineering")
	.appendingPathComponent("response.json")

let rawResponse = try Data(contentsOf: responseURL)
let response = try decoder.decode(
	ServerResponse<GetUserData.Response>.self,
	from: rawResponse
)

func dumpData(for userData: GetUserData.Response) {
	for rawModel in [userData.data.motherlandGameModel, userData.data.eventGameModel!] {
		dump(rawModel.decode())
	}
}
//dumpData(for: response.contents!)

let playerID = ProcessInfo.processInfo.environment["playerID"]!
let client = Client(playerID: playerID)
let userData = client.send(GetUserData()).sink(
	receiveCompletion: { _ in exit(0) },
	receiveValue: dumpData(for:)
)

dispatchMain()
//RunLoop.main.run()
