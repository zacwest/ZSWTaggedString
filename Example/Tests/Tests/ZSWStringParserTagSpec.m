//
//  ZSWStringParserTagSpec.m
//  ZSWTaggedString
//
//  Created by Zachary West on 2015-02-21.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

#import "ZSWStringParserTag.h"

SpecBegin(ZSWStringParserTag)

describe(@"ZSWStringParserTag", ^{
    __block ZSWStringParserTag *tag;
    
    describe(@"a starter tag", ^{
        beforeEach(^{
            tag = [[ZSWStringParserTag alloc] initWithTagName:@"tagtag"
                                                startLocation:4];
        });
        
        it(@"should preserve what we told it", ^{
            expect(tag.tagName).to.equal(@"tagtag");
            expect(tag.location).to.equal(4);
        });
        
        it(@"should not be ended by itself", ^{
            expect([tag isEndedByTag:tag]).to.beFalsy();
        });
        
        it(@"should not be ended by a tag with a different name", ^{
            ZSWStringParserTag *anotherTag = [[ZSWStringParserTag alloc] initWithTagName:@"/banana" startLocation:5];
            expect([tag isEndedByTag:anotherTag]).to.beFalsy();
        });
        
        it(@"should be ended by a tag with different case but the same name", ^{
            ZSWStringParserTag *anotherTag = [[ZSWStringParserTag alloc] initWithTagName:@"/tagTaG" startLocation:10];
            expect([tag isEndedByTag:anotherTag]).to.beTruthy();
        });
        
        it(@"should not be an end tag", ^{
            expect(tag.isEndingTag).to.beFalsy();
        });
        
        it(@"should not yet return a range", ^{
            NSRange tagRange = tag.tagRange;
            expect(tagRange.location).to.equal(4);
            expect(tagRange.length).to.equal(0);
        });
        
        describe(@"when adding tag attributes", ^{
            it(@"should handle a single attribute without value", ^{
                [tag addRawTagAttributes:@"someName"];
                expect(tag.tagAttributes).to.equal(@{@"someName": [NSNull null]});
            });

            it(@"should handle a single attribute name with an unquoted value", ^{
                [tag addRawTagAttributes:@"someName=someValue"];
                expect(tag.tagAttributes).to.equal(@{@"someName": @"someValue"});
            });
            
            it(@"should handle a single attribute with a single-quoted value", ^{
                [tag addRawTagAttributes:@"someName='someValue'"];
                expect(tag.tagAttributes).to.equal(@{@"someName": @"someValue"});
            });
            
            it(@"should handle a single attribute with a double-quoted value", ^{
                [tag addRawTagAttributes:@"someName=\"someValue\""];
                expect(tag.tagAttributes).to.equal(@{@"someName": @"someValue"});
            });
            
            it(@"should handle multiple attributes without values", ^{
                [tag addRawTagAttributes:@"someName anotherOne"];
                expect(tag.tagAttributes).to.contain(@"someName");
                expect(tag.tagAttributes).to.contain(@"anotherOne");
            });
            
            describe(@"when adding multiple attribute names, some without values", ^{
                it(@"should handle with the value first", ^{
                    [tag addRawTagAttributes:@"abc=123 yes no maybe"];
                    expect(tag.tagAttributes[@"abc"]).to.equal(@"123");
                    expect(tag.tagAttributes[@"yes"]).to.equal([NSNull null]);
                    expect(tag.tagAttributes[@"no"]).to.equal([NSNull null]);
                    expect(tag.tagAttributes[@"maybe"]).to.equal([NSNull null]);
                });
                
                it(@"should handle with the value last", ^{
                    [tag addRawTagAttributes:@"yes no maybe abc=123"];
                    expect(tag.tagAttributes[@"abc"]).to.equal(@"123");
                    expect(tag.tagAttributes[@"yes"]).to.equal([NSNull null]);
                    expect(tag.tagAttributes[@"no"]).to.equal([NSNull null]);
                    expect(tag.tagAttributes[@"maybe"]).to.equal([NSNull null]);
                });
                
                it(@"should handle with the value in the middle", ^{
                    [tag addRawTagAttributes:@"yes no abc=123 maybe"];
                    expect(tag.tagAttributes[@"abc"]).to.equal(@"123");
                    expect(tag.tagAttributes[@"yes"]).to.equal([NSNull null]);
                    expect(tag.tagAttributes[@"no"]).to.equal([NSNull null]);
                    expect(tag.tagAttributes[@"maybe"]).to.equal([NSNull null]);
                });
            });
            
            it(@"should handle long-quoted values", ^{
                [tag addRawTagAttributes:@"hello='this is a long value' andthis='short'"];
                expect(tag.tagAttributes[@"hello"]).to.equal(@"this is a long value");
                expect(tag.tagAttributes[@"andthis"]).to.equal(@"short");
            });
            
            it(@"should handle empty string quoted values", ^{
                [tag addRawTagAttributes:@"moo='' short"];
                expect(tag.tagAttributes[@"moo"]).to.equal(@"");
                expect(tag.tagAttributes[@"short"]).to.equal([NSNull null]);
            });
            
            describe(@"when adding invalid values", ^{
                it(@"should handle a value ending early", ^{
                    [tag addRawTagAttributes:@"something="];
                    expect(tag.tagAttributes[@"something"]).to.equal([NSNull null]);
                });
                
                it(@"should handle a quote failing to close", ^{
                    [tag addRawTagAttributes:@"something='moo we=keep going"];
                    expect(tag.tagAttributes[@"something"]).to.equal(@"moo we=keep going");
                });
                
                it(@"should handle a quote not ending at the end", ^{
                    [tag addRawTagAttributes:@"something='value"];
                    expect(tag.tagAttributes[@"something"]).to.equal(@"value");
                });
            });
        });
        
        describe(@"when updated with an end tag", ^{
            __block ZSWStringParserTag *endTag;
            
            beforeEach(^{
                endTag = [[ZSWStringParserTag alloc] initWithTagName:@"/tagtag"
                                                       startLocation:20];
                
                [tag updateWithTag:endTag];
            });
            
            it(@"should return a range", ^{
                NSRange tagRange = tag.tagRange;
                expect(tagRange.location).to.equal(4);
                expect(tagRange.length).to.equal(16);
            });
        });
    });
});

SpecEnd

