import Foundation

struct Vehiculo: Codable, Identifiable, Equatable {
    var id: Int
    var clienteId: Int
    var clienteNombre: String?
    var marca: String
    var modelo: String
    var anio: Int
    var placas: String?
    var vin: String?
    var createdAt: String?

}