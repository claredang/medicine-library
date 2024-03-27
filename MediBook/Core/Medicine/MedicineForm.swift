struct Medicine: Codable {
    var productName: String
    var price: String
    var amount: Double
    var metric: String
}

import SwiftUI
import Combine
struct MedicineForm: View {
    @State private var product_name: String = ""
    @State private var price: String = ""
    @State private var metric: String = ""
    @State private var amount: Double?
    @State private var color: String = "Blue"
    @State private var showInfo = true
    @State private var ageString: String = ""
    @State private var age: Int = 18
     
    @StateObject private var viewModel = TodoViewModel()
    let colors = ["Red", "Green", "Blue", "Orange", "Purple", "Brown", "Gray"]
    
    
    var body: some View {
         
        NavigationView {
            Form {
                Section(header: Text("Info")) {
                    HStack {
                        Text("Product Name")
                        Spacer()
                        TextField("Name", text: $product_name).multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Price")
                        Spacer()
                        TextField("Price", text: $price).multilineTextAlignment(.trailing)
                    }
//                    TextField("Amount", text: $amount)
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Amount", value: $amount, format: .number).multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Metric")
                        Spacer()
                        TextField("Metric", text: $metric).multilineTextAlignment(.trailing)
                    }
            }
            Button(action: {
                let medicine = Medicine(productName: self.product_name, price: self.price, amount: self.amount ?? 0, metric: self.metric)
//                let todo = Medicine(name: medicine.productName, amount: Int(medicine.amount), price: Int(medicine.price), metric: medicine.metric)
                    viewModel.addNewMedicine(medicine: medicine)
//                viewModel.addNewMedicine(medicine: medicine)
            }) {
                Text("Add Medicine")
            }.padding().foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(5)
                
            Section(header: Text("Additional Details")) {
                TextField("Age", text: $ageString)
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(ageString)) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        if filtered != newValue {
                                            self.ageString = filtered
                                        }
                                        if let newAge = Int(filtered) {
                                            self.age = newAge
                                        }
                                    }
//
//                Stepper("Amount: \(amount)", value: $amount, in: 18...10000)
//                
                Picker("Avatar Color", selection: $color) {
                    ForEach(colors, id: \.self) { color in
                        Text(color).tag(color)
                    }
                }
                //                    .pickerStyle(.wheel)
                
                Toggle(isOn: $showInfo) {
                    Text("Display my full info")
                }
                }
            } .navigationTitle(Text("Add medicine"))
            }
        }
}

#Preview {
    MedicineForm()
}
