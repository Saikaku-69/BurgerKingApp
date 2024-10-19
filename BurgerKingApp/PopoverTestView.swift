import SwiftUI

struct PopoverTestView: View {
    @State private var isPopoverPresented: Bool = false
    
    var body: some View {
        Text("Tap to show popover")
            .padding()
            .onTapGesture {
                isPopoverPresented = true
            }
            .popover(isPresented: $isPopoverPresented, arrowEdge: .top) {
                VStack {
                    Text("Popover with anchor")
                    Button("Close") {
                        isPopoverPresented = false
                    }
                }
                .frame(width: 30, height: 30)
            }
    }
}

#Preview {
    PopoverTestView()
}
