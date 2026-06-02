import SwiftUI

struct NuevaPiezaView: View {
    @ObservedObject var viewModel: InventarioViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nombre: String = ""
    @State private var categoria: String = ""
    @State private var codigo: String = ""
    @State private var precio: String = ""
    @State private var stockActual: String = ""
    @State private var stockMinimo: String = ""
    @State private var descripcion: String = ""
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    campo("Nombre", placeholder: "Ej. Pastillas de freno", texto: $nombre)
                    campo("Categoría", placeholder: "Ej. Frenos", texto: $categoria)
                    campo("Código", placeholder: "Ej. BRKPD-001", texto: $codigo)
                    
                    HStack(spacing: 12) {
                        campoParcial("Precio ($)", placeholder: "0.00", texto: $precio)
                        campoParcial("Stock inicial", placeholder: "0", texto: $stockActual)
                    }
                    campoParcial("Stock mínimo", placeholder: "5", texto: $stockMinimo)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Descripción")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                        TextEditor(text: $descripcion)
                            .frame(height: 80)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    if showError {
                        Text("Nombre y precio son obligatorios")
                            .font(.system(size: 13))
                            .foregroundColor(.red)
                    }
                    
                    PrimaryButton(titulo: "Guardar") {
                        guard !nombre.isEmpty, !precio.isEmpty else {
                            showError = true
                            return
                        }
                        let nueva = Pieza(
                            id: 0,
                            nombre: nombre,
                            categoria: categoria,
                            codigo: codigo,
                            precio: Double(precio) ?? 0,
                            stockActual: Int(stockActual) ?? 0,
                            stockMinimo: Int(stockMinimo) ?? 5,
                            descripcion: descripcion
                        )
                        viewModel.save(pieza: nueva) { success in
                            if success { dismiss() }
                        }
                    }
                    
                    SecondaryButton(titulo: "Cancelar") { dismiss() }
                }
                .padding()
            }
            .navigationTitle("Nueva Pieza")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    func campo(_ titulo: String, placeholder: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
            TextField(placeholder, text: texto)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
    
    @ViewBuilder
    func campoParcial(_ titulo: String, placeholder: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
            TextField(placeholder, text: texto)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}