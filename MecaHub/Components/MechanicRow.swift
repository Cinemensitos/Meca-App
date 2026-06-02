import SwiftUI

struct MechanicRow: View {
    let mecanico: Mecanico
    
    var body: some View {
        HStack(spacing: 12) {
            AvatarView(iniciales: mecanico.iniciales, size: 44)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(mecanico.nombre)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                Text(mecanico.cargo ?? "Mecánico")
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
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}