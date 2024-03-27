import SwiftUI

struct MedicineEditForm: View {
    @State private var editedMedicine: MedicineEntry
    @StateObject private var viewModel = MedicineViewModel()
        init(item: MedicineEntry) {
            self._editedMedicine = State(initialValue: item)
            print("edit to do2: ", self._editedMedicine)
        }
        
        var body: some View {
            VStack {
                TextField("Name", text: Binding(
                    get: { self.editedMedicine.name },
                    set: { self.editedMedicine.name = $0 }
                ))
                .multilineTextAlignment(.trailing)
//                TextField("Amount", value: $editedTodo.amount, formatter: NumberFormatter())
//                TextField("Price", value: $editedTodo.price, formatter: NumberFormatter())
//                TextField("Metric", text: $editedTodo.metric)
                Button("Save") {
                    // Call function to save updated details
                    saveEditedTodo()
                }
            }
            .padding()
        }
        
        func saveEditedTodo() {
            // Save updated details to the database
            // You need to implement the logic to save updated details back to the database
            print("Saving edited todo:", editedMedicine)
            // Here you can implement the logic to save the updated todo to your database
            viewModel.updateMedicine()
        }
}

#Preview {
//    MedicineEditForm(item: MedicineEntry())
    MedicineEntry(name: "Sample Name", amount: 100, price: 200, metric: "Sample Metric") as! any View
}
