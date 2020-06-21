//
//  UIFont+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/20/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

extension UIFont {
    public static var cambay: UIFont {
        guard let font = UIFont(name: "Cambay-Regular", size: 34.0) else { fatalError("Couldn't load font.") }
        return font
    }
    
    public static var cambayBold: UIFont {
        guard let font = UIFont(name: "Cambay-Bold", size: 34.0) else { fatalError("Couldn't load font.") }
        return font
    }
    
    public static var cambayItalic: UIFont {
        guard let font = UIFont(name: "Cambay-Italic", size: 34.0) else { fatalError("Couldn't load font.") }
        return font
    }
    
    public static var cambayBoldItalic: UIFont {
        guard let font = UIFont(name: "Cambay-BoldItalic", size: 34.0) else { fatalError("Couldn't load font.") }
        return font
    }
}

extension UIFont {
    /// The `bold` version of any font. This allows us to `bold` preferred(dynamic) font sizes.
    public var bold: UIFont { return applying(weight: .bold) }

    /// The `semibold` version of any font. This allows us to `bold` preferred(dynamic) font sizes.
    public var semibold: UIFont { return applying(weight: .semibold) }

    public var italic: UIFont { return applying(trait: .traitItalic) }
}


// MARK: - UI/UX StyleGuide

extension UIFont {
    /// Default **LargeTitle** font with size 34.0, **regular** weight as per Apple HIGs.
    @available(iOS 11.0, *)
    public static var largeTitle: UIFont {
        return UIFont.preferredFont(forTextStyle: .largeTitle)
    }

    /// Recommended **Title1** font with size 28.0, **regular** weight as per Apple HIGs.
    public static var title1: UIFont {
        return UIFont.preferredFont(forTextStyle: .title1)
    }

    /// Recommended **LargeTitle** font with size 22.0, **regular** weight as per Apple HIGs.
    public static var title2: UIFont {
        return UIFont.preferredFont(forTextStyle: .title2)
    }

    /// Recommended **Title3** font with size 20.0, **regular** weight as per Apple HIGs.
    public static var title3: UIFont {
        return UIFont.preferredFont(forTextStyle: .title3)
    }

    /// Recommended **Headline** font with size 17.0, **semibold** weight as per Apple HIGs.
    public static var headline: UIFont {
        return UIFont.preferredFont(forTextStyle: .headline)
    }

    /// Recommended **Body** font with size 17.0, **regular** weight as per Apple HIGs.
    public static var body: UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }

    /// Recommended **CallOut** font with size 16.0, **regular** weight as per Apple HIGs.
    public static var callout: UIFont {
        return UIFont.preferredFont(forTextStyle: .callout)
    }

    /// Recommended **SubHeader** font with size 15.0, **regular** weight as per Apple HIGs.
    public static var subheadline: UIFont {
        return UIFont.preferredFont(forTextStyle: .subheadline)
    }

    /// Recommended **FootNote** font with size 13.0, **regular** weight as per Apple HIGs.
    public static var footnote: UIFont {
        return UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    /// Recommended **Caption2** font with size 11.0, **regular** weight as per Apple HIGs.
    public static var caption: UIFont {
        return UIFont.preferredFont(forTextStyle: .caption2)
    }

    /// Method for setting weight for a given font size.
    ///
    /// By default Apple sets the font weight to be Regular and the other
    /// available font weights are: Black, Bold, Light, Heavy, Medium, Regular,
    /// Semibold, Thin, Ultralight.
    ///
    /// - Parameters:
    ///   - weight: The thickness of a given font.
    private func applying(weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: pointSize, weight: weight)
    }

    /// Method for setting the traits of a given font.
    ///
    /// - Parameters:
    ///   - trait: The SymbolicTrait of the font.
    private func applying(trait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let font = fontDescriptor.withSymbolicTraits(trait)
        guard let descriptor = font else { return UIFont(descriptor: fontDescriptor, size: 0) }
        return UIFont(descriptor: descriptor, size: 0)
    }
}

