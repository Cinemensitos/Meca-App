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
                            if !isValidEmail(correo) {
                                errorMsg = "Ingresa un correo válido"
                                showError = true
                                return
                            }
                        }

                        if !telefono.isEmpty {
                            if !isValidPhone(telefono) {
                                errorMsg = "El teléfono solo debe contener números"
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

func isValidEmail(_ email: String) -> Bool {
    let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
    return predicate.evaluate(with: email)
}

func isValidPhone(_ phone: String) -> Bool {
    let phonePattern = "^[0-9\\s\\-\\+\\(\\)]{10,}$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", phonePattern)
    return predicate.evaluate(with: phone)
}