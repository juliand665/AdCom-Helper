import Foundation
import HandyOperators
import Combine

let playFabTitleID = "6bf5"

public final class Client {
	public let playerID: String
	
	private let baseURL = URL(string: "https://\(playFabTitleID).playfabapi.com/Client")!
	private let requestEncoder = JSONEncoder()
	private let responseDecoder = decoder
	
	private var sessionTicket = ProcessInfo.processInfo.environment["sessionTicket"]
	
	public init(playerID: String) {
		self.playerID = playerID
	}
	
	public func send<R>(
		_ request: R,
		allowingReauth: Bool = true
	) -> AnyPublisher<R.Response, Error> where R: Request {
		rawRequest(for: request)
			.flatMap(dispatch(_:))
			.decode(type: ServerResponse<R.Response>.self, decoder: responseDecoder)
			//.handleEvents(receiveOutput: { dump($0) })
			.flatMap { self.extractContents(from: $0, for: request, allowingReauth: allowingReauth) }
			.breakpointOnError()
			.eraseToAnyPublisher()
	}
	
	private func extractContents<R>(
		from response: ServerResponse<R.Response>,
		for request: R,
		allowingReauth: Bool
	) -> AnyPublisher<R.Response, Error> where R: Request {
		switch response.code {
		case 401: // forbidden
			if allowingReauth, request.requiresAuthentication { // the first time it happens, try to relog
				sessionTicket = nil
				return send(request, allowingReauth: false)
			} else { // if it keeps happening, give up
				return Fail(error: RequestError.forbidden)
					.eraseToAnyPublisher()
			}
		default:
			return Just(response)
				.tryMap { try $0.contents ??? RequestError.failureResponse(response) }
				.eraseToAnyPublisher()
		}
	}
	
	private func rawRequest<R>(for request: R) -> AnyPublisher<URLRequest, Error> where R: Request {
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
	
	private func ensureSessionTicket(forceUpdate: Bool = false) -> AnyPublisher<String, Error> {
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
	
	private func dispatch(_ rawRequest: URLRequest) -> AnyPublisher<Data, Error> {
		URLSession.shared.dataTaskPublisher(for: rawRequest)
			.map { $0.data } // response code is encoded in data
			.mapError { $0 as Error }
			.eraseToAnyPublisher()
	}
	
	public enum RequestError: Swift.Error {
		case failureResponse(Decodable)
		case forbidden
	}
}
