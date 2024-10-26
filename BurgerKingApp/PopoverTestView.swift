import SwiftUI

struct PopoverTestView: View {
    
    @State private var isPopoverPresented = false
    @State private var isPopoverTest = false
    
    var body: some View {
        
        Button("Show Popover") {
            isPopoverPresented.toggle()
        }
        .buttonStyle(.borderedProminent)
        .popover(isPresented: $isPopoverPresented,
                 attachmentAnchor: .point(.topLeading),
                 content: {
            Text("This is a popover")
                .padding()
                .frame(minWidth: 100, maxHeight: 300)
                .background(.red)
                .presentationCompactAdaptation(.popover)
        })
        .padding(.bottom,100)
        
        Circle()
            .frame(width:50)
            .popover(isPresented: $isPopoverTest,
                     attachmentAnchor: .point(.topLeading),
                     content: {
                Text("This is a Circle")
                    .padding(.horizontal)
                    .frame(minWidth:50,maxHeight: 50)
                    .presentationCompactAdaptation(.popover)
            })
            .onAppear() {
                isPopoverTest = true
            }
    }
}

#Preview {
    PopoverTestView()
}
