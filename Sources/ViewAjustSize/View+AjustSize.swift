//
//  File.swift
//  
//
//  Created by 名前なし on 2022/07/16.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension View {
    /// ViewからViewAjustSizeに設定値を渡す
    public func ajustSize(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        return self.modifier(ViewAjustSize.FrameModifier(width: width, height: height))
    }
    
    /// ViewからPaddingModifierに設定値を渡す
    public func ajustPadding(_ edge: Edge.Set = .all, _ length: CGFloat) -> some View {
        return self.modifier(ViewAjustSize.PaddingModifier(edge: edge, length: length))
    }
    
    /// ViewからOffsetModifierに設定値を渡す
    public func ajustOffset(x: CGFloat = 0, y: CGFloat = 0) -> some View {
        return self.modifier(ViewAjustSize.OffsetModifier(x: x, y: y))
    }
}
