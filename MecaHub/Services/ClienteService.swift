import Foundation

class ClienteService {
    
    // Decoder consistente con el resto de services
    private static var decoder: JSONDecoder {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }
    
    private static var encoder: JSONEncoder {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }
    
    static func getAll(completion: @escaping ([Cliente]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/clientes/getAll") else { return }

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
                let clientes = try decoder.decode([Cliente].self, from: data)
                DispatchQueue.main.async { completion(clientes) }
            } catch {
                let responseBody = String(data: data, encoding: .utf8) ?? "sin contenido"
                print("Error decodificando clientes: \(error)")
                print("Respuesta raw: \(responseBody)")
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
    
    static func getById(id: Int, completion: @escaping (Cliente?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/clientes/getById/\(id)") else { return }

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
                let cliente = try decoder.decode(Cliente.self, from: data)
                DispatchQueue.main.async { completion(cliente) }
            } catch {
                let responseBody = String(data: data, encoding: .utf8) ?? "sin contenido"
                print("Error decodificando cliente: \(error)")
                print("Respuesta raw: \(responseBody)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }

    static func save(cliente: Cliente, completion: @escaping (Cliente?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/clientes/save") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(cliente)

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
                let result = try decoder.decode(Cliente.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                let responseBody = String(data: data, encoding: .utf8) ?? "sin contenido"
                print("Error decodificando respuesta save cliente: \(error)")
                print("Respuesta raw: \(responseBody)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }

    static func update(id: Int, cliente: Cliente, completion: @escaping (Cliente?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/clientes/update/\(id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(cliente)

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
                let result = try decoder.decode(Cliente.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                let responseBody = String(data: data, encoding: .utf8) ?? "sin contenido"
                print("Error decodificando respuesta update cliente: \(error)")
                print("Respuesta raw: \(responseBody)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func delete(id: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/clientes/delete/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }
}