//
//  UIConstants.swift
//  CloudVault
//
//  Created by Appinators Technology on 09/07/2024.
//

import Foundation
import UIKit

/// Use DesignMetrics struct for everything related to Layout
/// Please avoid hardcoding sizes and spacings for stacks inside the code.
/// If there is something not in DesignMetrics please add in required struct
struct DesignMetrics {
    
    // Must start with size and include the number at the end of the name, will be easy to use that way
    struct Padding {
        static let size0: CGFloat = 0.0
        static let size4: CGFloat = 4.0
        static let size8: CGFloat = 8.0
        static let size10: CGFloat = 10.0
        static let size12: CGFloat = 12.0
        static let size14: CGFloat = 14.0
        static let size16: CGFloat = 16.0
        static let size20: CGFloat = 20.0
        static let size24: CGFloat = 24.0
        static let size28: CGFloat = 28.0
        static let size32: CGFloat = 32.0
        static let size37: CGFloat = 37.0
        static let size40: CGFloat = 40.0
        static let size44: CGFloat = 44.0
        static let size50: CGFloat = 50.0
    }
    
    // Must start with height/width and include the number at the end of the name, will be easy to use that way
    struct Dimensions {
        static let height12:  CGFloat = 12.0
        static let height14:  CGFloat = 14.0
        static let height16:  CGFloat = 16.0
        static let height22:  CGFloat = 22.0
        static let height20:  CGFloat = 20.0
        static let height24:  CGFloat = 24.0
        static let height28:  CGFloat = 28.0
        static let height30:  CGFloat = 30.0
        static let height32:  CGFloat = 32.0
        static let height33:  CGFloat = 33.0
        static let height34:  CGFloat = 34.0
        static let height40:  CGFloat = 40.0
        static let height42:  CGFloat = 42.0
        static let height44:  CGFloat = 44.0
        static let height48:  CGFloat = 48.0
        static let height50:  CGFloat = 50.0
        static let height51:  CGFloat = 51.0
        static let height53:  CGFloat = 53.0
        static let height54:  CGFloat = 54.0
        static let height56:  CGFloat = 56.0
        static let height60:  CGFloat = 60.0
        static let height65:  CGFloat = 65.0
        static let height70:  CGFloat = 70.0
        static let height74:  CGFloat = 74.0
        static let height76:  CGFloat = 76.0
        static let height78:  CGFloat = 78.0
        static let height80:  CGFloat = 80.0
        static let height90:  CGFloat = 90.0
        static let height100: CGFloat = 100.0
        static let height110: CGFloat = 110.0
        static let height135: CGFloat = 135.0
        static let height148: CGFloat = 148.0
        static let height156: CGFloat = 156.0
        static let height160:  CGFloat = 160.0
        static let height197:  CGFloat = 197.0
        static let height210: CGFloat = 210.0
        static let height214: CGFloat = 214.0
        static let height224: CGFloat = 224.0
        static let height244: CGFloat = 244.0
        static let height260: CGFloat = 260.0
        static let height350: CGFloat = 350.0
        static let height357: CGFloat = 357.0
        static let height372: CGFloat = 372.0
        static let height500: CGFloat = 500.0
        
        
        
        static let width3:  CGFloat = 3.0
        static let width14:  CGFloat = 14.0
        static let width15:  CGFloat = 15.0
        static let width16:  CGFloat = 16.0
        static let width18:  CGFloat = 18.0
        static let width20:  CGFloat = 20.0
        static let width22:  CGFloat = 22.0
        static let width24:  CGFloat = 24.0
        static let width28:  CGFloat = 28.0
        static let width25:  CGFloat = 25.0
        static let width30:  CGFloat = 30.0
        static let width32:  CGFloat = 32.0
        static let width33:  CGFloat = 33.0
        static let width36:  CGFloat = 36.0
        static let width40:  CGFloat = 40.0
        static let width44:  CGFloat = 44.0
        static let width50:  CGFloat = 50.0
        static let width54:  CGFloat = 54.0
        static let width60:  CGFloat = 60.0
        static let width74:  CGFloat = 74.0
        static let width76:  CGFloat = 76.0
        static let width80:  CGFloat = 80.0
        static let width88:  CGFloat = 88.0
        static let width120: CGFloat = 120.0
        static let width127_75: CGFloat = 127.75
        static let width148: CGFloat = 148.0
        static let width164: CGFloat = 164.0
        static let width166: CGFloat = 166.0
        static let width190: CGFloat = 190.0
        static let width244: CGFloat = 244.0
        static let width247: CGFloat = 247.0
        static let width256: CGFloat = 256.0
        static let width272: CGFloat = 272.0
        static let width350: CGFloat = 350.0
        static let width500: CGFloat = 500.0
    }
}

// If adding new color it should start with neuphoria
extension UIColor {
    static let neuphoriaWhite = UIColor.white
    static let neuphoriaMainViewBG = UIColor.label
    static let neuphoriaDarkPurple = UIColor(named: "ThemDarkPurple") ?? .purple
    static let neuphoriaBlue = UIColor(named: "ThemeBlue") ?? .blue
    static let neuphoriaGreen = UIColor(named: "ThemeGreen") ?? .green
    static let neuphoriaLightGray = UIColor(named: "ThemeLightGray") ?? .lightGray
    static let neuphoriaLightPurple = UIColor(named: "ThemeLightPurple") ?? .purple
    static let neuphoriaOrange = UIColor(named: "ThemeOrange") ?? .orange
    static let neuphoriaPurple = UIColor(named: "ThemePurple") ?? .purple
    static let neuphoriaPurpleLight = UIColor(named: "ThemePurpleLight") ?? .purple
    static let neuphoriaWhiteWith10 = UIColor(named: "ThemeWhiteWith10") ?? .white.withAlphaComponent(0.1)
    static let neuphoriaWarningPink = UIColor(named: "Warning-Pink") ?? .systemPink
}

// If adding new image it should start with neuphoria
extension UIImage {
    static let neuphoriaBackgroundImage = UIImage(named: "radial-gradient-bg")
    static let cloudVaultBackButton = UIImage(named: "ic_back_button")
    static let neuphoriaCalendar = UIImage(named: "calendar")
    static let neuphoriaAlarmClock = UIImage(named: "alarm-clock")
}

// If adding new font it should start with neuphoria
extension UIFont {
    static let neuphoriaTitle = UIFont(name: "Lexend-Medium", size: 20)
    static let neuphoriaTitleMedium = UIFont(name: "Lexend-Medium", size: 15)
    static let neuphoriaTitleSmall = UIFont(name: "Lexend-Medium", size: 14)
    static let neuphoriaHeading1 = UIFont(name: "Lexend-Regular", size: 16)
    static let neuphoriaSubHeading = UIFont(name: "Lexend-Regular", size: 15)
    static let neuphoriaBody = UIFont(name: "Lexend-Regular", size: 14)
    static let neuphoriaCaption = UIFont(name: "Lexend-Regular", size: 10)
    
    static func cloudVaultRegularText(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SegoeUIThis", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func cloudVaultItalicText(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SegoeUIThis-Italic", size: size) ?? UIFont.italicSystemFont(ofSize: size)
    }
    
    static func cloudVaultBoldText(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SegoeUIThis-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func cloudVaultBoldItalicText(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SegoeUIThis-BoldItalic", size: size) ?? UIFont.italicSystemFont(ofSize: size)
    }
    
    static func cloudVaultSemiBoldText(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "STIXTwoText_SemiBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func cloudVaultItalicSemiBoldText(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "STIXTwoText-Italic_SemiBold-Italic", size: size) ?? UIFont.italicSystemFont(ofSize: size)
    }
    
    static func cloudVaultItalicSemiLightText(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SegoeUI-Semilight", size: size) ?? UIFont.italicSystemFont(ofSize: size)
    }
    
}

extension String {
    func underlined() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: self.count))
        return attributedString
    }
    
    func removing(at index: Int) -> String {
        var modifiedString = self
        let range = modifiedString.index(modifiedString.startIndex, offsetBy: index)..<modifiedString.index(modifiedString.startIndex, offsetBy: index + 1)
        modifiedString.removeSubrange(range)
        return modifiedString
    }
    
    mutating func replaceCharacter(at index: Int, with newCharacter: Character) {
        var stringArray = Array(self)
        stringArray[index] = newCharacter
        self = String(stringArray)
    }
    
    func styledStringWithThreeParts(firstPart: String, secondPart: String, thirdPart: String) -> NSAttributedString {
        let fullString = firstPart + secondPart + thirdPart
        let attributedString = NSMutableAttributedString(string: fullString)
        
        let firstPartRange = NSRange(location: 0, length: firstPart.count)
        let secondPartRange = NSRange(location: firstPart.count, length: secondPart.count)
        let thirdPartRange = NSRange(location: firstPart.count + secondPart.count, length: thirdPart.count)
        
        // First part: Bold with black color
        attributedString.addAttributes([
            .font: UIFont.cloudVaultBoldText(ofSize: 16),
            .foregroundColor: #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        ], range: firstPartRange)
        
        // Second part: Regular with grey color
        attributedString.addAttributes([
            .font: UIFont.cloudVaultRegularText(ofSize: 16),
            .foregroundColor: #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 0.5412946429)
        ], range: secondPartRange)
        
        // Third part: Bold with black color
        attributedString.addAttributes([
            .font: UIFont.cloudVaultBoldText(ofSize: 16),
            .foregroundColor: #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        ], range: thirdPartRange)
        
        return attributedString
    }

    
}

extension UIButton {
    func setFont(_ font: UIFont, for state: UIControl.State) {
        self.titleLabel?.font = font
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    // Usage
    //customView.roundCorners(corners: [.topLeft, .bottomRight], radius: 20)
}

struct FontManager {
    static func segoeUIFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Segoe UI", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    struct Sizes {
        static let title: CGFloat = 24
        static let body: CGFloat = 17
        static let caption: CGFloat = 14
    }
    
    struct Fonts {
        static let title = FontManager.segoeUIFont(size: Sizes.title)
        static let body = FontManager.segoeUIFont(size: Sizes.body)
        static let caption = FontManager.segoeUIFont(size: Sizes.caption)
    }
}
