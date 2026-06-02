import Foundation

struct Pieza: Codable, Identifiable {
    var id: Int
    var nombre: String
    var categoria: String?
    var codigo: String?
    var precio: Double
    var stockActual: Int
    var stockMinimo: Int
    var descripcion: String?
    var estadoStock: String?
    var updatedAt: String?
    
    var stockLabel: String {
        switch estadoStock {
        case "disponible": return "● Disponible"
        case "bajo":       return "● Bajo"
        case "critico":    return "● Crítico"
        case "sin_stock":  return "● Sin stock"
        default:           return "● -"
        }
    }
}