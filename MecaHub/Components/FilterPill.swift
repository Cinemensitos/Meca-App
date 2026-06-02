import SwiftUI

struct FilterPill: View {
    let titulo: String
    let isActive: Bool
    let accion: () -> Void
    
    var body: some View {
        Button(action: accion) {
            Text(titulo)
                .font(.system(size: 14, weight: isActive ? .semibold : .regular))
                .foregroundColor(isActive ? .white : .primary)
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .background(isActive ? Color("PrimaryColor") : Color(.systemBackground))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isActive ? Color.clear : Color(.systemGray4), lineWidth: 1.5)
                )
        }
    }
}