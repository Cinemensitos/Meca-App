import SwiftUI

struct AvatarView: View {
    let iniciales: String
    let size: CGFloat
    
    var fontSize: CGFloat {
        size == 80 ? 26 : 15
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("PrimaryColor"))
                .frame(width: size, height: size)
            Text(iniciales)
                .font(.system(size: fontSize, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}