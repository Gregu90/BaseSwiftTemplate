//
//  UIExtensions.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension UIColor
{
    typealias RGBA = (red: Int, green: Int, blue: Int, alpha: CGFloat)
    typealias RGB = (red: Int, green: Int, blue: Int)
    
    convenience init(rgba: RGBA)
    {
        self.init(red: CGFloat(rgba.red)/255.0, green: CGFloat(rgba.green)/255.0, blue:  CGFloat(rgba.blue)/255.0, alpha: rgba.alpha)
    }
    
    convenience init(rgb: RGB)
    {
        self.init(rgba: RGBA(rgb.red, rgb.green, rgb.blue, 1.0))
    }
}

extension UIView
{
    class func setTextColor(_ color: UIColor, forViews views: [UIView])
    {
        for view in views {
            if let label = view as? UILabel {
                label.textColor = color
            }else if let button = view as? UIButton {
                button.setTitleColor(color)
            }else if let textField = view as? UITextField {
                textField.textColor = color
            }else if let textView = view as? UITextView {
                textView.textColor = color
            }
        }
    }
}

extension UIView
{
    
    func convertedFrameFromView(_ view: UIView) -> CGRect
    {
        var convertedRect = CGRect.zero
        if let superview = view.superview {
            convertedRect = self.convert(view.frame, from: superview)
        }
        return convertedRect
    }
}

extension UIButton
{
    func setTitleColor(_ color: UIColor)
    {
        self.setTitleColor(color, for: UIControlState())
    }
    
    func setTitle(_ title: String?)
    {
        self.setTitle(title, for: UIControlState())
    }
}

extension UIImage
{
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1))
    {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image!.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIStoryboardSegue
{
    
    var extractedViewController: UIViewController
    {
        get{
            if let baseDestinationVC = self.destination as? UINavigationController {
                return baseDestinationVC.viewControllers.last!
            }else{
                return self.destination
            }
        }
    }
}

extension UIView
{
    class func backgroundView(withColor color: UIColor?) -> UIView
    {
        let v = UIView()
        v.backgroundColor = color
        return v
    }
}

extension UITableViewCell
{
    var selectedColor: UIColor? {
        set {
            self.selectedBackgroundView = UIView.backgroundView(withColor: newValue)
        }
        get {
            return self.selectedBackgroundView?.backgroundColor
        }
    }
}

extension UITableViewHeaderFooterView
{
    var customBackgroundColor: UIColor? {
        set {
            self.backgroundView = UIView.backgroundView(withColor: newValue)
        }
        get {
            return self.backgroundView?.backgroundColor
        }
    }
}

//FIXME: - Reshuffle
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}


