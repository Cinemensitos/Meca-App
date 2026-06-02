import SwiftUI

struct PerfilClienteView: View {
    let cliente: Cliente
    @ObservedObject var viewModel: ClienteViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showEditar = false
    @State private var showEliminar = false
    @StateObject var ordenVM = OrdenViewModel()
    
    var iniciales: String {
        let partes = cliente.nombre.split(separator: " ")
        let primera = partes.first?.prefix(1) ?? ""
        let segunda = partes.dropFirst().first?.prefix(1) ?? ""
        return "\(primera)\(segunda)".uppercased()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // Header
                VStack(spacing: 8) {
                    AvatarView(iniciales: iniciales, size: 80)
                    Text(cliente.nombre)
                        .font(.system(size: 20, weight: .semibold))
                    Text(cliente.telefono ?? "Sin teléfono")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                Divider()
                
                // Info card
                VStack(spacing: 0) {
                    infoRow(icono: "envelope", label: "Correo", valor: cliente.correo ?? "-")
                    Divider().padding(.leading, 44)
                    infoRow(icono: "phone", label: "Teléfono", valor: cliente.telefono ?? "-")
                }
                .background(Color(.systemBackground))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray5)))
                
                // Historial órdenes
                Text("Historial de órdenes")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if ordenVM.ordenes.isEmpty {
                    Text("Sin órdenes registradas")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(ordenVM.ordenes) { orden in
                            OrderCard(orden: orden)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(cliente.nombre)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Editar") { showEditar = true }
                    .foregroundColor(Color("PrimaryColor"))
            }
        }
        .sheet(isPresented: $showEditar) {
            EditarClienteView(cliente: cliente, viewModel: viewModel)
        }
        .onAppear {
            ordenVM.getByCliente(clienteId: cliente.id)
        }
    }
    
    @ViewBuilder
    func infoRow(icono: String, label: String, valor: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icono)
                .foregroundColor(.secondary)
                .frame(width: 24)
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(valor)
                .fontWeight(.semibold)
        }
        .padding()
    }
}