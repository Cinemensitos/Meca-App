import SwiftUI

struct RegistroView: View {
    @ObservedObject var viewModel: MecanicoViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nombre: String = ""
    @State private var correo: String = ""
    @State private var telefono: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError: Bool = false
    @State private var errorMsg: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                Text("Crear cuenta")
                    .font(.system(size: 26, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Completa tus datos para registrarte")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Avatar placeholder
                ZStack {
                    Circle()
                        .stroke(Color("PrimaryColor").opacity(0.4), lineWidth: 2)
                        .frame(width: 80, height: 80)
                    Image(systemName: "plus")
                        .font(.system(size: 28))
                        .foregroundColor(Color("PrimaryColor"))
                }
                
                Group {
                    campoFormulario(titulo: "Nombre completo", placeholder: "Ej. Carlos Mendoza", texto: $nombre, fieldType: .nombre)
                    campoFormulario(titulo: "Correo electrónico", placeholder: "correo@taller.com", texto: $correo, fieldType: .correo)
                    campoFormulario(titulo: "Teléfono", placeholder: "Ej. 55 1234 5678", texto: $telefono, fieldType: .telefono)
                    campoFormulario(titulo: "Contraseña", placeholder: "••••••••", texto: $password, isSecure: true, fieldType: .password)
                    campoFormulario(titulo: "Confirmar contraseña", placeholder: "••••••••", texto: $confirmPassword, isSecure: true, fieldType: .password)
                }
                
                if showError {
                    Text(errorMsg)
                        .font(.system(size: 13))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                PrimaryButton(titulo: "Crear cuenta") {
                    guard !nombre.isEmpty, !correo.isEmpty, !password.isEmpty else {
                        errorMsg = "Completa todos los campos"
                        showError = true
                        return
                    }

                    if !isValidEmail(correo) {
                        errorMsg = "Ingresa un correo válido"
                        showError = true
                        return
                    }

                    if !telefono.isEmpty {
                        if !isValidPhone(telefono) {
                            errorMsg = "El teléfono solo debe contener números"
                            showError = true
                            return
                        }
                    }

                    guard password == confirmPassword else {
                        errorMsg = "Las contraseñas no coinciden"
                        showError = true
                        return
                    }

                    guard password.count >= 6 else {
                        errorMsg = "La contraseña debe tener al menos 6 caracteres"
                        showError = true
                        return
                    }

                    let nuevo = Mecanico(
                        id: 0,
                        nombre: nombre,
                        correo: correo,
                        telefono: telefono,
                        passwordHash: password
                    )
                    viewModel.save(mecanico: nuevo) { success in
                        if success { dismiss() }
                        else {
                            errorMsg = viewModel.errorMessage
                            showError = true
                        }
                    }
                }
                
                Button("¿Ya tienes cuenta? Inicia sesión") {
                    dismiss()
                }
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("← Volver") { dismiss() }
                    .foregroundColor(Color("PrimaryColor"))
            }
        }
    }
    
    enum FieldType {
        case nombre
        case correo
        case telefono
        case password
    }

    @ViewBuilder
    func campoFormulario(titulo: String, placeholder: String, texto: Binding<String>, isSecure: Bool = false, fieldType: FieldType = .nombre) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
            if isSecure {
                SecureField(placeholder, text: texto)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            } else {
                TextField(placeholder, text: texto)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .keyboardType(fieldType == .correo ? .emailAddress : .default)
                    .textInputAutocapitalization(fieldType == .correo ? .never : fieldType == .nombre ? .words : .none)
            }
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