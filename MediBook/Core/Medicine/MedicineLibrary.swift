import SwiftUI

struct MedicineLibrary: View {
    @StateObject private var viewModel = MedicineViewModel()
    @State private var isEditMode = false
    @State private var medicines: [MedicineEntry] = []
    @State private var searchText = ""
        
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText)
                // List of medicines filtered by searchText
                List {
                    ForEach(viewModel.medicines.filter {
                        searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
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
            .navigationTitle("All Medicines")
        }
        NavigationLink(destination: MedicineForm()) {
            Text("Add Medicine")
                .padding()
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(5)
        }
    }
}

#Preview {
    NavigationStack {
        MedicineLibrary()
    }
}
