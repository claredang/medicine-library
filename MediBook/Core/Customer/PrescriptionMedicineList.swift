import SwiftUI

protocol PrescriptionMedicineDelegate: AnyObject {
    func didSelectMedicines(_ medicines: [PrescriptionMedicine])
}

struct PrescriptionMedicineList: View {
    @StateObject private var viewModel = MedicineViewModel()
    @State private var medicines: [MedicineEntry] = []
    @State private var searchText = ""
    @State private var selectedMedicine: MedicineEntry?
    @State private var amount: Int = 1
    weak var delegate: PrescriptionMedicineDelegate?

    var body: some View {
        VStack {
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
                        }
                        .contentShape(Rectangle()) // Makes the entire row tappable
                        .onTapGesture {
                            self.selectedMedicine = medicine
//                            self.amount = medicine.amount // Set amount to current medicine's amount
                        }
                    }
                }
                .onAppear() {
                    self.viewModel.getAllMedicine()
                }
            }
            .navigationTitle("All Medicines")

            if let selectedMedicine = selectedMedicine {
                HStack {
                    Text("Medicine Name: \(selectedMedicine.name)")
                    Spacer()
                    Stepper(value: $amount, in: 1...100) {
                        Text("Amount: \(amount)")
                    }
                    Button(action: {
                        addMedicine()
                    }) {
                        Text("Add")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(5)
                    }
                }
                .padding(.horizontal)
            }

            List {
                ForEach($medicines, id: \.id) { $medicine in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Medicine Name: \(medicine.name)")
                            HStack {
                                Text("Amount:")
                                TextField("Amount", value: $medicine.amount, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                            }
                        }
                        Spacer()
                        Button(action: {
                            deleteMedicine(medicine)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())

            Spacer()

            HStack {
                Spacer()
                Button(action: {
                    clearList()
                }) {
                    Text("Clear List")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(5)
                }
                Button(action: {
                    saveMedicines()
                }) {
                    Text("Save")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(5)
                }
            }
            .padding()
        }
        .navigationTitle("Medicine Use List")
    }

    private func addMedicine() {
        guard let selectedMedicine = selectedMedicine else { return }
        let newMedicine = MedicineEntry(id: UUID().uuidString, name: selectedMedicine.name, amount: amount, price: selectedMedicine.price, metric: selectedMedicine.metric)
        medicines.append(newMedicine)
        self.selectedMedicine = nil
        amount = 1 // Reset amount after adding
    }

    private func deleteMedicine(_ medicine: MedicineEntry) {
        medicines.removeAll { $0.id == medicine.id }
    }

    private func clearList() {
        medicines.removeAll()
    }

    private func saveMedicines() {
        // Implement saving logic here
    }
}

#Preview {
    PrescriptionMedicineList()
}


