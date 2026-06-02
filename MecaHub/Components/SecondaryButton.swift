import SwiftUI

struct SecondaryButton: View {
    let titulo: String
    let accion: () -> Void
    
    var body: some View {
        Button(action: accion) {
            HStack {
                Image(systemName: "xmark")
                Text(titulo)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .foregroundColor(Color("SecondaryColor"))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("SecondaryColor"), lineWidth: 2)
            )
        }
    }
}