
import SwiftUI

struct ConfiguracionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notifPush: Bool = true
    @State private var notifCorreo: Bool = false
    @State private var notifSonido: Bool = true
    @State private var estadoEnLinea: Bool = true
    @State private var compartirStats: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                
                Section("NOTIFICACIONES") {
                    Toggle("Notificaciones push", isOn: $notifPush)
                    Toggle("Correo electrónico", isOn: $notifCorreo)
                    Toggle("Sonido", isOn: $notifSonido)
                }
                
                Section("PRIVACIDAD") {
                    Toggle("Mostrar estado en línea", isOn: $estadoEnLinea)
                    Toggle("Compartir estadísticas", isOn: $compartirStats)
                }
                
                Section("APLICACIÓN") {
                    HStack {
                        Text("Idioma")
                        Spacer()
                        Text("Español")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Configuración")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("← Perfil") { dismiss() }
                        .foregroundColor(Color("PrimaryColor"))
                }
            }
            .accentColor(Color("PrimaryColor"))
        }
    }
}
