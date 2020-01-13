import Cocoa
import SwiftUI

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
	var window: NSWindow!
	
	func applicationDidFinishLaunching(_ notification: Notification) {
		_ = GameCenter.shared // load singleton
		
		// Create the SwiftUI view that provides the window contents.
		let contentView = ContentView()
		
		// Create the window and set the content view. 
		window = NSWindow(
			contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
			styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
			backing: .buffered, defer: false
		)
		window.center()
		window.setFrameAutosaveName("Main Window")
		window.contentView = NSHostingView(rootView: contentView)
		window.makeKeyAndOrderFront(nil)
	}
}

import GameKit

final class GameCenter {
	static let shared = GameCenter()
	
	let player = GKLocalPlayer.local
	
	var playerID: String { player.playerID }
	
	private init() {
		player.authenticateHandler = { viewController, error in
			if let error = error {
				print("error while authenticating:", error)
				NSApp.presentError(error)
			} else if let viewController = viewController {
				let window = NSWindow(contentViewController: viewController)
				NSApp.runModal(for: window)
			} else {
				print("authenticated as", self.playerID)
			}
		}
	}
}
