import Foundation

struct Cliente: Codable, Identifiable {
    var id: Int
    var nombre: String
    var telefono: String?
    var correo: String?
    var createdAt: String?
    
}