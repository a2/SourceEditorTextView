//
//  SourceEditorTextView.swift
//  SourceEditorTextView
//
//  Created by Alexsander Akers on 8/28/17.
//  Copyright © 2017 Pandamonia LLC. All rights reserved.
//

import UIKit

class SourceEditorTextView: UITextView {
    class TextContainer: NSTextContainer {
        override var lineFragmentPadding: CGFloat {
            get {
                guard let layoutManager = layoutManager as? LayoutManager else { return 0 }
                return layoutManager.lineNumberSize.width
            }
            set {}
        }
    }

    class TextStorage: NSTextStorage {
        let attributedString = NSMutableAttributedString()
        var paragraphIndexes = IndexSet()

        func paragraphIndex(at location: Int) -> Int {
            var count = 0

            // TODO: Is there a more efficient way to do this?
            for index in paragraphIndexes {
                if index < location {
                    count += 1
                } else {
                    break
                }
            }

            return count
        }

        override var string: String {
            return attributedString.string
        }

        override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey: Any] {
            return attributedString.attributes(at: location, effectiveRange: range)
        }

        override func replaceCharacters(in range: NSRange, with str: String) {
            beginEditing()

            attributedString.replaceCharacters(in: range, with: str)

            let nsstr = str as NSString
            let changeInLength = nsstr.length - range.length
            if str.isEmpty {
                paragraphIndexes.shift(startingAt: range.upperBound, by: changeInLength)
            } else {
                paragraphIndexes.shift(startingAt: range.lowerBound, by: changeInLength)

                var newlineRange = NSRange(0 ..< 0)
                while true {
                    newlineRange = nsstr.rangeOfCharacter(from: .newlines, range: NSRange(newlineRange.upperBound ..< nsstr.length))
                    if newlineRange.location != NSNotFound {
                        paragraphIndexes.insert(range.location + newlineRange.location)
                    } else {
                        break
                    }
                }
            }

            edited(.editedCharacters, range: range, changeInLength: changeInLength)
            endEditing()
        }

        override func setAttributes(_ attrs: [NSAttributedStringKey: Any]?, range: NSRange) {
            beginEditing()

            attributedString.setAttributes(attrs, range: range)

            edited(.editedAttributes, range: range, changeInLength: 0)
            endEditing()
        }
    }

    class LayoutManager: NSLayoutManager {
        var lineNumberFont: UIFont = UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: .regular)
        fileprivate var lineNumberSize: CGSize = .zero

        override func processEditing(for textStorage: NSTextStorage, edited editMask: NSTextStorageEditActions, range newCharRange: NSRange, changeInLength delta: Int, invalidatedRange invalidatedCharRange: NSRange) {
            defer {
                super.processEditing(for: textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)
            }

            guard let textStorage = textStorage as? TextStorage else { return }

            let maxParagraphIndex = textStorage.paragraphIndexes.count + 1
            let maximumParagraphDigits = Int(floor(log10(Double(maxParagraphIndex)))) + 1

            let longestString = String(repeating: "0", count: maximumParagraphDigits) as NSString
            let size = longestString.size(withAttributes: [.font: lineNumberFont])
            lineNumberSize = CGSize(width: ceil(size.width), height: ceil(size.height))
        }

        override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
            super.drawBackground(forGlyphRange: glyphsToShow, at: origin)

            guard let textStorage = textStorage as? TextStorage else { return }

            let string = textStorage.string as NSString
            let attributes: [NSAttributedStringKey: Any] = [.font: lineNumberFont]

            enumerateLineFragments(forGlyphRange: glyphsToShow) { rect, usedRect, textContainer, glyphRange, stop in
                let characterRange = self.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
                let paragraphRange = string.paragraphRange(for: characterRange)

                if characterRange.location == paragraphRange.location {
                    // First line fragment of paragraph (before wrapped text, if any)
                    let gutterRect = CGRect(x: origin.x, y: origin.y + rect.origin.y, width: self.lineNumberSize.width, height: max(rect.size.height, self.lineNumberSize.height))
                    let paragraphIndex = textStorage.paragraphIndex(at: characterRange.location)
                    let drawnString = String(paragraphIndex + 1) as NSString
                    drawnString.draw(with: gutterRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

                    // Check if we reached the end and if there is an extra empty line
                    if paragraphRange.upperBound == string.length && self.extraLineFragmentTextContainer != nil {
                        // Get the rect of the current empty line fragment
                        let extraLineFragmentRect = self.extraLineFragmentRect
                        let newLineGutterRect = CGRect(x: origin.x, y: origin.y + extraLineFragmentRect.origin.y, width: self.lineNumberSize.width, height: max(extraLineFragmentRect.size.height, self.lineNumberSize.height))
                        let drawnString = String(paragraphIndex + 2) as NSString
                        drawnString.draw(with: newLineGutterRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                    }
                }
            }
        }
    }

    init(frame: CGRect = .zero) {
        let textContainer = TextContainer()

        let layoutManager = LayoutManager()
        layoutManager.addTextContainer(textContainer)

        let textStorage = TextStorage()
        textStorage.addLayoutManager(layoutManager)

        super.init(frame: frame, textContainer: textContainer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
