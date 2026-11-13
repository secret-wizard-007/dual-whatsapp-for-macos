import SwiftUI

struct ContentView: View {
    @StateObject private var session = WhatsAppSession()

    var body: some View {
        ZStack {
            WhatsAppWebView(session: session)
                .ignoresSafeArea()

            if session.isLoading {
                ProgressView("Loading WhatsApp…")
                    .padding(20)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .frame(minWidth: 900, minHeight: 600)
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button {
                    session.reload()
                } label: {
                    Label("Reload", systemImage: "arrow.clockwise")
                }
                .help("Reload WhatsApp Web")

                Button(role: .destructive) {
                    session.clearSessionAndReload()
                } label: {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                }
                .help("Clear this app’s WhatsApp session (official app is unaffected)")
            }
        }
        .navigationTitle("WA Dual")
    }
}

#Preview {
    ContentView()
}
