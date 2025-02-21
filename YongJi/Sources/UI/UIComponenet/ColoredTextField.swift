import SwiftUI

struct ColoredTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var maxLength: Int = -1
    
    var body: some View {
        if maxLength > -1 {
            TextField(placeholder, text: $text)
                .maxLength(text: $text, maxLength)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color("RowColor"))
                .cornerRadius(12)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
        } else {
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color("RowColor"))
                .cornerRadius(12)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
        }

    }
}
