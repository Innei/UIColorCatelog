//
//  Colors.swift
//  ColorCatelog
//
//  Created by Innei on 2025/1/12.
//

import Foundation
import UIKit

extension UIColor {
    static var allSystemColors: [(name: String, color: UIColor)] {
        var count: UInt32 = 0
        guard let methodList = class_copyMethodList(object_getClass(UIColor.self), &count) else { return [] }
        defer { free(methodList) }
        
        var colors: [(String, UIColor)] = []
        
        for i in 0..<Int(count) {
            let method = methodList[i]
            let selector = method_getName(method)
            let methodName = NSStringFromSelector(selector)
            guard !methodName.hasPrefix("_") else {
                continue
            }
            
            // 获取方法的参数数量
            let numberOfArguments = method_getNumberOfArguments(method)
            let typeEncodingLength = strlen(method_getTypeEncoding(method)!)
            let typeEncoding = String.init(unsafeUninitializedCapacity: typeEncodingLength) { buffer in
                strcpy(buffer.baseAddress, method_getTypeEncoding(method))
                return typeEncodingLength
            }
            guard typeEncoding == "@16@0:8" else {
                continue
            }
            // 类方法默认有两个隐藏参数 (self 和 _cmd)，所以无参数方法总共应该是 2 个参数
            guard numberOfArguments == 2,
                  let color = UIColor.perform(selector)?.takeUnretainedValue() as? UIColor
            else { continue }
            
            colors.append((methodName, color))
        }
        
        return colors.sorted { $0.0 < $1.0 }
    }
    
    func getRGBValues(for traitCollection: UITraitCollection) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let resolvedColor = self.resolvedColor(with: traitCollection)
        resolvedColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}
