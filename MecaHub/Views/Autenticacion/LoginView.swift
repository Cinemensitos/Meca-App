import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel = MecanicoViewModel()
    @State private var correo: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Logo
                    VStack(spacing: 12) {
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                            .cornerRadius(24)
                        
                        Text("MechTrack")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Gestión de taller automotriz")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    Divider()
                    
                    // Formulario
                    VStack(spacing: 16) {
                        Text("Iniciar sesión")
                            .font(.system(size: 22, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Correo electrónico")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                            TextField("correo@taller.com", text: $correo)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Contraseña")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                            SecureField("••••••••", text: $password)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                        
                        if showError {
                            Text(viewModel.errorMessage)
                                .font(.system(size: 13))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            PrimaryButton(titulo: "Iniciar sesión") {
                                viewModel.login(correo: correo, password: password) { success in
                                    if !success { showError = true }
                                }
                            }
                        }
                    }
                    
                    // Link registro
                    NavigationLink {
                        RegistroView(viewModel: viewModel)
                    } label: {
                        Text("¿No tienes cuenta? ")
                            .foregroundColor(.secondary)
                        + Text("Regístrate")
                            .foregroundColor(Color("PrimaryColor"))
                            .fontWeight(.semibold)
                    }
                    .font(.system(size: 14))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}