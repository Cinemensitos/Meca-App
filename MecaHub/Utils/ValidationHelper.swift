import Foundation

struct ValidationHelper {

    static func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return predicate.evaluate(with: email)
    }

    static func isValidPhone(_ phone: String) -> Bool {
        let phonePattern = "^[0-9\\s\\-\\+\\(\\)]{10,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phonePattern)
        return predicate.evaluate(with: phone)
    }

    static func validateEmail(_ email: String) -> String? {
        if email.isEmpty {
            return "El correo es obligatorio"
        }
        if !isValidEmail(email) {
            return "Ingresa un correo válido"
        }
        return nil
    }

    static func validatePhone(_ phone: String) -> String? {
        if phone.isEmpty {
            return "El teléfono es obligatorio"
        }
        if !isValidPhone(phone) {
            return "El teléfono solo debe contener números"
        }
        return nil
    }
}
