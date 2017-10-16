//
//  ZSWTaggedStringOptionsSpec.swift
//  ZSWTaggedString
//
//  Created by Zachary West on 12/12/15.
//  Copyright © 2015 Zachary West. All rights reserved.
//

import Quick
import Nimble
@testable import ZSWTaggedString

class ZSWTaggedStringOptionsSpec: QuickSpec { override func spec() {
    describe("swift setters") {
        var options: ZSWTaggedStringOptions!
        var string: NSMutableAttributedString!
        var tags: [ZSWStringParserTag]!
        
        beforeEach {
            options = ZSWTaggedStringOptions()
            
            string = NSMutableAttributedString(string: "a string")
            
            let aTag = ZSWStringParserTag(tagName: "a", startLocation: 0)
            aTag.update(with: ZSWStringParserTag(tagName: "/a", startLocation: 1))

            let stringTag = ZSWStringParserTag(tagName: "string", startLocation: 2)
            stringTag.update(with: ZSWStringParserTag(tagName: "/string", startLocation: 8))
            
            tags = [aTag, stringTag]
        }
        
        context("setting a static attribute") {
            let testKey = NSAttributedStringKey(rawValue: "key")
            
            beforeEach {
                options["a"] = .static([
                    testKey: true
                    ])
            }

            it("should be retrievable") {
                guard let a = options["a"] else {
                    fail("Could not retrieve after setting")
                    return
                }
                
                switch a {
                case .static(let attributes):
                    expect(attributes[testKey] as? Bool) == true
                case .dynamic(_):
                    fail("Retrieved a dynamic when expecting static")
                }
            }
            
            it("should still be performed on text") {
                options._private_update(string, updatedWithTags: tags)
                
                expect(string.attribute(testKey, at: 0, effectiveRange: nil) as? Bool) == true
            }
        }
        
        context("setting a dynamic attribute") {
            let testKey = NSAttributedStringKey(rawValue: "key")
            
            beforeEach {
                options["a"] = .dynamic({ _, _, _ in
                    return [
                        testKey: true
                    ]
                })
            }
            
            it("should be retrievable") {
                guard let a = options["a"] else {
                    fail("Could not retrieve after setting")
                    return
                }
                
                switch a {
                case .static(_):
                    fail("Retrieved a static when expecting dynamic")
                case .dynamic(let block):
                    let attributes = block("a", [String: Any](), [NSAttributedStringKey: Any]())
                    expect(attributes[testKey] as? Bool) == true
                }
            }
            
            it("should still be performed on text") {
                options._private_update(string, updatedWithTags: tags)
                
                expect(string.attribute(testKey, at: 0, effectiveRange: nil) as? Bool) == true
            }
        }
    }
} }
