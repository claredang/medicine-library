import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MedicineEntry: Codable, Identifiable {
    var id: String?
    var name: String
    var amount: Int
    var price: Double
    var metric: String
//    var date_created = Timestamp()
//    var date_modified = Timestamp()
    
    init(id: String? = nil, name: String, amount: Int, price: Double, metric: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.price = price
        self.metric = metric
    }
}

class MedicineManager {
    static let shared = MedicineManager()
    private init () {}
}

final class MedicineViewModel: ObservableObject {
    @Published var medicines = [MedicineEntry]()
    private var db = Firestore.firestore()
    
    func getAllMedicine() {
        db.collection("medicine").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.medicines = documents.map { (queryDocumentSnapshot) -> MedicineEntry in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let amount = data["amount"] as? Int ?? 0
                let price = data["price"] as? Double ?? 0
                let metric = data["metric"] as? String ?? ""
                return MedicineEntry(id: id, name: name, amount: amount, price: price, metric: metric)
            }
        }
    }
    
    func addNewMedicine(medicine: MedicineEntry) {
        // Check if the medicine with the same name already exists
        db.collection("medicine")
            .whereField("name", isEqualTo: medicine.name)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error checking for existing medicine: \(error.localizedDescription)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    // No existing medicine found with the same name
                    self.saveNewMedicine(medicine)
                    return
                }

                // Medicine with the same name already exists
                DispatchQueue.main.async {
                    // Show alert or take appropriate action to notify the user
                    print("Warning: Medicine with the name '\(medicine.name)' already exists.")
                }
            }
    }
    
    private func saveNewMedicine(_ medicine: MedicineEntry) {
       do {
//           _ = try db.collection("medicine").addDocument(from: medicine)
           let newDocument = db.collection("medicine").document()
           let documentID = newDocument.documentID  // Get the auto-generated document ID
           
           var medicineData = try Firestore.Encoder().encode(medicine)  // Encode the MedicineEntry object to a dictionary
           medicineData["id"] = documentID
           
           newDocument.setData(medicineData) { error in
               if let error = error {
                   print("Error adding document: \(error.localizedDescription)")
               } else {
                   print("Document added with ID: \(documentID)")
               }
           }
       }
       catch {
           print(error.localizedDescription)
       }
    }
    
    func updateMedicine(medicine: MedicineEntry) {
        guard let documentID = medicine.id else {
            print("Error: Medicine entry does not have an ID.")
            return
        }

        let medicineRef = db.collection("medicine").document(documentID)

        // Fetch the document snapshot
        medicineRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error fetching medicine document: \(error.localizedDescription)")
                return
            }
            guard let document = documentSnapshot else {
                print("Medicine document does not exist")
                return
            }

            // Check if the document exists
            guard document.exists else {
                print("Medicine document does not exist")
                return
            }

            // Extract the current name from the document data
            if let currentName = document.data()?["name"] as? String {
                print("Current Medicine name: \(currentName)")

                // Check if the name has changed
                if medicine.name != currentName {
                    print("Medicine name has changed")

                    // Delete the existing medicine entry
                    medicineRef.delete { error in
                        if let error = error {
                            print("Error deleting medicine entry: \(error.localizedDescription)")
                            return
                        }
                        // Add a new document with updated details
                        self.addNewMedicine(medicine: medicine)
                    }
                } else {
                    print("Medicine name has not changed")

                    // Update the existing medicine entry
                    medicineRef.setData([
                        "name": medicine.name,
                        "amount": medicine.amount,
                        "price": medicine.price,
                        "metric": medicine.metric
                    ], merge: true) { error in
                        if let error = error {
                            print("Error updating medicine entry: \(error.localizedDescription)")
                        } else {
                            print("Medicine entry updated successfully.")
                        }
                    }
                }
            } else {
                print("Medicine name is not available or is not a String")
            }
        }
    }
    
    func deleteMedicine(medicine: MedicineEntry) {
        guard let documentID = medicine.id else {
            print("Error: Medicine entry does not have an ID.")
            return
        }
            
        let medicineRef = db.collection("medicine").document(documentID)
        medicineRef.delete { error in
            if let error = error {
                print("Error deleting medicine entry: \(error.localizedDescription)")
            } else {
                print("Successfully delete medicine entry")
            }
        }
    }
    
    func deleteAllMedicines(collection: String) {
        let collectionRef = db.collection(collection)
        
        // Get all documents in the collection
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            } else {
                // Iterate through each document and delete it
                for document in querySnapshot!.documents {
                    let documentID = document.documentID
                    collectionRef.document(documentID).delete { error in
                        if let error = error {
                            print("Error removing document: \(error)")
                        } else {
                            print("Document \(documentID) successfully removed")
                        }
                    }
                }
            }
        }
    }
    
    func searchMedicineByName(_ name: String) {
        db.collection("medicine")
            .whereField("name", isEqualTo: name)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error searching for medicine: \(error.localizedDescription)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No matching medicines found")
                    return
                }

                self.medicines = documents.map { (queryDocumentSnapshot) -> MedicineEntry in
                    let data = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let name = data["name"] as? String ?? ""
                    let amount = data["amount"] as? Int ?? 0
                    let price = data["price"] as? Double ?? 0
                    let metric = data["metric"] as? String ?? ""
                    return MedicineEntry(id: id, name: name, amount: amount, price: price, metric: metric)
                }
            }
        }
}
