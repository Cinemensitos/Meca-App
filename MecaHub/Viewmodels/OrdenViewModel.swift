import Foundation

class OrdenViewModel: ObservableObject {
    @Published var ordenes: [Orden] = []
    @Published var ordenSeleccionada: Orden? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var filtroEstado: String = "todos"
    
    func getAll() {
        isLoading = true
        OrdenService.getAll { ordenes in
            self.ordenes = ordenes
            self.isLoading = false
        }
    }
    
    func getById(id: Int) {
        OrdenService.getById(id: id) { orden in
            self.ordenSeleccionada = orden
        }
    }
    
    func getByEstado(estado: String) {
        isLoading = true
        OrdenService.getByEstado(estado: estado) { ordenes in
            self.ordenes = ordenes
            self.isLoading = false
        }
    }
    
    func getByCliente(clienteId: Int) {
        isLoading = true
        OrdenService.getByCliente(clienteId: clienteId) { ordenes in
            self.ordenes = ordenes
            self.isLoading = false
        }
    }
    
    func save(orden: Orden, completion: @escaping (Bool) -> Void) {
        OrdenService.save(orden: orden) { result in
            if result != nil {
                self.getAll()
                completion(true)
            } else {
                self.errorMessage = "Error al guardar orden"
                completion(false)
            }
        }
    }
    
    func update(id: Int, orden: Orden, completion: @escaping (Bool) -> Void) {
        OrdenService.update(id: id, orden: orden) { result in
            if result != nil {
                self.getAll()
                completion(true)
            } else {
                self.errorMessage = "Error al actualizar orden"
                completion(false)
            }
        }
    }
    
    func delete(id: Int, completion: @escaping (Bool) -> Void) {
        OrdenService.delete(id: id) { success in
            if success {
                self.ordenes.removeAll { $0.id == id }
                completion(true)
            } else {
                self.errorMessage = "Error al eliminar orden"
                completion(false)
            }
        }
    }
    
    // Filtra localmente sin llamar a la API
    var ordenesFiltradas: [Orden] {
        if filtroEstado == "todos" {
            return ordenes
        }
        return ordenes.filter { $0.estado == filtroEstado }
    }
}