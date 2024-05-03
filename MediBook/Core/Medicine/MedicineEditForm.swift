import SwiftUI

struct MedicineEditForm: View {
    @State private var editedMedicine: MedicineEntry
    @StateObject private var viewModel = MedicineViewModel()
    @State private var isNavigating = false

//    init(item: MedicineEntry) {
//        self._editedMedicine = State(initialValue: item)
//    }
    
    init(item: MedicineEntry) {
           self._editedMedicine = State(initialValue: item)
       }
    
    var body: some View {
        VStack {
            TextField("Name", text: $editedMedicine.name)
                .multilineTextAlignment(.trailing)
            TextField("Amount", value: $editedMedicine.amount, formatter: NumberFormatter())
            TextField("Price", value: $editedMedicine.price, formatter: NumberFormatter())
            TextField("Metric", text: $editedMedicine.metric)
            
            Button("Save") {
                updateMedicine()
            }
            Button("Delete") {
               deleteMedicine()
            }
            
            NavigationLink(destination: MedicineLibrary(), isActive: $isNavigating) {
                EmptyView() // Invisible view to trigger NavigationLink
            }
            .hidden() // Hide the NavigationLink view
        }
        .padding()
    }
    
    func updateMedicine() {
        print("Saving edited medicine:", editedMedicine)
        viewModel.updateMedicine(medicine: editedMedicine)
        isNavigating = true
    }
    
    func deleteMedicine() {
        print("delete medicine", editedMedicine)
        viewModel.deleteMedicine(medicine: editedMedicine)
        isNavigating = true
    }
}

struct MedicineEditForm_Previews: PreviewProvider {
    static var previews: some View {
//        let sampleMedicine = MedicineEntry(item)
        NavigationView {
            MedicineEditForm(item: MedicineEntry(name: "Sample Name", amount: 100, price: 200, metric: "Sample Metric"))
//            MedicineEditForm(item: sampleMedicine)
        }
    }
}
