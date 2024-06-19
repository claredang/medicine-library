import SwiftUI

struct Dashboard: View {
    var body: some View {
           NavigationView {
               VStack {
                   NavigationLink(destination: MedicineLibrary()) {
                       Text("Medicine Library")
                           .padding()
                           .foregroundColor(.white)
                           .background(Color.blue)
                           .cornerRadius(5)
                   }
                   .padding()

                   NavigationLink(destination: MedicineLowStock()) {
                       Text("Low Stock Alert")
                           .padding()
                           .foregroundColor(.white)
                           .background(Color.red)
                           .cornerRadius(5)
                   }
                   .padding()
               }
               .navigationTitle("Dashboard")
           }
       }
}

#Preview {
    Dashboard()
}
