import SwiftUI

struct StockBadge: View {
    let estado: String
    
    var label: String {
        switch estado {
        case "disponible": return "● Disponible"
        case "bajo":       return "● Bajo"
        case "critico":    return "● Crítico"
        case "sin_stock":  return "● Sin stock"
        default:           return "● -"
        }
    }
    
    var color: Color {
        switch estado {
        case "disponible": return .green
        case "bajo":       return .orange
        case "critico":    return .red
        case "sin_stock":  return .gray
        default:           return .gray
        }
    }
    
    var body: some View {
        Text(label)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color)
            .cornerRadius(20)
    }
}