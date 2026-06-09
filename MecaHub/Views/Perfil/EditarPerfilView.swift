import SwiftUI

struct EditarPerfilView: View {
    let mecanico: Mecanico
    @ObservedObject var viewModel: MecanicoViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nombre: String
    @State private var correo: String
    @State private var telefono: String
    @State private var cargo: String
    @State private var showEliminar = false
    
    init(mecanico: Mecanico, viewModel: MecanicoViewModel) {
        self.mecanico = mecanico
        self.viewModel = viewModel
        _nombre = State(initialValue: mecanico.nombre)
        _correo = State(initialValue: mecanico.correo)
        _telefono = State(initialValue: mecanico.telefono ?? "")
        _cargo = State(initialValue: mecanico.cargo ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Avatar
                    AvatarView(iniciales: mecanico.iniciales, size: 80)
                    Button("Cambiar foto") {}
                        .foregroundColor(Color("PrimaryColor"))
                        .font(.system(size: 12))
                    
                    campo("Nombre completo", texto: $nombre, fieldType: .nombre)
                    campo("Cargo / Rol", texto: $cargo, fieldType: .nombre)
                    campo("Teléfono", texto: $telefono, fieldType: .telefono)
                    campo("Correo electrónico", texto: $correo, fieldType: .correo)
                    
                    PrimaryButton(titulo: "Guardar cambios") {
                        var actualizado = mecanico
                        actualizado.nombre = nombre
                        actualizado.correo = correo
                        actualizado.telefono = telefono
                        actualizado.cargo = cargo
                        viewModel.update(id: mecanico.id, mecanico: actualizado) { success in
                            if success { dismiss() }
                        }
                    }
                    
                    DangerButton(titulo: "Eliminar cuenta") {
                        showEliminar = true
                    }
                    
                    Text("⚠️ Eliminar la cuenta es permanente e irreversible.")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                        .foregroundColor(Color("SecondaryColor"))
                }
            }
            .alert("Eliminar cuenta", isPresented: $showEliminar) {
                Button("Eliminar", role: .destructive) {
                    viewModel.delete(id: mecanico.id) { success in
                        if success { dismiss() }
                    }
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("¿Seguro que deseas eliminar tu cuenta? Esta acción es irreversible.")
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