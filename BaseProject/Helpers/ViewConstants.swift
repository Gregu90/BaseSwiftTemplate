//
//  ViewConstants.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import UIKit

private enum Colors
{
    case white, almostWhite
    case almostBlack, black
    case red, yellow, green
    case gray, mediumGray, lightGray
    case beige
    case gradientDark, gradientWhite
    
    var color: UIColor
    {
        switch self {
        case .white: return UIColor(rgb: (255, 255, 255))
        case .almostBlack: return UIColor(rgb: (77, 77, 77))
        case .red: return UIColor(rgb: (214,31,38))
        case .yellow: return UIColor(rgb: (255, 199, 19))
        case .green: return UIColor(rgb: (131, 190, 59))
        case .gray: return UIColor(rgb: (154, 154, 154))
        case .mediumGray: return UIColor(rgb: (204, 204, 204))
        case .lightGray: return UIColor(rgb: (235, 235, 235))
        case .almostWhite: return UIColor(rgb: (245, 245, 246))
        case .black: return UIColor(rgb: (0, 0, 0))
        case .beige: return UIColor(rgb: (249, 245, 237))
        case .gradientDark: return UIColor(rgb: (139, 148, 157))
        case .gradientWhite: return UIColor(rgb: (204, 204, 203))
        }
    }
}

enum AppColor
{
    case lightText, darkText, mediumText
    case primary, secondary, tertiary
    case defaultBackground
    case gradientDark, gradientWhite
    
    var color: UIColor
    {
        switch  self {
        case .defaultBackground: return Colors.white.color
        case .lightText: return Colors.white.color
        case .darkText: return Colors.black.color
        case .mediumText: return Colors.gray.color
        case .primary: return Colors.red.color
        case .secondary: return Colors.green.color
        case .tertiary: return Colors.yellow.color
        case .gradientDark: return Colors.gradientDark.color
        case .gradientWhite: return Colors.gradientWhite.color
        }
    }
}

enum AppImage
{
    case status(online: Bool)
    case library
    case wishlist
    case chat
    
    fileprivate var name: String
    {
        switch self {
        case .status(let online):
            if online {
                return "online"
            } else {
                return "offline"
            }
        case .library: return "library_off"
        case .wishlist: return "wishlist_off"
        case .chat: return "chat_on"
        }
    }
    
    fileprivate var namedImage: UIImage
    {
        return UIImage(named: self.name)!
    }
    
    var image: UIImage
    {
        return self.namedImage
    }
}

//enum AppFont
//{
//    case light, regular, medium, bold
//
//    fileprivate var name: String {
//        switch self {
//        case .light: return "Roboto-Light"
//        case .regular: return "Roboto-Regular"
//        case .medium: return "Roboto-Medium"
//        case .bold: return "Roboto-Bold"
//        }
//    }
//
//    func font(withSize size: CGFloat) -> UIFont
//    {
//        return UIFont(name: self.name, size: size)!
//    }
//}

struct GlobalAppearance
{
    static func customize()
    {
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().barTintColor = AppColor.navbar.color
//        UINavigationBar.appearance().tintColor = AppColor.lightText.color
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: AppColor.lightText.color, NSAttributedStringKey.font: AppFont.medium.font(withSize: 16.0)]
//
//
//        let barItemFont = AppFont.regular.font(withSize: 16.0)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: AppColor.lightText.color, NSAttributedStringKey.font: barItemFont], for: .normal)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: AppColor.lightText.color.withAlphaComponent(0.35), NSAttributedStringKey.font: barItemFont], for: .disabled)
//
//        let item: UIBarButtonItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIToolbar.self])
//        item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: AppColor.secondary.color], for: UIControlState())
    }
}

