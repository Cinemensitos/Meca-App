import Foundation

extension String {
    var isValidEmail: Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return predicate.evaluate(with: self)
    }

    var isValidPhone: Bool {
        let phonePattern = "^[0-9\\s\\-\\+\\(\\)]{10,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phonePattern)
        return predicate.evaluate(with: self)
    }
}
