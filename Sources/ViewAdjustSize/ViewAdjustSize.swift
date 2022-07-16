import SwiftUI


extension CGSize {
    var diagonal: CGFloat {
        return CGFloat(sqrt(Double(self.width * self.width + self.height * self.height)))
    }
}

@available(iOS 13.0, *)
public struct ViewAdjustSize {
    public static func convert(_ size: CGFloat, _ original: CGSize) -> CGFloat {
        let originalDiagonal: CGFloat = original.diagonal
        let deviceDiagonal: CGFloat =  UIScreen.main.bounds.size.diagonal
        return deviceDiagonal / originalDiagonal * size
    }
}

@available(iOS 13.0, *)
extension ViewAdjustSize {
    
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
extension ViewAdjustSize {
    public struct ViewAdjustSizeEnvironmentKey: EnvironmentKey {
        public typealias Value = ViewAdjustSize.Options?
        public static var defaultValue: ViewAdjustSize.Options?
    }
    private static func adjust(_ size: CGFloat?, _ original: CGFloat) -> CGFloat? {
        guard let size = size else{
            return nil
        }
        let originalDiagonal: CGFloat = original
        let deviceWidth: CGFloat = UIScreen.main.bounds.width
        let deviceHeight: CGFloat = UIScreen.main.bounds.height
        let deviceDiagonal: CGFloat = CGFloat(sqrt(Double(deviceWidth * deviceWidth + deviceHeight * deviceHeight) ))
        return deviceDiagonal / originalDiagonal * size
    }
    struct PaddingModifier: ViewModifier {
        @Environment(\.adjustOriginalSize) private var original
        let edge: Edge.Set
        let length: CGFloat?
        
        func body(content: Content) -> some View {
            return content
                .padding(
                    edge,
                    adjust(length, original.size)
                )
                .background(original.debug == true ? Color.red : Color.clear)
        }
    }
    struct OffsetModifier: ViewModifier {
        @Environment(\.adjustOriginalSize) private var original
        let x: CGFloat
        let y: CGFloat
        
        func body(content: Content) -> some View {
            return content
                .offset(
                    x: adjust(x, original.size) ?? 0, y: adjust(y, original.size) ?? 0
                )
        }
    }
    struct adjustFontModifier: ViewModifier {
        @Environment(\.adjustOriginalSize) private var original
        let size: CGFloat
        let weight: Font.Weight
        let design: Font.Design
        func body(content: Content) -> some View {
             content
                .font(.system(size: adjust(size, original.size) ?? 10, weight: weight, design: design))
        }
    }
    struct FrameModifier: ViewModifier {
        @Environment(\.adjustOriginalSize) private var original
        let width: CGFloat?
        let height: CGFloat?
        let alignment: Alignment = .center
        func body(content: Content) -> some View {
            if original.debug {
                content
                    .frame(width: width, height:height)
                    .background(Color.red.opacity(0.4))
                    .frame(
                        width: adjust(width, original.size),
                        height: adjust(height, original.size)
                    )
                    .background(original.debug == true ? Color.blue.opacity(0.7) : Color.clear)
            } else {
                content
                    .frame(
                        width: adjust(width, original.size),
                        height: adjust(height, original.size)
                    )
            }
        }
    }
}
@available(iOS 13.0, *)
extension EnvironmentValues {
    public var adjustOriginalSize: ViewAdjustSize.Options {
        get {
            self[ViewAdjustSize.ViewAdjustSizeEnvironmentKey.self] ?? ViewAdjustSize.Options(size: UIScreen.main.bounds.size)
        }
        set {
            self[ViewAdjustSize.ViewAdjustSizeEnvironmentKey.self] =  newValue
        }
    }
}
