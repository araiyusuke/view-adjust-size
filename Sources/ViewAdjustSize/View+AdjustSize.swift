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
    /// ViewからViewAdjustSizeに設定値を渡す
    public func adjustSize(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        return self.modifier(ViewAdjustSize.FrameModifier(width: width, height: height))
    }
    /// ViewからPaddingModifierに設定値を渡す
    public func adjustPadding(_ edge: Edge.Set = .all, _ length: CGFloat) -> some View {
        return self.modifier(ViewAdjustSize.PaddingModifier(edge: edge, length: length))
    }
    /// ViewからOffsetModifierに設定値を渡す
    public func adjustOffset(x: CGFloat = 0, y: CGFloat = 0) -> some View {
        return self.modifier(ViewAdjustSize.OffsetModifier(x: x, y: y))
    }

}

@available(iOS 13.0, *)
extension Text {
    public func adjustFont(size: CGFloat, weight: Font.Weight, design: Font.Design) -> some View {
        self.modifier(ViewAdjustSize.adjustFontModifier(size: size, weight: weight, design: design))
    }
}
