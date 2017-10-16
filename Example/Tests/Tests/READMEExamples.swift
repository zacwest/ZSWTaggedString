//
//  READMEExamples.swift
//  ZSWTaggedString
//
//  Created by Zachary West on 12/12/15.
//  Copyright © 2015 Zachary West. All rights reserved.
//

import UIKit
import Quick
import Nimble
import ZSWTaggedString

class Story {
    enum StoryType: String {
        case One = "one", Two = "two"
    }
    
    let type: StoryType
    let name: String
    
    init(type: StoryType, name: String) {
        self.type = type
        self.name = name
    }
}

class READMEExamplesSpec: QuickSpec { override func spec() {
    it("should have bold cool") {
        let localizedString = NSLocalizedString("bowties are <b>cool</b>", comment: "");
        let taggedString = ZSWTaggedString(string: localizedString)
        
        let options = ZSWTaggedStringOptions()
        
        options["b"] = .static([
            .font: UIFont.boldSystemFont(ofSize: 18.0)
        ])

        let attributedString = try! taggedString.attributedString(with: options)
        print(attributedString)
    }
    
    it("should have story types") {
        let story1 = Story(type: .One, name: "on<e")
        let story2 = Story(type: .Two, name: "tw<o")
        
        func storyWrap(_ story: Story) -> String {
            // You should separate data-level tags from the localized strings
            // so you can iterate on their definition without the .strings changing
            // Ideally you'd place this on the Story class itself.
            return String(format: "<story type='%d'>%@</story>",
                story.type.rawValue, ZSWEscapedStringForString(story.name))
        }
        
        let format = NSLocalizedString("Pick: %@ <i>or</i> %@", comment: "On the story, ...");
        let string = ZSWTaggedString(format: format, storyWrap(story1), storyWrap(story2))
        
        let options = ZSWTaggedStringOptions()
  
        // Base attributes apply to the whole string, before any tag attributes.
        options.baseAttributes = [
            .font: UIFont.systemFont(ofSize: 14.0),
            .foregroundColor: UIColor.gray
        ]

        // Normal attributes just add their attributes to the attributed string.
        options["i"] = .static([
            .font: UIFont.italicSystemFont(ofSize: 14.0)
        ])
        
        // Dynamic attributes give you an opportunity to decide what to do for each tag
        options["story"] = .dynamic({ tagName, tagAttributes, existingAttributes in
            var attributes = [NSAttributedStringKey: AnyObject]()
            
            guard let typeString = tagAttributes["type"] as? String,
                let type = Story.StoryType(rawValue: typeString) else {
                    return attributes
            }
            
            switch type {
            case .One:
                attributes[.foregroundColor] = UIColor.red
            case .Two:
                attributes[.foregroundColor] = UIColor.orange
            }
            
            return attributes
        })
        
        let attributedString = try! string.attributedString(with: options)
        print(attributedString)
    }
    
    it("should make dynamic bold and stuff easier") {
        let options = ZSWTaggedStringOptions()
        
        options.baseAttributes = [
            .font: UIFont.systemFont(ofSize: 12.0)
        ]
        
        options.unknownTagAttributes = .dynamic({ tagName, tagAttributes, existingAttributes in
            var attributes = [NSAttributedStringKey: Any]()
            
            if let font = existingAttributes[.font] as? UIFont {
                switch tagName {
                case "b":
                    attributes[.font] = UIFont.boldSystemFont(ofSize: font.pointSize)
                case "i":
                    attributes[.font] = UIFont.italicSystemFont(ofSize: font.pointSize)
                default:
                    break
                }
            }
            
            if tagName == "u" {
                attributes[.underlineStyle] = NSUnderlineStyle.styleSingle.rawValue
            }
            
            return attributes
        })

        let string = ZSWTaggedString(string: "<u>underline</u> <i>italic<u>andunder</u></i> <b>bo<u>l<i>d</i></u></b>")

        let attributedString = try! string.attributedString(with: options)
        print(attributedString)
    }
} }

