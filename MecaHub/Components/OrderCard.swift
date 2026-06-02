import SwiftUI

struct OrderCard: View {
    let orden: Orden
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(orden.clienteNombre ?? "Sin cliente")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            Text("\(orden.vehiculoDesc ?? "Sin vehículo")")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            
            HStack {
                StatusBadge(estado: orden.estado)
                Spacer()
                Text("$\(orden.costoTotal, specifier: "%.2f")")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color("SecondaryColor"))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }
}