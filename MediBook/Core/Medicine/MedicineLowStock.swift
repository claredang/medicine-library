import SwiftUI

struct SearchBarViewLowStock: View {
    @Binding var threshold: Int
    @State private var searchText = ""

    var body: some View {
        VStack {
            TextField("Enter low stock threshold", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                if let threshold = Int(searchText) {
                    self.threshold = threshold
                }
            }) {
                Text("Search Low Stock")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            .padding()
        }
    }
}

struct MedicineLowStock: View {
    @StateObject private var viewModel = MedicineViewModel()
    @State private var isEditMode = false
    @State private var medicines: [MedicineEntry] = []
    @State private var searchText = ""
    @State private var lowStockThreshold = 100 // Initial low stock
    var body: some View {
        NavigationView {
            VStack {
                SearchBarViewLowStock(threshold: $lowStockThreshold)
                List {
                    ForEach(viewModel.medicines.filter {
                        (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)) &&
                        $0.amount < lowStockThreshold
                    }, id: \.id) { medicine in
                        VStack(alignment: .leading) {
                            Text("Name: \(medicine.name)")
                            Text("Amount: \(medicine.amount)")
                            Text("Price: \(medicine.price)")
                            Text("Metric: \(medicine.metric)")
                            NavigationLink(destination: MedicineEditForm(item: medicine)) {
                                Text("Edit")
                            }
                        }
                    }
                }
                .onAppear() {
                    self.viewModel.getAllMedicine()
                }
            }
            .navigationTitle("Low Stock")
        }
    }
}

#Preview {
    MedicineLowStock()
}
