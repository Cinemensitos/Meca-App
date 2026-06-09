import Foundation

class MecanicoService {
    
    // FIX: decoder con convertFromSnakeCase para recibir empleado_num, fecha_ingreso,
    // created_at, password_hash correctamente desde la API.
    private static var decoder: JSONDecoder {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }
    
    // FIX: encoder con convertToSnakeCase para enviar password_hash al endpoint /login
    // y empleado_num, fecha_ingreso al endpoint /save y /update.
    private static var encoder: JSONEncoder {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }
    
    static func getAll(completion: @escaping ([Mecanico]) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/mecanicos/getAll") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "desconocido")")
                DispatchQueue.main.async { completion([]) }
                return
            }
            do {
                let mecanicos = try decoder.decode([Mecanico].self, from: data)
                DispatchQueue.main.async { completion(mecanicos) }
            } catch {
                print("Error decodificando mecanicos: \(error)")
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
    
    static func getById(id: Int, completion: @escaping (Mecanico?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/mecanicos/getById/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let mecanico = try decoder.decode(Mecanico.self, from: data)
                DispatchQueue.main.async { completion(mecanico) }
            } catch {
                print("Error decodificando mecanico: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    // FIX: el encoder con convertToSnakeCase convierte passwordHash → password_hash,
    // que es exactamente el campo que MecanicoResource.java espera via Gson.
    static func login(correo: String, password: String, completion: @escaping (Mecanico?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/mecanicos/login") else { return }
        
        let body = Mecanico(id: 0, nombre: "", correo: correo, passwordHash: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let mecanico = try decoder.decode(Mecanico.self, from: data)
                DispatchQueue.main.async { completion(mecanico) }
            } catch {
                print("Error decodificando respuesta login: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func save(mecanico: Mecanico, completion: @escaping (Mecanico?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/mecanicos/save") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(mecanico)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let result = try decoder.decode(Mecanico.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                print("Error decodificando respuesta save mecanico: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func update(id: Int, mecanico: Mecanico, completion: @escaping (Mecanico?) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/mecanicos/update/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(mecanico)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let result = try decoder.decode(Mecanico.self, from: data)
                DispatchQueue.main.async { completion(result) }
            } catch {
                print("Error decodificando respuesta update mecanico: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    static func delete(id: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/mecanicos/delete/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }
}