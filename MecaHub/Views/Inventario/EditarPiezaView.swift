import SwiftUI

struct EditarPiezaView: View {
    let pieza: Pieza
    @ObservedObject var viewModel: InventarioViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nombre: String
    @State private var categoria: String
    @State private var codigo: String
    @State private var precio: String
    @State private var stockActual: String
    @State private var stockMinimo: String
    @State private var descripcion: String
    @State private var showEliminar = false
    
    init(pieza: Pieza, viewModel: InventarioViewModel) {
        self.pieza = pieza
        self.viewModel = viewModel
        _nombre = State(initialValue: pieza.nombre)
        _categoria = State(initialValue: pieza.categoria ?? "")
        _codigo = State(initialValue: pieza.codigo ?? "")
        _precio = State(initialValue: String(pieza.precio))
        _stockActual = State(initialValue: String(pieza.stockActual))
        _stockMinimo = State(initialValue: String(pieza.stockMinimo))
        _descripcion = State(initialValue: pieza.descripcion ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    campo("Nombre", texto: $nombre)
                    campo("Categoría", texto: $categoria)
                    campo("Código", texto: $codigo)
                    
                    HStack(spacing: 12) {
                        campoParcial("Precio ($)", texto: $precio)
                        campoParcial("Stock actual", texto: $stockActual)
                    }
                    campoParcial("Stock mínimo", texto: $stockMinimo)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Descripción")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                        TextEditor(text: $descripcion)
                            .frame(height: 80)
                            .padding(8)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("PrimaryColor"), lineWidth: 2))
                    }
                    
                    PrimaryButton(titulo: "Guardar cambios") {
                        var actualizada = pieza
                        actualizada.nombre = nombre
                        actualizada.categoria = categoria
                        actualizada.codigo = codigo
                        actualizada.precio = Double(precio) ?? 0
                        actualizada.stockActual = Int(stockActual) ?? 0
                        actualizada.stockMinimo = Int(stockMinimo) ?? 5
                        actualizada.descripcion = descripcion
                        viewModel.update(id: pieza.id, pieza: actualizada) { success in
                            if success { dismiss() }
                        }
                    }
                    
                    DangerButton(titulo: "Eliminar pieza") {
                        showEliminar = true
                    }
                    
                    Text("⚠️ Eliminar esta pieza es irreversible.")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Editar Pieza")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                        .foregroundColor(Color("SecondaryColor"))
                }
            }
            .alert("Eliminar pieza", isPresented: $showEliminar) {
                Button("Eliminar", role: .destructive) {
                    viewModel.delete(id: pieza.id) { success in
                        if success { dismiss() }
                    }
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("¿Eliminar \(pieza.nombre)? Esta acción es irreversible.")
            }
        }
    }
    
    @ViewBuilder
    func campo(_ titulo: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
            TextField(titulo, text: texto)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("PrimaryColor"), lineWidth: 2))
        }
    }
    
    @ViewBuilder
    func campoParcial(_ titulo: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
            TextField(titulo, text: texto)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("PrimaryColor"), lineWidth: 2))
        }
    }
}