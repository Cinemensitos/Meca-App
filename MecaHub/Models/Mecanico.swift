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

    var empleadoNumDisplay: String {
        if let empleado = empleadoNum, !empleado.isEmpty {
            return empleado
        }
        return "EMP\(id)"
    }

    var fechaIngresoDisplay: String {
        if let fecha = fechaIngreso, !fecha.isEmpty {
            return formatDate(fecha)
        }
        if let creada = createdAt, !creada.isEmpty {
            return formatDate(creada)
        }
        return "-"
    }

    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd/MM/yyyy"
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

struct LoginRequest: Codable {
    let correo: String
    let passwordHash: String
}