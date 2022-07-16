import SwiftUI

@available(iOS 13.0, *)
public struct ViewAjustSize {}

@available(iOS 13.0, *)
extension ViewAjustSize {
    
    public struct Options {
        
        private (set) public var size: CGFloat
        private (set) public var debug: Bool
        
        public init(width: CGFloat?, height: CGFloat?, debug: Bool = false) {
            guard let width = width,
                  let height = height else {
                fatalError("環境変数が設定されてません")
            }
            self.size = Self.diagonal(width, height)
            self.debug = debug
        }
        
        /// 対角線の長さを返す
        static func diagonal(_ width: CGFloat, _ height: CGFloat) -> CGFloat {
            return CGFloat(sqrt(Double(width * width + height * height) ))
        }
    }
}
    
@available(iOS 13.0, *)
extension ViewAjustSize {

    public struct ViewAjustSizeEnvironmentKey: EnvironmentKey {
        public typealias Value = ViewAjustSize.Options?
        
        public static var defaultValue: ViewAjustSize.Options?
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
                    ajust(length, base.size)
                )
                .background(base.debug == true ? Color.red : Color.clear)
        }
    }
    
    struct OffsetModifier: ViewModifier {
        @Environment(\.ajustBaseSize) private var base
        let x: CGFloat
        let y: CGFloat
        
        func body(content: Content) -> some View {
            return content
                .offset(
                    x: ajust(x, base.size) ?? 0, y: ajust(y, base.size) ?? 0
                )
        }
    }
    
    struct FrameModifier: ViewModifier {
        @Environment(\.ajustBaseSize) private var base
        let width: CGFloat?
        let height: CGFloat?
        let alignment: Alignment = .center
        func body(content: Content) -> some View {
            if base.debug {
                content
                    .frame(width: width, height:height)
                    .background(Color.red.opacity(0.4))
                    .frame(
                        width: ajust(width, base.size),
                        height: ajust(height, base.size)
                    )
                    .background(base.debug == true ? Color.blue.opacity(0.7) : Color.clear)
            } else {
                content
                    .frame(
                        width: ajust(width, base.size),
                        height: ajust(height, base.size)
                    )
            }
        }
    }
}

@available(iOS 13.0, *)
extension EnvironmentValues {
    private static func diagonal(_ size: (width: CGFloat, height: CGFloat)?) -> CGFloat {
        if let size = size {
            return CGFloat(sqrt(Double(size.width * size.width + size.height * size.height) ))
        } else {
            fatalError("Environment variables are not set")
        }
    }
    public var ajustBaseSize: ViewAjustSize.Options {
        get {
            self[ViewAjustSize.ViewAjustSizeEnvironmentKey.self] ?? ViewAjustSize.Options(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        set {
            self[ViewAjustSize.ViewAjustSizeEnvironmentKey.self] =  newValue
        }
    }
}
