import SwiftUI

struct EditarPiezaView: View {
    let piezaInicial: Pieza
    @ObservedObject var viewModel: InventarioViewModel
    @Environment(\.dismiss) var dismiss
    @State private var piezaActual: Pieza

    @State private var nombre: String
    @State private var categoria: String
    @State private var codigo: String
    @State private var precioDouble: Double
    @State private var stockActualInt: Int
    @State private var stockMinimoInt: Int
    @State private var descripcion: String
    @State private var showEliminar = false
    @State private var showErrorEliminar = false
    @State private var errorEliminarMsg = ""

    let categorias = ["Frenos", "Motor", "Transmisión", "Suspensión", "Eléctrico", "Carrocería", "Climatización", "Interior", "Otro"]

    init(pieza: Pieza, viewModel: InventarioViewModel) {
        self.piezaInicial = pieza
        self.viewModel = viewModel
        _piezaActual = State(initialValue: pieza)
        _nombre = State(initialValue: pieza.nombre)
        _categoria = State(initialValue: pieza.categoria ?? "")
        _codigo = State(initialValue: pieza.codigo ?? "")
        _precioDouble = State(initialValue: pieza.precio)
        _stockActualInt = State(initialValue: pieza.stockActual)
        _stockMinimoInt = State(initialValue: pieza.stockMinimo)
        _descripcion = State(initialValue: pieza.descripcion ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    campo("Nombre", texto: $nombre)

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
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("PrimaryColor"), lineWidth: 2))
                    }

                    campo("Código", texto: $codigo)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Precio ($)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(String(format: "%.2f", precioDouble))
                                .fontWeight(.semibold)
                        }
                        Stepper(value: $precioDouble, in: 0...Double.infinity, step: 0.1) {
                            Text("Ajustar precio")
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("PrimaryColor"), lineWidth: 2))
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Stock actual")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(stockActualInt)")
                                .fontWeight(.semibold)
                        }
                        Stepper(value: $stockActualInt, in: 0...Int.max, step: 1) {
                            Text("Ajustar stock")
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("PrimaryColor"), lineWidth: 2))
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Stock mínimo")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(stockMinimoInt)")
                                .fontWeight(.semibold)
                        }
                        Stepper(value: $stockMinimoInt, in: 0...Int.max, step: 1) {
                            Text("Ajustar stock mínimo")
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("PrimaryColor"), lineWidth: 2))
                    }
                    
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
                        var actualizada = piezaActual
                        actualizada.nombre = nombre
                        actualizada.categoria = categoria.isEmpty ? nil : categoria
                        actualizada.codigo = codigo.isEmpty ? nil : codigo
                        actualizada.precio = precioDouble
                        actualizada.stockActual = stockActualInt
                        actualizada.stockMinimo = stockMinimoInt
                        actualizada.descripcion = descripcion.isEmpty ? nil : descripcion
                        viewModel.update(id: piezaActual.id, pieza: actualizada) { success in
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
                    viewModel.delete(id: piezaActual.id) { success in
                        if success {
                            dismiss()
                        } else {
                            errorEliminarMsg = viewModel.errorMessage
                            showErrorEliminar = true
                        }
                    }
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("¿Eliminar \(piezaActual.nombre)? Esta acción es irreversible.")
            }
            .alert("Error al eliminar", isPresented: $showErrorEliminar) {
                Button("Entendido", role: .cancel) {}
            } message: {
                Text(errorEliminarMsg)
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