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
    enum StoryType: Int {
        case One = 0, Two = 1
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
        options["b"] = .Static([
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0)
        ])

        let attributedString = try! taggedString.attributedStringWithOptions(options)
        print(attributedString)
    }
    
    it("should have story types") {
        let story1 = Story(type: .One, name: "on<e")
        let story2 = Story(type: .Two, name: "tw<o")
        
        func storyWrap(story: Story) -> String {
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
            NSFontAttributeName: UIFont.systemFontOfSize(14.0),
            NSForegroundColorAttributeName: UIColor.grayColor()
        ]

        // Normal attributes just add their attributes to the attributed string.
        options["i"] = .Static([
            NSFontAttributeName: UIFont.italicSystemFontOfSize(14.0)
        ])
        
        // Dynamic attributes give you an opportunity to decide what to do for each tag
        options["story"] = .Dynamic({ tagName, tagAttributes, existingAttributes in
            var attributes = [String: AnyObject]()
            
            guard let rawType = tagAttributes["type"] as? Int,
                let type = Story.StoryType(rawValue: rawType) else {
                    return attributes
            }
            
            switch type {
            case .One:
                attributes[NSForegroundColorAttributeName] = UIColor.redColor()
            case .Two:
                attributes[NSForegroundColorAttributeName] = UIColor.orangeColor()
            }
            
            return attributes
        })
        
        let attributedString = try! string.attributedStringWithOptions(options)
        print(attributedString)
    }
    
    it("should make dynamic bold and stuff easier") {
        let options = ZSWTaggedStringOptions()
        
        options.baseAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(12.0)
        ]
        
        options.unknownTagAttributes = .Dynamic({ tagName, tagAttributes, existingAttributes in
            var attributes = [String: AnyObject]()
            
            if let font = existingAttributes[NSFontAttributeName] as? UIFont {
                switch tagName {
                case "b":
                    attributes[NSFontAttributeName] = UIFont.boldSystemFontOfSize(font.pointSize)
                case "i":
                    attributes[NSFontAttributeName] = UIFont.italicSystemFontOfSize(font.pointSize)
                default:
                    break
                }
            }
            
            if tagName == "u" {
                attributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
            }
            
            return attributes
        })

        let string = ZSWTaggedString(string: "<u>underline</u> <i>italic<u>andunder</u></i> <b>bo<u>l<i>d</i></u></b>")

        let attributedString = try! string.attributedStringWithOptions(options)
        print(attributedString)
    }
} }

