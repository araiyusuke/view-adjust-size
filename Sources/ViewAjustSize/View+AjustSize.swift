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
    public func toRed() -> some View {
        self.background(Color.red)
    }
    
    public func toBlue() -> some View {
        self.background(Color.blue)
    }
}
