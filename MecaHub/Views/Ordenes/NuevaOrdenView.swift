import SwiftUI

struct NuevaOrdenView: View {
    @ObservedObject var viewModel: OrdenViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var clienteId: Int = 0
    @State private var vehiculoId: Int = 0
    @State private var mecanicoId: Int = 0
    @State private var estado: String = "recibido"
    @State private var costoManoObra: String = "0"
    @State private var costoRefacciones: String = "0"
    @State private var descripcion: String = ""
    @State private var showError: Bool = false
    
    @StateObject var clienteVM   = ClienteViewModel()
    @StateObject var vehiculoVM  = VehiculoViewModel()
    @StateObject var mecanicoVM  = MecanicoViewModel()
    
    let estados = ["recibido", "diagnostico", "reparacion", "listo", "entregado"]
    let estadosLabel = ["Recibido", "Diagnóstico", "En Reparación", "Listo", "Entregado"]
    
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
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Mano de obra")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                            TextField("0.00", text: $costoManoObra)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Refacciones")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                            TextField("0.00", text: $costoRefacciones)
                                .keyboardType(.decimalPad)
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
                            costoManoObra: Double(costoManoObra) ?? 0,
                            costoRefacciones: Double(costoRefacciones) ?? 0,
                            costoTotal: 0,
                            descripcion: descripcion
                        )
                        viewModel.save(orden: nueva) { success in
                            if success { dismiss() }
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
}