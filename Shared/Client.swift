import Foundation
import HandyOperators
import Combine

let playFabTitleID = "6bf5"

final class Client {
	let playerID: String
	
	private let baseURL = URL(string: "https://\(playFabTitleID).playfabapi.com/Client")!
	private let requestEncoder = JSONEncoder()
	private let responseDecoder = decoder
	
	private var sessionTicket = ProcessInfo.processInfo.environment["sessionTicket"]
	
	init(playerID: String) {
		self.playerID = playerID
	}
	
	func send<R>(_ request: R) -> AnyPublisher<R.Response, Error> where R: Request {
		let response = rawRequest(for: request)
			//.handleEvents(receiveOutput: { dump($0) })
			.flatMap(dispatch(_:))
			.tryMap({ [responseDecoder] in
				try responseDecoder.decode(ServerResponse<R.Response>.self, from: $0)
			})
		// split apart for type inference with dump
		return response
			//.handleEvents(receiveOutput: { dump($0) })
			.map { $0.contents! } // FIXME: change to handle errors
			.breakpointOnError()
			.eraseToAnyPublisher()
	}
	
	func rawRequest<R>(for request: R) -> AnyPublisher<URLRequest, Error> where R: Request {
		let rawRequest = Result.Publisher(.init(catching: {
			try URLRequest(url: baseURL.appendingPathComponent(request.requestURL)) <- {
				$0.httpBody = try requestEncoder.encode(request)
				$0.httpMethod = "POST"
				$0.addValue("application/json", forHTTPHeaderField: "Content-Type")
			}
		}))
		
		if request.requiresAuthentication {
			return rawRequest.zip(ensureSessionTicket(), { rawRequest, ticket in
				rawRequest <- {
					$0.addValue(ticket, forHTTPHeaderField: "X-Authorization")
				}
			})
				.eraseToAnyPublisher()
		} else {
			return rawRequest
				.eraseToAnyPublisher()
		}
	}
	
	func ensureSessionTicket(forceUpdate: Bool = false) -> AnyPublisher<String, Error> {
		if !forceUpdate, let ticket = sessionTicket {
			return Just(ticket)
				.setFailureType(to: Error.self)
				.eraseToAnyPublisher()
		} else {
			return send(LogInWithGameCenter(playerID: playerID))
				.map { $0.sessionTicket <- { self.sessionTicket = $0 } }
				.eraseToAnyPublisher()
		}
	}
	
	func dispatch(_ rawRequest: URLRequest) -> AnyPublisher<Data, Error> {
		URLSession.shared.dataTaskPublisher(for: rawRequest)
			.map { $0.data } // response code is encoded in data
			.mapError { $0 as Error }
			.eraseToAnyPublisher()
	}
}
