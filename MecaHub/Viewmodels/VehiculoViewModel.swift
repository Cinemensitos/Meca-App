import Foundation

class VehiculoViewModel: ObservableObject {
    @Published var vehiculos: [Vehiculo] = []
    @Published var vehiculoSeleccionado: Vehiculo? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    func getAll() {
        isLoading = true
        VehiculoService.getAll { vehiculos in
            self.vehiculos = vehiculos
            self.isLoading = false
        }
    }
    
    func getById(id: Int) {
        VehiculoService.getById(id: id) { vehiculo in
            self.vehiculoSeleccionado = vehiculo
        }
    }
    
    func getByCliente(clienteId: Int) {
        isLoading = true
        VehiculoService.getByCliente(clienteId: clienteId) { vehiculos in
            self.vehiculos = vehiculos
            self.isLoading = false
        }
    }
    
    func save(vehiculo: Vehiculo, completion: @escaping (Bool) -> Void) {
        VehiculoService.save(vehiculo: vehiculo) { result in
            if result != nil {
                self.getAll()
                completion(true)
            } else {
                self.errorMessage = "Error al guardar vehículo"
                completion(false)
            }
        }
    }
    
    func update(id: Int, vehiculo: Vehiculo, completion: @escaping (Bool) -> Void) {
        VehiculoService.update(id: id, vehiculo: vehiculo) { result in
            if result != nil {
                self.getAll()
                completion(true)
            } else {
                self.errorMessage = "Error al actualizar vehículo"
                completion(false)
            }
        }
    }
    
    func delete(id: Int, completion: @escaping (Bool) -> Void) {
        VehiculoService.delete(id: id) { success in
            if success {
                self.vehiculos.removeAll { $0.id == id }
                completion(true)
            } else {
                self.errorMessage = "Error al eliminar vehículo"
                completion(false)
            }
        }
    }
}