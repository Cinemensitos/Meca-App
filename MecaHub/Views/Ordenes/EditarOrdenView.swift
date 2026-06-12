import SwiftUI

struct EditarOrdenView: View {
    let orden: Orden
    @ObservedObject var viewModel: OrdenViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var estado: String
    @State private var costoManoObra: Double
    @State private var costoRefacciones: Double
    @State private var descripcion: String
    @State private var showEliminar = false
    
    let estados = ["recibido", "diagnostico", "reparacion", "listo", "entregado"]
    let estadosLabel = ["Recibido", "Diagnóstico", "En Reparación", "Listo", "Entregado"]
    
    init(orden: Orden, viewModel: OrdenViewModel) {
        self.orden = orden
        self.viewModel = viewModel
        _estado = State(initialValue: orden.estado)
        _costoManoObra = State(initialValue: orden.costoManoObra)
        _costoRefacciones = State(initialValue: orden.costoRefacciones)
        _descripcion = State(initialValue: orden.descripcion ?? "")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // Info no editable
                VStack(alignment: .leading, spacing: 4) {
                    Text(orden.clienteNombre ?? "")
                        .font(.system(size: 17, weight: .semibold))
                    Text(orden.vehiculoDesc ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Estado
                Text("Estado de la orden")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<estados.count, id: \.self) { i in
                            FilterPill(
                                titulo: estadosLabel[i],
                                isActive: estado == estados[i]
                            ) {
                                estado = estados[i]
                            }
                        }
                    }
                }
                
                // Notas
                Text("Notas del servicio")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                
                TextEditor(text: $descripcion)
                    .frame(height: 80)
                    .padding(8)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("PrimaryColor"), lineWidth: 2))
                
                // Costos
                Text("Costos")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()

                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Mano de obra")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("$\(String(format: "%.2f", costoManoObra))")
                                .fontWeight(.semibold)
                        }
                        Stepper(value: $costoManoObra, in: 0...Double.infinity, step: 1.0) {
                            Text("Ajustar mano de obra")
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("PrimaryColor"), lineWidth: 2))
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Refacciones")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("$\(String(format: "%.2f", costoRefacciones))")
                                .fontWeight(.semibold)
                        }
                        Stepper(value: $costoRefacciones, in: 0...Double.infinity, step: 1.0) {
                            Text("Ajustar refacciones")
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("PrimaryColor"), lineWidth: 2))
                    }
                }
                
                PrimaryButton(titulo: "Guardar Orden") {
                    var actualizada = orden
                    actualizada.estado = estado
                    actualizada.costoManoObra = costoManoObra
                    actualizada.costoRefacciones = costoRefacciones
                    actualizada.costoTotal = costoManoObra + costoRefacciones
                    actualizada.descripcion = descripcion.isEmpty ? nil : descripcion
                    viewModel.update(id: orden.id, orden: actualizada) { success in
                        if success { dismiss() }
                    }
                }
                
                DangerButton(titulo: "Eliminar Orden") {
                    showEliminar = true
                }
                
                Text("⚠️ Eliminar esta orden es irreversible.")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.08))
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Editar Orden")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Eliminar orden", isPresented: $showEliminar) {
            Button("Eliminar", role: .destructive) {
                viewModel.delete(id: orden.id) { success in
                    if success { dismiss() }
                }
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("¿Eliminar la orden de \(orden.clienteNombre ?? "")? Esta acción es irreversible.")
        }
    }
}