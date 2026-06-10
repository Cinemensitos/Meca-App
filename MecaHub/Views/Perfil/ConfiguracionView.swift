
import SwiftUI

struct ConfiguracionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notifPush: Bool = UserDefaults.standard.bool(forKey: "notifPush") || true
    @State private var notifCorreo: Bool = UserDefaults.standard.bool(forKey: "notifCorreo")
    @State private var notifSonido: Bool = UserDefaults.standard.bool(forKey: "notifSonido") || true
    @State private var estadoEnLinea: Bool = UserDefaults.standard.bool(forKey: "estadoEnLinea") || true
    @State private var compartirStats: Bool = UserDefaults.standard.bool(forKey: "compartirStats")
    
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
            .onChange(of: notifPush) { UserDefaults.standard.set(notifPush, forKey: "notifPush") }
            .onChange(of: notifCorreo) { UserDefaults.standard.set(notifCorreo, forKey: "notifCorreo") }
            .onChange(of: notifSonido) { UserDefaults.standard.set(notifSonido, forKey: "notifSonido") }
            .onChange(of: estadoEnLinea) { UserDefaults.standard.set(estadoEnLinea, forKey: "estadoEnLinea") }
            .onChange(of: compartirStats) { UserDefaults.standard.set(compartirStats, forKey: "compartirStats") }
        }
    }
}
