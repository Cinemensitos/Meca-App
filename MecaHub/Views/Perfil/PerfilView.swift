import SwiftUI

struct PerfilView: View {
    @ObservedObject var viewModel: MecanicoViewModel
    @State private var showEditar = false
    @State private var showConfig = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    if let mecanico = viewModel.mecanicoActual {
                        
                        // Header
                        VStack(spacing: 8) {
                            AvatarView(iniciales: mecanico.iniciales, size: 80)
                            Text(mecanico.nombre)
                                .font(.system(size: 20, weight: .semibold))
                            Text(mecanico.cargo ?? "Mecánico")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            // Badge activo
                            Text("● Activo")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color.green)
                                .cornerRadius(13)
                        }
                        .padding(.top)
                        
                        Divider()
                        
                        // Info card
                        VStack(spacing: 0) {
                            infoRow(icono: "envelope", label: "Correo", valor: mecanico.correo)
                            Divider().padding(.leading, 44)
                            infoRow(icono: "phone", label: "Teléfono", valor: mecanico.telefono ?? "-")
                            Divider().padding(.leading, 44)
                            infoRow(icono: "creditcard", label: "Empleado #", valor: mecanico.empleadoNum ?? "-")
                            Divider().padding(.leading, 44)
                            infoRow(icono: "calendar", label: "Desde", valor: mecanico.fechaIngreso ?? "-")
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray5)))
                        
                        // Acciones
                        Text("ACCIONES")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 0) {
                            botonAccion(icono: "gearshape", label: "Configuración") {
                                showConfig = true
                            }
                            Divider().padding(.leading, 44)
                            botonAccion(icono: "lock", label: "Cambiar contraseña") {
                                showEditar = true
                            }
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray5)))
                        
                        // Cerrar sesión
                        Button("Cerrar sesión") {
                            viewModel.logout()
                        }
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                        .padding(.top, 8)
                        
                    } else {
                        ProgressView("Cargando perfil...")
                    }
                }
                .padding()
            }
            .navigationTitle("Mi Perfil")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Editar") { showEditar = true }
                        .foregroundColor(Color("PrimaryColor"))
                }
            }
            .sheet(isPresented: $showEditar) {
                if let mecanico = viewModel.mecanicoActual {
                    EditarPerfilView(mecanico: mecanico, viewModel: viewModel)
                }
            }
            .sheet(isPresented: $showConfig) {
                ConfiguracionView()
            }
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
                .font(.system(size: 14))
        }
        .padding()
    }
    
    @ViewBuilder
    func botonAccion(icono: String, label: String, accion: @escaping () -> Void) -> some View {
        Button(action: accion) {
            HStack(spacing: 12) {
                Image(systemName: icono)
                    .foregroundColor(.secondary)
                    .frame(width: 24)
                Text(label)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))
            }
            .padding()
        }
    }
}