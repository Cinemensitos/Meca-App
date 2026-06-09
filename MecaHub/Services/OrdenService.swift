import Foundation

class OrdenService {
    
    // FIX: decoder con convertFromSnakeCase para recibir campos como
    // cliente_nombre, vehiculo_desc, costo_mano_obra, etc. correctamente.
    private static var decoder: JSONDecoder {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }
    
    // FIX: encoder con convertToSnakeCase para enviar campos como
    // cliente_id, vehiculo_id, costo_mano_obra, etc. al backend.
    private static var encoder: JSONEncoder {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }
    
    static func getAll(completion: @escaping ([Orden]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/ordenes/getAll") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "desconocido")")
                DispatchQueue.main.async { completion([]) }
                return
            }
            do {
                let ordenes = try decoder.decode([Orden].self, from: data)
                DispatchQueue.main.async { completion(ordenes) }
            } catch {
                print("Error decodificando ordenes: \(error)")
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
    
    static func getById(id: Int, completion: @escaping (Orden?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/ordenes/getById/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let orden = try decoder.decode(Orden.self, from: data)
                DispatchQueue.main.async { completion(orden) }
            } catch {
                print("Error decodificando orden: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func getByEstado(estado: String, completion: @escaping ([Orden]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/ordenes/getByEstado/\(estado)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            do {
                let ordenes = try decoder.decode([Orden].self, from: data)
                DispatchQueue.main.async { completion(ordenes) }
            } catch {
                print("Error decodificando ordenes por estado: \(error)")
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
    
    static func getByCliente(clienteId: Int, completion: @escaping ([Orden]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/ordenes/getByCliente/\(clienteId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            do {
                let ordenes = try decoder.decode([Orden].self, from: data)
                DispatchQueue.main.async { completion(ordenes) }
            } catch {
                print("Error decodificando ordenes por cliente: \(error)")
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
    
    static func save(orden: Orden, completion: @escaping (Orden?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/ordenes/save") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(orden)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let result = try decoder.decode(Orden.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                print("Error decodificando respuesta save orden: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func update(id: Int, orden: Orden, completion: @escaping (Orden?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/ordenes/update/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(orden)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let result = try decoder.decode(Orden.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                print("Error decodificando respuesta update orden: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func delete(id: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/ordenes/delete/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }
}