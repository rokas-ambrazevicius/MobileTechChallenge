import SwiftUI

struct NoInternetView: View {
    var body: some View {
        Image("noImage")
            .clipShape(Circle())
        
        Text("No internet connection!")
            .font(.title)
            .padding()
        
        Text("Please check your WiFi or mobile data connection")
            .padding()
    }
}
