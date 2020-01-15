import SwiftUI

struct ControllerView<VC>: UIViewControllerRepresentable where VC: UIViewController {
	let viewController: VC
	
	init(_ viewController: VC) {
		self.viewController = viewController
	}
	
	func makeUIViewController(context: Context) -> VC {
		viewController
	}
	
	func updateUIViewController(_: VC, context: Context) {}
}
