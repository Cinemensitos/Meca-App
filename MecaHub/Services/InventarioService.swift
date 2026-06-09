import Foundation

class InventarioService {
    
    // FIX: decoder con convertFromSnakeCase para recibir stock_actual, stock_minimo,
    // estado_stock, updated_at correctamente.
    private static var decoder: JSONDecoder {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }
    
    // FIX: encoder con convertToSnakeCase para enviar stock_actual, stock_minimo al backend.
    private static var encoder: JSONEncoder {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }
    
    static func getAll(completion: @escaping ([Pieza]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/inventario/getAll") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "desconocido")")
                DispatchQueue.main.async { completion([]) }
                return
            }
            do {
                let piezas = try decoder.decode([Pieza].self, from: data)
                DispatchQueue.main.async { completion(piezas) }
            } catch {
                print("Error decodificando inventario: \(error)")
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
    
    static func getById(id: Int, completion: @escaping (Pieza?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/inventario/getById/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let pieza = try decoder.decode(Pieza.self, from: data)
                DispatchQueue.main.async { completion(pieza) }
            } catch {
                print("Error decodificando pieza: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func getByEstado(estado: String, completion: @escaping ([Pieza]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/inventario/getByEstado/\(estado)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            do {
                let piezas = try decoder.decode([Pieza].self, from: data)
                DispatchQueue.main.async { completion(piezas) }
            } catch {
                print("Error decodificando inventario por estado: \(error)")
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
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let result = try decoder.decode(Pieza.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                print("Error decodificando respuesta save pieza: \(error)")
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
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let result = try decoder.decode(Pieza.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                print("Error decodificando respuesta update pieza: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func delete(id: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/inventario/delete/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }
}