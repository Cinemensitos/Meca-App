import Foundation

class VehiculoService {
    
    static func getAll(completion: @escaping ([Vehiculo]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/vehiculos/getAll") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "desconocido")")
                DispatchQueue.main.async { completion([]) }
                return
            }
            do {
                let vehiculos = try JSONDecoder().decode([Vehiculo].self, from: data)
                DispatchQueue.main.async { completion(vehiculos) }
            } catch {
                print("Error decodificando vehiculos: \(error)")
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
    
    static func getById(id: Int, completion: @escaping (Vehiculo?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/vehiculos/getById/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let vehiculo = try JSONDecoder().decode(Vehiculo.self, from: data)
                DispatchQueue.main.async { completion(vehiculo) }
            } catch {
                print("Error decodificando vehiculo: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func getByCliente(clienteId: Int, completion: @escaping ([Vehiculo]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/vehiculos/getByCliente/\(clienteId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            do {
                let vehiculos = try JSONDecoder().decode([Vehiculo].self, from: data)
                DispatchQueue.main.async { completion(vehiculos) }
            } catch {
                print("Error decodificando vehiculos por cliente: \(error)")
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
    
    static func save(vehiculo: Vehiculo, completion: @escaping (Vehiculo?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/vehiculos/save") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(vehiculo)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let result = try JSONDecoder().decode(Vehiculo.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                print("Error decodificando respuesta save vehiculo: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func update(id: Int, vehiculo: Vehiculo, completion: @escaping (Vehiculo?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/vehiculos/update/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(vehiculo)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let result = try JSONDecoder().decode(Vehiculo.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                print("Error decodificando respuesta update vehiculo: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func delete(id: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/vehiculos/delete/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }
}