import SwiftUI

struct NuevaOrdenView: View {
    @ObservedObject var viewModel: OrdenViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var clienteId: Int = 0
    @State private var vehiculoId: Int = 0
    @State private var mecanicoId: Int = 0
    @State private var estado: String = "recibido"
    @State private var costoManoObra: Double = 0
    @State private var costoRefacciones: Double = 0
    @State private var descripcion: String = ""
    @State private var showError: Bool = false
    @State private var showSuccess: Bool = false
    @State private var successMessage: String = ""
    
    @StateObject var clienteVM   = ClienteViewModel()
    @StateObject var vehiculoVM  = VehiculoViewModel()
    @StateObject var mecanicoVM  = MecanicoViewModel()
    
    let estados = ["recibido", "diagnostico", "reparacion"]
    let estadosLabel = ["Recibido", "Diagnóstico", "En Reparación"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Sección Cliente
                    seccionHeader("1. Cliente")
                    Picker("Cliente", selection: $clienteId) {
                        Text("Selecciona un cliente").tag(0)
                        ForEach(clienteVM.clientes) { cliente in
                            Text(cliente.nombre).tag(cliente.id)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Sección Vehículo
                    seccionHeader("2. Vehículo")
                    Picker("Vehículo", selection: $vehiculoId) {
                        Text("Selecciona un vehículo").tag(0)
                        ForEach(vehiculoVM.vehiculos) { vehiculo in
                            Text("\(vehiculo.marca) \(vehiculo.modelo) \(vehiculo.anio)").tag(vehiculo.id)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Sección Mecánico
                    seccionHeader("3. Mecánico asignado")
                    Picker("Mecánico", selection: $mecanicoId) {
                        Text("Selecciona un mecánico").tag(0)
                        ForEach(mecanicoVM.mecanicos) { mecanico in
                            Text(mecanico.nombre).tag(mecanico.id)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Sección Estado
                    seccionHeader("4. Estado inicial")
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
                    
                    // Sección Descripción
                    seccionHeader("5. Descripción del servicio")
                    TextEditor(text: $descripcion)
                        .frame(height: 80)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    
                    // Costos
                    seccionHeader("6. Costos")
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
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
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
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    
                    if showError {
                        Text("Selecciona cliente, vehículo y mecánico")
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

                    PrimaryButton(titulo: "Guardar Orden") {
                        guard clienteId != 0, vehiculoId != 0, mecanicoId != 0 else {
                            showError = true
                            return
                        }
                        let nueva = Orden(
                            id: 0,
                            clienteId: clienteId,
                            vehiculoId: vehiculoId,
                            mecanicoId: mecanicoId,
                            estado: estado,
                            costoManoObra: costoManoObra,
                            costoRefacciones: costoRefacciones,
                            costoTotal: costoManoObra + costoRefacciones,
                            descripcion: descripcion
                        )
                        viewModel.save(orden: nueva) { success in
                            if success {
                                successMessage = "✓ Orden creada exitosamente"
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
                        dismiss()
                    }
                }
                .padding()
            }
            .navigationTitle("Nueva Orden")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                clienteVM.getAll()
                vehiculoVM.getAll()
                mecanicoVM.getAll()
            }
        }
    }
    
    @ViewBuilder
    func seccionHeader(_ titulo: String) -> some View {
        Text(titulo)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
        Divider()
    }

    func limpiarCampos() {
        clienteId = 0
        vehiculoId = 0
        mecanicoId = 0
        estado = "recibido"
        costoManoObra = 0
        costoRefacciones = 0
        descripcion = ""
    }
}