//
//  View+Extension.swift
//  Social Media App
//
//  Created by Abdusamad Mamasoliyev on 16/01/24.
//

import SwiftUI

extension View {
    // Closing All Active Keyboards
    func closeKeyBoard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    // MARK: Disabling with Opacity
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func hAligh(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAligh(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    // MARK: Custom Border View Wiht Padding
    func border(_ width: CGFloat, _ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
        // MARK: Custom Fill View Wiht Padding
    func fillView( _ color: Color) -> some View {
            self
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(color)
                }
    }
}

