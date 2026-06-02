import SwiftUI

struct ClientCard: View {
    let cliente: Cliente
    
    var iniciales: String {
        let partes = cliente.nombre.split(separator: " ")
        let primera = partes.first?.prefix(1) ?? ""
        let segunda = partes.dropFirst().first?.prefix(1) ?? ""
        return "\(primera)\(segunda)".uppercased()
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color("PrimaryColor"))
                    .frame(width: 44, height: 44)
                Text(iniciales)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(cliente.nombre)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                Text(cliente.telefono ?? "Sin teléfono")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.system(size: 14))
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}