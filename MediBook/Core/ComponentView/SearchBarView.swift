import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)

            Button(action: {
                searchText = "" // Clear search text
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 8)
            .opacity(searchText.isEmpty ? 0 : 1)
        }
        .padding(.horizontal)
    }
}

struct SearchBarContentView: View {
    @State private var searchText = ""

    var body: some View {
        VStack {
            SearchBarView(searchText: $searchText)

            // Other content using the searchText
            Text("Search Text: \(searchText)")
                .padding()
        }
        .padding()
    }
}

#Preview {
    SearchBarContentView()
}
