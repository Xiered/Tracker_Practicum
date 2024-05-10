//
//  EmojiAndColor.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 10.05.2024.
//

import UIKit

protocol EmojiAndColorDelegate: AnyObject {
    func emojiAndColorDidSelectEmoji(_ emoji: String)
    func emojiAndColorDidSelectColor(_ color: UIColor)
}

final class EmojiAndColor {
    
    private var emojiCollection = ["🙂","😻","🌺","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝","😪"]
    
    private var colorCollection: [UIColor] = {
        var colorCollection = [UIColor]()
        for i in 1...18 {
            let color = UIColor(named: "Color selection \(i)") ?? .black
            colorCollection.append(color)
        }
        return colorCollection
    }()
}
