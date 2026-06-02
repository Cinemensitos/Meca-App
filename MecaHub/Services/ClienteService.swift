import Foundation

class ClienteService {
    
    static func getAll(completion: @escaping ([Cliente]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/clientes/getAll") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "desconocido")")
                DispatchQueue.main.async { completion([]) }
                return
            }
            do {
                let clientes = try JSONDecoder().decode([Cliente].self, from: data)
                DispatchQueue.main.async { completion(clientes) }
            } catch {
                print("Error decodificando clientes: \(error)")
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
    
    static func getById(id: Int, completion: @escaping (Cliente?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/clientes/getById/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let cliente = try JSONDecoder().decode(Cliente.self, from: data)
                DispatchQueue.main.async { completion(cliente) }
            } catch {
                print("Error decodificando cliente: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func save(cliente: Cliente, completion: @escaping (Cliente?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/clientes/save") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(cliente)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let result = try JSONDecoder().decode(Cliente.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                print("Error decodificando respuesta save: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func update(id: Int, cliente: Cliente, completion: @escaping (Cliente?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/clientes/update/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(cliente)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let result = try JSONDecoder().decode(Cliente.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                print("Error decodificando respuesta update: \(error)")
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