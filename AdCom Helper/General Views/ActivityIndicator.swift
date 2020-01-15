import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
	@Binding var isAnimating: Bool
	let style: UIActivityIndicatorView.Style
	
	func makeUIView(context: Context) -> UIActivityIndicatorView {
		UIActivityIndicatorView(style: style)
	}
	
	func updateUIView(_ view: UIActivityIndicatorView, context: Context) {
		if isAnimating {
			view.startAnimating()
		} else {
			view.stopAnimating()
		}
	}
}
struct ActivityIndicator_Previews: PreviewProvider {
	static var previews: some View {
		ActivityIndicator(isAnimating: .constant(true), style: .large)
	}
}
