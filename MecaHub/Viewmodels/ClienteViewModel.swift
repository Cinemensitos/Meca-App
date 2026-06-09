import Foundation

class ClienteViewModel: ObservableObject {
    @Published var clientes: [Cliente] = []
    @Published var clienteSeleccionado: Cliente? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    func getAll() {
        isLoading = true
        ClienteService.getAll { clientes in
            self.clientes = clientes
            self.isLoading = false
        }
    }
    
    func getById(id: Int) {
        ClienteService.getById(id: id) { cliente in
            self.clienteSeleccionado = cliente
        }
    }
    
    func save(cliente: Cliente, completion: @escaping (Bool) -> Void) {
        ClienteService.save(cliente: cliente) { result in
            if result != nil {
                self.getAll()
                completion(true)
            } else {
                self.errorMessage = "Error al guardar cliente"
                completion(false)
            }
        }
    }
    
    func update(id: Int, cliente: Cliente, completion: @escaping (Bool) -> Void) {
        ClienteService.update(id: id, cliente: cliente) { result in
            if result != nil {
                self.getAll()
                completion(true)
            } else {
                self.errorMessage = "Error al actualizar cliente"
                completion(false)
            }
        }
    }
    
    func delete(id: Int, completion: @escaping (Bool) -> Void) {
        ClienteService.delete(id: id) { success, errorMessage in
            if success {
                self.clientes.removeAll { $0.id == id }
                completion(true)
            } else {
                self.errorMessage = errorMessage ?? "Error al eliminar cliente"
                completion(false)
            }
        }
    }
}