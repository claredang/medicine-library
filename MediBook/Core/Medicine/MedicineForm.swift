import SwiftUI

struct MedicineForm: View {
    @State private var name: String = ""
    @State private var price: Int = 0
    @State private var amount: Int = 0
    @State private var metric: String = ""
    @State private var isNavigating = false
    @State private var showAlert = false

    @StateObject private var viewModel = MedicineViewModel()
    let colors = ["Red", "Green", "Blue", "Orange", "Purple", "Brown", "Gray"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Info")) {
                    HStack {
                        Text("Product Name")
                        Spacer()
                        TextField("Name", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Price")
                        Spacer()
                        TextField("Price", value: $price, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Amount", value: $amount, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Metric")
                        Spacer()
                        TextField("Metric", text: $metric)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Button(action: {
                    let medicine = MedicineEntry(name: self.name, amount: self.amount, price: Double(self.price), metric: self.metric)
                      viewModel.addNewMedicine(medicine: medicine) { success in
                          if success {
                              self.isNavigating = true
                          } else {
                              self.showAlert = true
                          }
                      }
                }) {
                    Text("Add Medicine")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(5)
                        .fullScreenCover(isPresented: $isNavigating) {
                            MedicineLibrary()
                        }
                }
//                Button(action: {
//                        viewModel.deleteAllMedicines(collection: "medicine")
//                }) {
//                    Text("Delete all medicine")
//                }.padding().foregroundColor(.white)
//                .background(Color.black)
//                .cornerRadius(5)
            }
            .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Duplicate Name"),
                                message: Text("A medicine with the name '\(name)' already exists."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
            .navigationTitle("Add medicine")
        }
    }
}

#Preview {
    MedicineForm()
}
