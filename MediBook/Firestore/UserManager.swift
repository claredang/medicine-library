import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser {
    let userId: String
}

struct Todo: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String?
    var amount: Int?
    var price: Int?
    var metric: String?
}

class UserManager {
    static let shared = UserManager()
    private init () {}
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String:Any] = [
            "user_id": auth.uid,
            "date_created": Timestamp(),
        ]
        if let email = auth.email {
            userData["email"] = email
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("user").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        return DBUser(userId: userId)
    }
}

final class TodoViewModel: ObservableObject {

    @Published var todos = [Todo]()

    private var db = Firestore.firestore()

    func getAllData() {
        db.collection("todos").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.todos = documents.map { (queryDocumentSnapshot) -> Todo in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let amount = data["amount"] as? Int ?? 0
                let price = data["price"] as? Int ?? 0
                let metric = data["metric"] as? String ?? ""
                print("name and metric: ", name, metric, amount, price)
                return Todo(name: name, amount: amount, price: price, metric: metric)
            }
        }
    }
    
    func getAllMedicine() {
        db.collection("medicine").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.todos = documents.map { (queryDocumentSnapshot) -> Todo in
                let data = queryDocumentSnapshot.data()
//                let name = data["name"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let amount = data["amount"] as? Int ?? 0
                let price = data["price"] as? Int ?? 0
                let metric = data["metrics"] as? String ?? ""
                print("name and metric: ", name, metric, amount, price)
                return Todo(name: name, amount: amount, price: price, metric: metric)
            }
        }
    }

    func addNewData(name: String) {
       do {
           _ = try db.collection("todos").addDocument(data: ["name": name])
       }
       catch {
           print(error.localizedDescription)
       }
    }
    
    func addNewCustomer() {
        let docData2: [String: Any] = [
          "id": "8onHi3qre46j2bbZf6D2",
          "customer": [
            "name": "John",
            "buy": [
                [
                    "amount": 6,
                "medicine_id": "2gv571SUnbNkUQOHI"
                ],
                [
                    "amount": 7,
                    "medicine_id": "aaabbd"
                ]
            ]
          ],
        ]
        do {
            _ = try db.collection("data").addDocument(data: docData2)
//            _ = db.collection("data").document("two").setData(docData2)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
