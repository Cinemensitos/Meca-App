import Foundation

struct Mecanico: Codable, Identifiable, Equatable {
    var id: Int
    var nombre: String
    var correo: String
    var telefono: String?
    var cargo: String?
    var passwordHash: String?
    var empleadoNum: String?
    var estado: String?
    var fechaIngreso: String?
    var createdAt: String?

    var iniciales: String {
        let partes = nombre.split(separator: " ")
        let primera = partes.first?.prefix(1) ?? ""
        let segunda = partes.dropFirst().first?.prefix(1) ?? ""
        return "\(primera)\(segunda)".uppercased()
    }
}

struct LoginRequest: Codable {
    let correo: String
    let passwordHash: String
}