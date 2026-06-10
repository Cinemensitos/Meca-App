import SwiftUI

struct NuevoClienteView: View {
    @ObservedObject var viewModel: ClienteViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nombre: String = ""
    @State private var telefono: String = ""
    @State private var correo: String = ""
    @State private var showError: Bool = false
    @State private var errorMsg: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    campo("Nombre completo", placeholder: "Ej. Juan García", texto: $nombre, fieldType: .nombre)
                    campo("Teléfono", placeholder: "Ej. 55 1234 5678", texto: $telefono, fieldType: .telefono)
                        .keyboardType(.phonePad)
                    campo("Correo electrónico", placeholder: "juan@email.com", texto: $correo, fieldType: .correo)
                        .keyboardType(.emailAddress)
                    
                    if showError {
                        Text(errorMsg)
                            .font(.system(size: 13))
                            .foregroundColor(.red)
                    }

                    PrimaryButton(titulo: "Guardar") {
                        guard !nombre.isEmpty else {
                            errorMsg = "El nombre es obligatorio"
                            showError = true
                            return
                        }

                        if !correo.isEmpty {
                            if let emailError = ValidationHelper.validateEmail(correo) {
                                errorMsg = emailError
                                showError = true
                                return
                            }
                        }

                        if !telefono.isEmpty {
                            if let phoneError = ValidationHelper.validatePhone(telefono) {
                                errorMsg = phoneError
                                showError = true
                                return
                            }
                        }

                        let nuevo = Cliente(id: 0, nombre: nombre, telefono: telefono, correo: correo)
                        viewModel.save(cliente: nuevo) { success in
                            if success { dismiss() }
                        }
                    }
                    
                    SecondaryButton(titulo: "Cancelar") { dismiss() }
                }
                .padding()
            }
            .navigationTitle("Nuevo Cliente")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    enum FieldType {
        case nombre
        case correo
        case telefono
    }

    @ViewBuilder
    func campo(_ titulo: String, placeholder: String, texto: Binding<String>, fieldType: FieldType = .nombre) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
            TextField(placeholder, text: texto)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .textInputAutocapitalization(fieldType == .correo ? .never : fieldType == .nombre ? .words : .none)
        }
    }
}