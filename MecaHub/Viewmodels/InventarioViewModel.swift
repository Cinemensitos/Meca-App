import Foundation

class InventarioViewModel: ObservableObject {
    @Published var piezas: [Pieza] = []
    @Published var piezaSeleccionada: Pieza? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var filtroStock: String = "todos"
    
    func getAll() {
        isLoading = true
        InventarioService.getAll { piezas in
            self.piezas = piezas
            self.isLoading = false
        }
    }
    
    func getById(id: Int) {
        InventarioService.getById(id: id) { pieza in
            self.piezaSeleccionada = pieza
        }
    }
    
    func getByEstado(estado: String) {
        isLoading = true
        InventarioService.getByEstado(estado: estado) { piezas in
            self.piezas = piezas
            self.isLoading = false
        }
    }
    
    func save(pieza: Pieza, completion: @escaping (Bool) -> Void) {
        InventarioService.save(pieza: pieza) { result in
            if result != nil {
                self.getAll()
                completion(true)
            } else {
                self.errorMessage = "Error al guardar pieza"
                completion(false)
            }
        }
    }
    
    func update(id: Int, pieza: Pieza, completion: @escaping (Bool) -> Void) {
        InventarioService.update(id: id, pieza: pieza) { result in
            if result != nil {
                self.getAll()
                completion(true)
            } else {
                self.errorMessage = "Error al actualizar pieza"
                completion(false)
            }
        }
    }
    
    func delete(id: Int, completion: @escaping (Bool) -> Void) {
        InventarioService.delete(id: id) { success, errorMessage in
            if success {
                self.piezas.removeAll { $0.id == id }
                completion(true)
            } else {
                self.errorMessage = errorMessage ?? "Error al eliminar pieza"
                completion(false)
            }
        }
    }
    
    // Filtra localmente sin llamar a la API
    var piezasFiltradas: [Pieza] {
        if filtroStock == "todos" {
            return piezas
        }
        return piezas.filter { $0.estadoStock == filtroStock }
    }
}