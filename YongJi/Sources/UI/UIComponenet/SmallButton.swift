import SwiftUI

struct SmallButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    init(
        title: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(isEnabled ? Color("RowNumColor") : Color("RowNumColor").opacity(0.5))
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
    }
}