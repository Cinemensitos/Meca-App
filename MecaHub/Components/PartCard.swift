import SwiftUI

struct PartCard: View {
    let pieza: Pieza
    
    var body: some View {
        HStack(spacing: 12) {
            // Ícono categoría
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("PrimaryColor").opacity(0.1))
                    .frame(width: 44, height: 44)
                Image(systemName: "shippingbox")
                    .foregroundColor(Color("PrimaryColor"))
                    .font(.system(size: 20))
            }
            
            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(pieza.nombre)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                Text("\(pieza.categoria ?? "") · \(pieza.stockActual) pzas")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                Text("$\(pieza.precio, specifier: "%.2f")")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("SecondaryColor"))
            }
            
            Spacer()
            
            StockBadge(estado: pieza.estadoStock ?? "disponible")
            
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