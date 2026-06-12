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
    @State private var showSuccess = false
    @State private var successMessage = ""

    let categorias = ["Frenos", "Motor", "Transmisión", "Suspensión", "Eléctrico", "Carrocería", "Climatización", "Interior", "Otro"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    campo("Nombre", placeholder: "Ej. Pastillas de freno", texto: $nombre)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Categoría")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                        Picker("Categoría", selection: $categoria) {
                            Text("Selecciona una categoría").tag("")
                            ForEach(categorias, id: \.self) { cat in
                                Text(cat).tag(cat)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }

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
                            if success {
                                successMessage = "✓ Pieza creada exitosamente"
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

    func limpiarCampos() {
        nombre = ""
        categoria = ""
        codigo = ""
        precio = ""
        stockActual = ""
        stockMinimo = ""
        descripcion = ""
    }
}