import Foundation

class MecanicoViewModel: ObservableObject {
    @Published var mecanicos: [Mecanico] = []
    @Published var mecanicoActual: Mecanico? = nil
    @Published var isLoading: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
    func getAll() {
        isLoading = true
        MecanicoService.getAll { mecanicos in
            self.mecanicos = mecanicos
            self.isLoading = false
        }
    }
    
    func getById(id: Int) {
        MecanicoService.getById(id: id) { mecanico in
            self.mecanicoActual = mecanico
        }
    }
    
    func login(correo: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        MecanicoService.login(correo: correo, password: password) { mecanico in
            self.isLoading = false
            if let mecanico = mecanico {
                self.mecanicoActual = mecanico
                self.isLoggedIn = true
                print("✅ Login exitoso:")
                print("  - ID: \(mecanico.id)")
                print("  - Nombre: \(mecanico.nombre)")
                print("  - Correo: \(mecanico.correo)")
                print("  - Teléfono: \(mecanico.telefono ?? "nil")")
                print("  - Cargo: \(mecanico.cargo ?? "nil")")
                print("  - Empleado #: \(mecanico.empleadoNum ?? "nil")")
                print("  - Estado: \(mecanico.estado ?? "nil")")
                print("  - Fecha Ingreso: \(mecanico.fechaIngreso ?? "nil")")
                print("  - Created At: \(mecanico.createdAt ?? "nil")")
                completion(true)
            } else {
                self.errorMessage = "Correo o contraseña incorrectos"
                self.isLoggedIn = false
                completion(false)
            }
        }
    }
    
    func logout() {
        mecanicoActual = nil
        isLoggedIn = false
    }
    
    func save(mecanico: Mecanico, completion: @escaping (Bool) -> Void) {
        MecanicoService.save(mecanico: mecanico) { result in
            if result != nil {
                self.getAll()
                completion(true)
            } else {
                self.errorMessage = "Error al guardar mecánico"
                completion(false)
            }
        }
    }
    
    func update(id: Int, mecanico: Mecanico, completion: @escaping (Bool) -> Void) {
        MecanicoService.update(id: id, mecanico: mecanico) { result in
            if let result = result {
                self.mecanicoActual = result
                completion(true)
            } else {
                self.errorMessage = "Error al actualizar mecánico"
                completion(false)
            }
        }
    }
    
    func delete(id: Int, completion: @escaping (Bool) -> Void) {
        MecanicoService.delete(id: id) { success in
            if success {
                self.logout()
                completion(true)
            } else {
                self.errorMessage = "Error al eliminar mecánico"
                completion(false)
            }
        }
    }
}