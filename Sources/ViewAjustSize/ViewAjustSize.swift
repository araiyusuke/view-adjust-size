import SwiftUI


extension CGSize {
    var diagonal: CGFloat {
        return CGFloat(sqrt(Double(self.width * self.width + self.height * self.height)))
    }
}

@available(iOS 13.0, *)
public struct ViewAjustSize {
    public static func convert(_ size: CGFloat, _ original: CGSize) -> CGFloat {
        let baseDiagonal: CGFloat = original.diagonal
        let deviceDiagonal: CGFloat =  UIScreen.main.bounds.size.diagonal
        return deviceDiagonal / baseDiagonal * size
    }
}

@available(iOS 13.0, *)
extension ViewAjustSize {
    
    public struct Options {
        
        private (set) public var size: CGFloat
        private (set) public var debug: Bool
        
        public init(size: CGSize, debug: Bool = false) {
            if size == .zero {
                fatalError("環境変数が設定されてません")
            }
            self.size = size.diagonal
            self.debug = debug
        }
    }
}
    
@available(iOS 13.0, *)
extension ViewAjustSize {

    public struct ViewAjustSizeEnvironmentKey: EnvironmentKey {
        public typealias Value = ViewAjustSize.Options?
        
        public static var defaultValue: ViewAjustSize.Options?
    }
        
    private static func ajust(_ size: CGFloat?, _ original: CGFloat) -> CGFloat? {
        guard let size = size else{
            return nil
        }
        let baseDiagonal: CGFloat = original
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
    
  
    
    struct VStackModifier: ViewModifier {
        @Environment(\.ajustBaseSize) private var base
        func body(content: Content) -> some View {
            VStack {
                content
            }
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
    public var ajustBaseSize: ViewAjustSize.Options {
        get {
            self[ViewAjustSize.ViewAjustSizeEnvironmentKey.self] ?? ViewAjustSize.Options(size: UIScreen.main.bounds.size)
        }
        set {
            self[ViewAjustSize.ViewAjustSizeEnvironmentKey.self] =  newValue
        }
    }
}
