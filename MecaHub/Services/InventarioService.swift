import Foundation

class InventarioService {

    // decoder sin conversión (el servidor envía camelCase)
    private static var decoder: JSONDecoder {
        let d = JSONDecoder()
        return d
    }

    // encoder sin conversión (el servidor espera camelCase)
    private static var encoder: JSONEncoder {
        let e = JSONEncoder()
        return e
    }
    
    static func getAll(completion: @escaping ([Pieza]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/inventario/getAll") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error en request getAll: \(error.localizedDescription)")
                DispatchQueue.main.async { completion([]) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta getAll no es HTTP válida")
                DispatchQueue.main.async { completion([]) }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let responseBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? "sin contenido"
                print("Error HTTP getAll (\(httpResponse.statusCode)): \(responseBody)")
                DispatchQueue.main.async { completion([]) }
                return
            }

            guard let data = data else {
                print("Sin datos en respuesta getAll")
                DispatchQueue.main.async { completion([]) }
                return
            }

            do {
                let piezas = try decoder.decode([Pieza].self, from: data)
                DispatchQueue.main.async { completion(piezas) }
            } catch {
                let responseBody = String(data: data, encoding: .utf8) ?? "sin contenido"
                print("Error decodificando inventario: \(error)")
                print("Respuesta raw: \(responseBody)")
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
    
    static func getById(id: Int, completion: @escaping (Pieza?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/inventario/getById/\(id)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error en request getById: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta getById no es HTTP válida")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let responseBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? "sin contenido"
                print("Error HTTP getById (\(httpResponse.statusCode)): \(responseBody)")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            guard let data = data else {
                print("Sin datos en respuesta getById")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            do {
                let pieza = try decoder.decode(Pieza.self, from: data)
                DispatchQueue.main.async { completion(pieza) }
            } catch {
                let responseBody = String(data: data, encoding: .utf8) ?? "sin contenido"
                print("Error decodificando pieza: \(error)")
                print("Respuesta raw: \(responseBody)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }

    static func getByEstado(estado: String, completion: @escaping ([Pieza]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/inventario/getByEstado/\(estado)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error en request getByEstado: \(error.localizedDescription)")
                DispatchQueue.main.async { completion([]) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta getByEstado no es HTTP válida")
                DispatchQueue.main.async { completion([]) }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let responseBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? "sin contenido"
                print("Error HTTP getByEstado (\(httpResponse.statusCode)): \(responseBody)")
                DispatchQueue.main.async { completion([]) }
                return
            }

            guard let data = data else {
                print("Sin datos en respuesta getByEstado")
                DispatchQueue.main.async { completion([]) }
                return
            }

            do {
                let piezas = try decoder.decode([Pieza].self, from: data)
                DispatchQueue.main.async { completion(piezas) }
            } catch {
                let responseBody = String(data: data, encoding: .utf8) ?? "sin contenido"
                print("Error decodificando inventario por estado: \(error)")
                print("Respuesta raw: \(responseBody)")
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }

    static func save(pieza: Pieza, completion: @escaping (Pieza?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/inventario/save") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(pieza)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en request save: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta save no es HTTP válida")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let responseBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? "sin contenido"
                print("Error HTTP save (\(httpResponse.statusCode)): \(responseBody)")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            guard let data = data else {
                print("Sin datos en respuesta save")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            do {
                let result = try decoder.decode(Pieza.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                let responseBody = String(data: data, encoding: .utf8) ?? "sin contenido"
                print("Error decodificando respuesta save pieza: \(error)")
                print("Respuesta raw: \(responseBody)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }

    static func update(id: Int, pieza: Pieza, completion: @escaping (Pieza?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/inventario/update/\(id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(pieza)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en request update: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta update no es HTTP válida")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let responseBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? "sin contenido"
                print("Error HTTP update (\(httpResponse.statusCode)): \(responseBody)")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            guard let data = data else {
                print("Sin datos en respuesta update")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            do {
                let result = try decoder.decode(Pieza.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                let responseBody = String(data: data, encoding: .utf8) ?? "sin contenido"
                print("Error decodificando respuesta update pieza: \(error)")
                print("Respuesta raw: \(responseBody)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func delete(id: Int, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/inventario/delete/\(id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en request delete: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(false, error.localizedDescription) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta delete no es HTTP válida")
                DispatchQueue.main.async { completion(false, "Error de conexión") }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let responseBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? "sin contenido"
                print("Error HTTP delete (\(httpResponse.statusCode)): \(responseBody)")

                let errorMsg: String
                if responseBody.contains("foreign key constraint") {
                    errorMsg = "No se puede eliminar esta pieza porque está vinculada a órdenes. Elimina primero las órdenes que la usan."
                } else {
                    errorMsg = "Error al eliminar pieza (HTTP \(httpResponse.statusCode))"
                }
                DispatchQueue.main.async { completion(false, errorMsg) }
                return
            }

            DispatchQueue.main.async { completion(true, nil) }
        }.resume()
    }
}