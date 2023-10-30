//
//  UITextView.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 25/06/2023.
//

import UIKit

extension UITextView {
    
    func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
      let style = NSMutableParagraphStyle()
      style.alignment = .left
      let attributedOriginalText = NSMutableAttributedString(string: originalText)
      for (hyperLink, urlString) in hyperLinks {
          let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
          let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
          attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
          attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
          attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Inter-Regular", size: 14), range: fullRange)
      }
      
      self.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.blue
      ]
      self.attributedText = attributedOriginalText
    }
}
