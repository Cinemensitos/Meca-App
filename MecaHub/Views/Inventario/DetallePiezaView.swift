import SwiftUI

struct DetallePiezaView: View {
    let pieza: Pieza
    @ObservedObject var viewModel: InventarioViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showEditar = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // Header
                VStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("PrimaryColor").opacity(0.1))
                            .frame(width: 72, height: 72)
                        Image(systemName: "shippingbox")
                            .foregroundColor(Color("PrimaryColor"))
                            .font(.system(size: 36))
                    }
                    Text(pieza.nombre)
                        .font(.system(size: 18, weight: .semibold))
                    Text("Categoría: \(pieza.categoria ?? "-")")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    StockBadge(estado: pieza.estadoStock ?? "disponible")
                }
                .padding(.top)
                
                // Info
                VStack(spacing: 0) {
                    infoRow("💰 Precio unitario", valor: "$\(pieza.precio, specifier: "%.2f")")
                    Divider().padding(.leading, 16)
                    infoRow("📦 Stock actual", valor: "\(pieza.stockActual) piezas")
                    Divider().padding(.leading, 16)
                    infoRow("⚠️ Stock mínimo", valor: "\(pieza.stockMinimo) piezas")
                    Divider().padding(.leading, 16)
                    infoRow("🏷️ Código", valor: pieza.codigo ?? "-")
                }
                .background(Color(.systemBackground))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray5)))
                
                // Descripción
                if let desc = pieza.descripcion, !desc.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descripción")
                            .font(.system(size: 16, weight: .semibold))
                        Text(desc)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray5)))
                }
                
                PrimaryButton(titulo: "Editar pieza") {
                    showEditar = true
                }
            }
            .padding()
        }
        .navigationTitle("Detalle Pieza")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Editar") { showEditar = true }
                    .foregroundColor(Color("PrimaryColor"))
            }
        }
        .sheet(isPresented: $showEditar) {
            EditarPiezaView(pieza: pieza, viewModel: viewModel)
        }
    }
    
    @ViewBuilder
    func infoRow(_ label: String, valor: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .font(.system(size: 13))
            Spacer()
            Text(valor)
                .fontWeight(.semibold)
                .font(.system(size: 13))
        }
        .padding()
    }
}