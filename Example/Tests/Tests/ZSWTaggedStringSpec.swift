//
//  SwiftTests.swift
//  ZSWTaggedString
//
//  Created by Zachary West on 12/6/15.
//  Copyright © 2015 Zachary West. All rights reserved.
//

import Quick
import Nimble
@testable import ZSWTaggedString

class ZSWTaggedStringTests: QuickSpec { override func spec() {
    context("initialization") {
        it("should be initable via format") {
            let string = ZSWTaggedString(format: "test %@", "a")
            expect(string.underlyingString) == "test a"
        }
        
        it("should be initiable via a string") {
            let string = ZSWTaggedString(string: "a string")
            expect(string.underlyingString) == "a string"
        }
    }
    
    context("invalid strings") {
        it("should throw for bad tags") {
            let string = ZSWTaggedString(string: "<a>moo")
            do {
                let output = try string.string()
                fail("should have thrown but got \(output)")
            } catch let error as NSError {
                expect(error.domain) == ZSWTaggedStringErrorDomain
                expect(error.code) == ZSWTaggedStringErrorCode.invalidTags.rawValue
            }
        }
    }
} }
