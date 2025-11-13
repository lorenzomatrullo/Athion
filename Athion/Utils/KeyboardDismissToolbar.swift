import SwiftUI

struct KeyboardDismissToolbar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: { dismissKeyboard() }) {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .font(.title3)
                    }
                }
            }
    }
}

extension View {
    func keyboardDismissToolbar() -> some View {
        modifier(KeyboardDismissToolbar())
    }
}
