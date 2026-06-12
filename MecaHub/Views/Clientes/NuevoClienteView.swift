import SwiftUI

struct NuevoClienteView: View {
    @ObservedObject var viewModel: ClienteViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nombre: String = ""
    @State private var telefono: String = ""
    @State private var correo: String = ""
    @State private var showError: Bool = false
    @State private var errorMsg: String = ""
    @State private var showSuccess: Bool = false
    @State private var successMessage: String = ""
    
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

                    if showSuccess {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(successMessage)
                                .font(.system(size: 13))
                                .foregroundColor(.green)
                        }
                        .padding(10)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }

                    PrimaryButton(titulo: "Guardar") {
                        guard !nombre.isEmpty else {
                            errorMsg = "El nombre es obligatorio"
                            showError = true
                            return
                        }

                        if !correo.isEmpty && !correo.isValidEmail {
                            errorMsg = "Ingresa un correo válido"
                            showError = true
                            return
                        }

                        if !telefono.isEmpty && !telefono.isValidPhone {
                            errorMsg = "El teléfono solo debe contener números"
                            showError = true
                            return
                        }

                        let nuevo = Cliente(id: 0, nombre: nombre, telefono: telefono, correo: correo)
                        viewModel.save(cliente: nuevo) { success in
                            if success {
                                successMessage = "✓ Cliente creado exitosamente"
                                showSuccess = true
                                showError = false

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    limpiarCampos()
                                    showSuccess = false
                                }
                            }
                        }
                    }
                    
                    SecondaryButton(titulo: "Cancelar") {
                        limpiarCampos()
                        dismiss()
                    }
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

    func limpiarCampos() {
        nombre = ""
        telefono = ""
        correo = ""
    }
}