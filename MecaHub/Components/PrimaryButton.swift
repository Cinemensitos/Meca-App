import SwiftUI

struct PrimaryButton: View {
    let titulo: String
    let accion: () -> Void
    
    var body: some View {
        Button(action: accion) {
            HStack {
                Image(systemName: "checkmark")
                Text(titulo)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("PrimaryColor"))
            .foregroundColor(.white)
            .cornerRadius(14)
        }
    }
}