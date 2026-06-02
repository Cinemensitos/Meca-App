import SwiftUI

struct DangerButton: View {
    let titulo: String
    let accion: () -> Void
    
    var body: some View {
        Button(action: accion) {
            HStack {
                Image(systemName: "trash")
                Text(titulo)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .foregroundColor(Color.red)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.red, lineWidth: 2)
            )
        }
    }
}