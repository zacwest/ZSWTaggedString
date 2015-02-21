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
        
        it(@"should not be an end tag", ^{
            expect(tag.isEndingTag).to.beFalsy();
        });
        
        describe(@"when adding tag attributes", ^{
            describe(@"with a single attribute name", ^{
                beforeEach(^{
                    [tag addRawTagAttributes:@"someName"];
                });
                
                it(@"should a null value set for the name", ^{
                    expect(tag.tagAttributes).to.equal(@{@"someName": [NSNull null]});
                });
            });
            
            describe(@"with a single attribute name and value without quotes", ^{
                beforeEach(^{
                    [tag addRawTagAttributes:@"someName=someValue"];
                });
                
                it(@"should have a tag with the value", ^{
                    expect(tag.tagAttributes).to.equal(@{@"someName": @"someValue"});
                });
            });
            
            describe(@"when adding a single attribute name and value with single quotes", ^{
                beforeEach(^{
                    [tag addRawTagAttributes:@"someName='someValue'"];
                });
                
                it(@"should have the tag with the value", ^{
                    expect(tag.tagAttributes).to.equal(@{@"someName": @"someValue"});
                });
            });
            
            describe(@"when adding a single attribute name and value with double quotes", ^{
                beforeEach(^{
                    [tag addRawTagAttributes:@"someName=\"someValue\""];
                });
                
                it(@"should have the tag with the value", ^{
                    expect(tag.tagAttributes).to.equal(@{@"someName": @"someValue"});
                });
            });
            
            describe(@"when adding multiple attribute names without values", ^{
                beforeEach(^{
                    [tag addRawTagAttributes:@"someName anotherOne"];
                });
                
                it(@"should have the tag names", ^{
                    expect(tag.tagAttributes).to.contain(@"someName");
                    expect(tag.tagAttributes).to.contain(@"anotherOne");
                });
            });
            
            describe(@"when adding multiple attribute names, some without values", ^{
                describe(@"with value first", ^{
                    beforeEach(^{
                        [tag addRawTagAttributes:@"abc=123 yes no maybe"];
                    });
                    
                    it(@"should have the attributes", ^{
                        expect(tag.tagAttributes[@"abc"]).to.equal(@"123");
                        expect(tag.tagAttributes[@"yes"]).to.equal([NSNull null]);
                        expect(tag.tagAttributes[@"no"]).to.equal([NSNull null]);
                        expect(tag.tagAttributes[@"maybe"]).to.equal([NSNull null]);
                    });
                });
                
                describe(@"when the value last", ^{
                    beforeEach(^{
                        [tag addRawTagAttributes:@"yes no maybe abc=123"];
                    });
                    
                    it(@"should have the attributes", ^{
                        expect(tag.tagAttributes[@"abc"]).to.equal(@"123");
                        expect(tag.tagAttributes[@"yes"]).to.equal([NSNull null]);
                        expect(tag.tagAttributes[@"no"]).to.equal([NSNull null]);
                        expect(tag.tagAttributes[@"maybe"]).to.equal([NSNull null]);
                    });
                });
                
                describe(@"when the value in the middle", ^{
                    beforeEach(^{
                        [tag addRawTagAttributes:@"yes no abc=123 maybe"];
                    });
                    
                    it(@"should have the attributes", ^{
                        expect(tag.tagAttributes[@"abc"]).to.equal(@"123");
                        expect(tag.tagAttributes[@"yes"]).to.equal([NSNull null]);
                        expect(tag.tagAttributes[@"no"]).to.equal([NSNull null]);
                        expect(tag.tagAttributes[@"maybe"]).to.equal([NSNull null]);
                    });
                });
            });
            
            describe(@"when adding values with long quoted values", ^{
                beforeEach(^{
                    [tag addRawTagAttributes:@"hello='this is a long value' andthis='short'"];
                });
                
                it(@"should have the values", ^{
                    expect(tag.tagAttributes[@"hello"]).to.equal(@"this is a long value");
                    expect(tag.tagAttributes[@"andthis"]).to.equal(@"short");
                });
            });
            
            describe(@"when adding a value with no length", ^{
                beforeEach(^{
                    [tag addRawTagAttributes:@"moo='' short"];
                });
                
                it(@"should have the values set", ^{
                    expect(tag.tagAttributes[@"moo"]).to.equal(@"");
                    expect(tag.tagAttributes[@"short"]).to.equal([NSNull null]);
                });
            });
            
            describe(@"when adding an invalid value", ^{
                describe(@"ending the value early", ^{
                    beforeEach(^{
                        [tag addRawTagAttributes:@"something="];
                    });
                    
                    it(@"should set the tag", ^{
                        expect(tag.tagAttributes[@"something"]).to.equal([NSNull null]);
                    });
                });
                
                describe(@"failing to close a quote in the middle", ^{
                    beforeEach(^{
                        [tag addRawTagAttributes:@"something='moo we=keep going"];
                    });
                    
                    it(@"should set the value", ^{
                        expect(tag.tagAttributes[@"something"]).to.equal(@"moo we=keep going");
                    });
                });
                
                describe(@"failing to close a quote at the end", ^{
                    beforeEach(^{
                        [tag addRawTagAttributes:@"something='"];
                    });
                    
                    it(@"should have something", ^{
                        expect(tag.tagAttributes[@"something"]).to.equal([NSNull null]);
                    });
                });
            });
        });
    });
});

SpecEnd

