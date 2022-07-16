# ViewAdjustSize

## 端末のサイズ間を調整するライブラリ

<img width="687" alt="iPod_touch_と_SampleViewAjustSize_—_ContentView_swift" src="https://user-images.githubusercontent.com/1781289/179358237-5d26aed5-5eeb-4f0b-9290-d56a8fabd058.png">

##  使用方法

adjustOriginalSizeにはAdobeXDデータの画面サイズをセットする。

ViewAdjustSizeで用意されているメソッドから設定することで、オリジナルのサイズとユーザー端末のサイズの比率に合わせてリサイズされる。

```swift
import SwiftUI
import ViewAdjustSize

@main
struct SampleViewAdjustSizeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.adjustOriginalSize, .init(size: CGSize(width: 375, height: 812), debug: true))
        }
    }
}
```

### Sample1

* View.frame

```swift
 Text("1")
	.adjustSize(width: 100, height: 100)
```

### Sample2

```swift
Text("A")
        .adjustFont(size: 20, weight: .light, design: .monospaced)
```
