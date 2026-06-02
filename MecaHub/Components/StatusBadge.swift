import SwiftUI

struct StatusBadge: View {
    let estado: String
    
    var label: String {
        switch estado {
        case "recibido":    return "● RECIBIDO"
        case "diagnostico": return "● DIAGNÓSTICO"
        case "reparacion":  return "● EN REPARACIÓN"
        case "listo":       return "● LISTO"
        case "entregado":   return "● ENTREGADO"
        default:            return "● \(estado.uppercased())"
        }
    }
    
    var color: Color {
        switch estado {
        case "recibido":    return .blue
        case "diagnostico": return .orange
        case "reparacion":  return Color("PrimaryColor")
        case "listo":       return .green
        case "entregado":   return .gray
        default:            return .gray
        }
    }
    
    var body: some View {
        Text(label)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color)
            .cornerRadius(20)
    }
}