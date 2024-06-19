import SwiftUI

struct PrescriptionMedicine: Codable, Identifiable {
    var id = UUID().uuidString
    var medicine_id: String
    var amount_use: Int
}

struct PrescriptionForm: View {
    @ObservedObject var viewModel = MedicineViewModel()
    @State private var name = ""
    @State private var birthday = Date()
    @State private var selectedGenderIndex = 0
    @State private var address = ""
    @State private var symptom = ""
    @State private var selectedMedicines = [PrescriptionMedicine]()
    let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Patient Information")) 
                {
                    TextField("Name", text: $name)
                    DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                    
                    Picker("Gender", selection: $selectedGenderIndex) {
                        ForEach(0 ..< genders.count) {
                            Text(self.genders[$0])
                        }
                    }
                    TextField("Address", text: $address)
                    TextField("Symptom", text: $symptom)
                }
                
                Section(header: Text("Medicines")) {
                    NavigationLink(destination: PrescriptionMedicineList())
                    {
                            Text("Add medicine")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(5)
                        .padding()
                    }
                }
                
                Button("Create Prescription") {
                }
            }
        }
    }
    
}

#Preview {
    PrescriptionForm()
}








