import SwiftUI

struct DetalleOrdenView: View {
    let orden: Orden
    @ObservedObject var viewModel: OrdenViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showEliminar = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                
                // Card vehículo
                VStack(alignment: .leading, spacing: 8) {
                    Text(orden.clienteNombre ?? "Sin cliente")
                        .font(.system(size: 20, weight: .semibold))
                    Text(orden.vehiculoDesc ?? "Sin vehículo")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    Divider()
                    StatusBadge(estado: orden.estado)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray5)))
                
                // Resumen financiero
                VStack(alignment: .leading, spacing: 10) {
                    Text("Resumen financiero")
                        .font(.system(size: 16, weight: .semibold))
                    
                    HStack {
                        Text("Mano de obra")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("$\(orden.costoManoObra, specifier: "%.2f")")
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Text("Refacciones")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("$\(orden.costoRefacciones, specifier: "%.2f")")
                            .fontWeight(.semibold)
                    }
                    Divider()
                    HStack {
                        Text("Total")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("$\(orden.costoTotal, specifier: "%.2f")")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color("SecondaryColor"))
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray5)))
                
                // Notas
                if let descripcion = orden.descripcion, !descripcion.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notas del servicio")
                            .font(.system(size: 16, weight: .semibold))
                        Text(descripcion)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray5)))
                }
                
                // Botones
                NavigationLink {
                    EditarOrdenView(orden: orden, viewModel: viewModel)
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Editar orden")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryColor"))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                }

                DangerButton(titulo: "Eliminar orden") {
                    showEliminar = true
                }
            }
            .padding()
        }
        .navigationTitle("Detalle Orden")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Editar") {
                    EditarOrdenView(orden: orden, viewModel: viewModel)
                }
                .foregroundColor(Color("PrimaryColor"))
            }
        }
        .alert("Eliminar orden", isPresented: $showEliminar) {
            Button("Eliminar", role: .destructive) {
                viewModel.delete(id: orden.id) { success in
                    if success { dismiss() }
                }
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("¿Estás seguro de que deseas eliminar la orden de \(orden.clienteNombre ?? "")? Esta acción es irreversible.")
        }
    }
}