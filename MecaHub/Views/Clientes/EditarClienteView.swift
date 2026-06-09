import SwiftUI

struct EditarClienteView: View {
    let clienteInicial: Cliente
    @ObservedObject var viewModel: ClienteViewModel
    @Environment(\.dismiss) var dismiss
    @State private var clienteActual: Cliente

    @State private var nombre: String
    @State private var telefono: String
    @State private var correo: String
    @State private var showEliminar = false

    init(cliente: Cliente, viewModel: ClienteViewModel) {
        self.clienteInicial = cliente
        self.viewModel = viewModel
        _clienteActual = State(initialValue: cliente)
        _nombre = State(initialValue: cliente.nombre)
        _telefono = State(initialValue: cliente.telefono ?? "")
        _correo = State(initialValue: cliente.correo ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    campo("Nombre completo", texto: $nombre, fieldType: .nombre)
                    campo("Teléfono", texto: $telefono, fieldType: .telefono)
                    campo("Correo electrónico", texto: $correo, fieldType: .correo)
                    
                    PrimaryButton(titulo: "Guardar cambios") {
                        var actualizado = clienteActual
                        actualizado.nombre = nombre
                        actualizado.telefono = telefono
                        actualizado.correo = correo
                        viewModel.update(id: clienteActual.id, cliente: actualizado) { success in
                            if success { dismiss() }
                        }
                    }
                    
                    DangerButton(titulo: "Eliminar cliente") {
                        showEliminar = true
                    }
                    
                    Text("⚠️ Eliminar este cliente es irreversible.")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Editar Cliente")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                        .foregroundColor(Color("SecondaryColor"))
                }
            }
            .alert("Eliminar cliente", isPresented: $showEliminar) {
                Button("Eliminar", role: .destructive) {
                    viewModel.delete(id: clienteActual.id) { success in
                        if success { dismiss() }
                    }
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("¿Eliminar a \(clienteActual.nombre)? Esta acción es irreversible.")
            }
        }
    }
    
    enum FieldType {
        case nombre
        case correo
        case telefono
    }

    @ViewBuilder
    func campo(_ titulo: String, texto: Binding<String>, fieldType: FieldType = .nombre) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
            TextField(titulo, text: texto)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("PrimaryColor"), lineWidth: 2))
                .textInputAutocapitalization(fieldType == .correo ? .never : fieldType == .nombre ? .words : .none)
        }
    }
}