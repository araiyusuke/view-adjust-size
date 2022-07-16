import SwiftUI

@available(iOS 13.0, *)
public struct ViewAjustSize {
    
    public struct ViewAjustSizeEnvironmentKey: EnvironmentKey {
        public typealias Value = (CGFloat, CGFloat)?
        public static var defaultValue: (CGFloat, CGFloat)?
    }
    
    /// 対角線の長さ
    private static func diagonal(_ size: (width: CGFloat, height: CGFloat)?) -> CGFloat {
        if let size = size {
            return CGFloat(sqrt(Double(size.width * size.width + size.height * size.height) ))
        } else {
            fatalError("環境変数が設定されてません")
        }
    }
    
    private static func ajust(_ size: CGFloat?, _ base: CGFloat) -> CGFloat? {
        guard let size = size else{
            return nil
        }
        let baseDiagonal: CGFloat = base
        let deviceWidth: CGFloat = UIScreen.main.bounds.width
        let deviceHeight: CGFloat = UIScreen.main.bounds.height
        let deviceDiagonal: CGFloat = CGFloat(sqrt(Double(deviceWidth * deviceWidth + deviceHeight * deviceHeight) ))
        return deviceDiagonal / baseDiagonal * size
    }
    
    struct PaddingModifier: ViewModifier {
        @Environment(\.ajustBaseSize) private var base
        let edge: Edge.Set
        let length: CGFloat?
        
        func body(content: Content) -> some View {
            return content
                .padding(
                    edge,
                    ajust(length, diagonal(base))
                )
        }
    }
    
    struct OffsetModifier: ViewModifier {
        @Environment(\.ajustBaseSize) private var base
        let x: CGFloat
        let y: CGFloat

        func body(content: Content) -> some View {
            return content
                .offset(
                    x: ajust(x, diagonal(base)) ?? 0, y: ajust(y, diagonal(base)) ?? 0
                )
        }
    }
    
    @available(iOS 13.0, *)
    struct FrameModifier: ViewModifier {
        @Environment(\.ajustBaseSize) private var base
        let width: CGFloat?
        let height: CGFloat?
        let alignment: Alignment = .center
        func body(content: Content) -> some View {
            content
                .frame(
                    width: ajust(width, diagonal(base)),
                    height: ajust(height, diagonal(base))
                )
        }
    }
}

@available(iOS 13.0, *)
extension EnvironmentValues {
    
    private static func diagonal(_ size: (width: CGFloat, height: CGFloat)?) -> CGFloat {
        if let size = size {
            return CGFloat(sqrt(Double(size.width * size.width + size.height * size.height) ))
        } else {
            fatalError("環境変数が設定されてません")
        }
    }
    
    public var ajustBaseSize: (width: CGFloat, height: CGFloat)? {
        get {
             self[ViewAjustSize.ViewAjustSizeEnvironmentKey.self]
        }
        set {
            self[ViewAjustSize.ViewAjustSizeEnvironmentKey.self] =  newValue
        }
    }
}
