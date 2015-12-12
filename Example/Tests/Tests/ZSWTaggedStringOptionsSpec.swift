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
        
        beforeEach {
            options = ZSWTaggedStringOptions()
        }
        
        it("should allow setting a static attributes") {
            options["a"] = .Static([
                "key": true
            ])
            
            guard let a = options["a"] else {
                fail("Could not retrieve after setting")
                return
            }
            
            switch a {
            case .Static(let attributes):
                expect(attributes["key"] as? Bool) == true
            case .Dynamic(_):
                fail("Retrieved a dynamic when expecting static")
            }
        }
        
        it("should allow setting dynamic attributes") {
            options["a"] = .Dynamic({ _, _, _ in
                return [
                    "key": true
                ]
            })
            
            guard let a = options["a"] else {
                fail("Could not retrieve after setting")
                return
            }
            
            switch a {
            case .Static(_):
                fail("Retrieved a static when expecting dynamic")
            case .Dynamic(let block):
                let attributes = block("a", [String: AnyObject](), [String: AnyObject]())
                expect(attributes["key"] as? Bool) == true
            }
        }
    }
} }