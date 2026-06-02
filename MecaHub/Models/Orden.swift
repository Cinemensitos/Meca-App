import Foundation

struct Orden: Codable, Identifiable {
    var id: Int
    var clienteId: Int
    var clienteNombre: String?
    var vehiculoId: Int
    var vehiculoDesc: String?
    var mecanicoId: Int
    var mecanicoNombre: String?
    var estado: String
    var costoManoObra: Double
    var costoRefacciones: Double
    var costoTotal: Double
    var descripcion: String?
    var createdAt: String?
    var updatedAt: String?
    
    var estadoLabel: String {
        switch estado {
        case "recibido":    return "RECIBIDO"
        case "diagnostico": return "DIAGNÓSTICO"
        case "reparacion":  return "EN REPARACIÓN"
        case "listo":       return "LISTO"
        case "entregado":   return "ENTREGADO"
        default:            return estado.uppercased()
        }
    }
}