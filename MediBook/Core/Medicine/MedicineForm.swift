//import SwiftUI
//import Combine
//struct MedicineForm: View {
//    @State private var name: String = ""
//    @State private var price: Int = 0
//    @State private var amount: Int = 0
//    @State private var metric: String = ""
//    @State private var showInfo = true
//    @State private var ageString: String = ""
//    @State private var age: Int = 18
//     
//    @StateObject private var viewModel = MedicineViewModel()
//    let colors = ["Red", "Green", "Blue", "Orange", "Purple", "Brown", "Gray"]
//    @State private var navigateToMedicineLibrary = false // State variable for navigation
//    
//    
//    var body: some View {
//         
//        NavigationView {
//            Form {
//                Section(header: Text("Info")) {
//                    HStack {
//                        Text("Product Name")
//                        Spacer()
//                        TextField("Name", text: $name).multilineTextAlignment(.trailing)
//                    }
//                    HStack {
//                        Text("Price")
//                        Spacer()
//                        TextField("Price", value: $price, formatter: NumberFormatter()).multilineTextAlignment(.trailing)
//                    }
//                    HStack {
//                        Text("Amount")
//                        Spacer()
//                        TextField("Amount", value: $amount, formatter: NumberFormatter()).multilineTextAlignment(.trailing)
//                    }
//                    HStack {
//                        Text("Metric")
//                        Spacer()
//                        TextField("Metric", text: $metric).multilineTextAlignment(.trailing)
//                    }
//            }
//            Button(action: {
//                let medicine = MedicineEntry(name: self.name, amount: Int(self.amount ?? 0), price: Int(self.price ?? 0), metric: self.metric)
//                
//                    viewModel.addNewMedicine(medicine: medicine)
//                navigateToMedicineLibrary = true
//            }) {
//                Text("Add Medicine")
//             
//            }.padding().foregroundColor(.white)
//            .background(Color.black)
//            .cornerRadius(5)
//                
//                NavigationLink(
//                                    destination: MedicineLibrary(),
//                                    isActive: $navigateToMedicineLibrary
//                                ) {
//                                    EmptyView() // Hidden NavigationLink triggered by button tap
//                                }
//            Button(action: {
//                    viewModel.deleteAllMedicines(collection: "medicine")
//            }) {
//                Text("Delete all medicine")
//            }.padding().foregroundColor(.white)
//            .background(Color.black)
//            .cornerRadius(5)
//                
////            Section(header: Text("Additional Details")) {
////                TextField("Age", text: $ageString)
////                .keyboardType(.numberPad)
////                .onReceive(Just(ageString)) { newValue in
////                    let filtered = newValue.filter { "0123456789".contains($0) }
////                    if filtered != newValue {
////                        self.ageString = filtered
////                    }
////                    if let newAge = Int(filtered) {
////                        self.age = newAge
////                    }
////                }
////
////                Stepper("Amount: \(amount)", value: $amount, in: 18...10000)
////                
////                Picker("Avatar Color", selection: $color) {
////                    ForEach(colors, id: \.self) { color in
////                        Text(color).tag(color)
////                    }
////                }
//                //                    .pickerStyle(.wheel)
//                
////                Toggle(isOn: $showInfo) {
////                    Text("Display my full info")
////                }
////                }
//            } .navigationTitle(Text("Add medicine"))
//            }
//        }
//}
//
//#Preview {
//    MedicineForm()
//}

import SwiftUI

struct MedicineForm: View {
    @State private var name: String = ""
    @State private var price: Int = 0
    @State private var amount: Int = 0
    @State private var metric: String = ""
    @State private var isNavigating = false // State variable for navigation

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
                    viewModel.addNewMedicine(medicine: medicine)
                    self.isNavigating = true // Activate navigation
                }) {
                    Text("Add Medicine")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(5)
                        .fullScreenCover(isPresented: $isNavigating) {
                            MedicineLibrary()
                        }
//                        .hidden()
                }
                
                            Button(action: {
                                    viewModel.deleteAllMedicines(collection: "medicine")
                            }) {
                                Text("Delete all medicine")
                            }.padding().foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(5)
            }
            .navigationTitle("Add medicine")
        }
    }
}

struct MedicineForm_Previews: PreviewProvider {
    static var previews: some View {
        MedicineForm()
    }
}
