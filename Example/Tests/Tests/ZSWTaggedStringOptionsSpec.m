//
//  ZSWTaggedStringOptionsSpec.m
//  ZSWTaggedString
//
//  Created by Zachary West on 2015-02-22.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

#import "ZSWStringParser.h"
#import "ZSWStringParserTag.h"

SpecBegin(ZSWTaggedStringOptions)

describe(@"ZSWTaggedStringOptions", ^{
    beforeEach(^{
        // reset global state
        [ZSWTaggedStringOptions registerDefaultOptions:nil];
    });
    
    describe(@"default options", ^{
        it(@"should return an empty options by default", ^{
            ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions defaultOptions];
            expect(options.baseAttributes).to.haveCountOf(0);
            expect(options.tagToAttributesMap).to.haveCountOf(0);
        });
        
        it(@"should return an identical empty options each time", ^{
            expect([ZSWTaggedStringOptions defaultOptions]).to.beIdenticalTo([ZSWTaggedStringOptions defaultOptions]);
        });
        
        describe(@"when registering defaults", ^{
            __block ZSWTaggedStringOptions *options;
            
            beforeEach(^{
                options = [ZSWTaggedStringOptions options];
            });
            
            it(@"should return an equal instance that isn't the same", ^{
                expect([ZSWTaggedStringOptions defaultOptions]).to.equal(options);
                expect([ZSWTaggedStringOptions defaultOptions]).toNot.beIdenticalTo(options);
            });
            
            describe(@"when mutated after registration", ^{
                beforeEach(^{
                    options.baseAttributes = @{ NSForegroundColorAttributeName: [UIColor redColor] };
                });
                
                it(@"should not modify the default options", ^{
                    expect([ZSWTaggedStringOptions defaultOptions]).toNot.equal(options);
                });
            });
        });
    });
    
    sharedExamples(@"a happy options", ^(NSDictionary *data) {
        __block ZSWTaggedStringOptions *options;
        
        beforeEach(^{
            options = data[@"o"];
        });
        
        describe(@"when encoded and decoded", ^{
            __block ZSWTaggedStringOptions *unarchivedOptions;
            
            beforeEach(^{
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:options];
                unarchivedOptions = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            });
            
            it(@"should compare equal", ^{
                expect(unarchivedOptions).to.equal(options);
                expect(unarchivedOptions.hash).to.equal(options.hash);
            });
        });
        
        describe(@"when copied", ^{
            __block ZSWTaggedString *copiedOptions;
            
            beforeEach(^{
                copiedOptions = [options copy];
            });
            
            it(@"should compare equal", ^{
                expect(copiedOptions).to.equal(options);
                expect(copiedOptions.hash).to.equal(options.hash);
            });
        });
    });
    
    describe(@"when created with base attributes", ^{
        __block ZSWTaggedStringOptions *options;
        __block NSDictionary *baseAttributes;
        
        beforeEach(^{
            baseAttributes = @{ NSForegroundColorAttributeName: [UIColor redColor],
                                NSFontAttributeName: [UIFont systemFontOfSize:12.0] };
            options = [ZSWTaggedStringOptions optionsWithBaseAttributes:baseAttributes];
        });
        
        it(@"should update a string to have the attributes", ^{
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"a string" attributes:nil];
            [options updateAttributedString:string updatedWithTags:nil];
            expect(string).to.haveAttributeWithEnd(NSForegroundColorAttributeName, [UIColor redColor], 0, string.length);
            expect(string).to.haveAttributeWithEnd(NSFontAttributeName, [UIFont systemFontOfSize:12.0], 0, string.length);
            expect(string.string).to.equal(@"a string");
        });
        
        describe(@"when extending the base attributes", ^{
            beforeEach(^{
                baseAttributes = @{ NSForegroundColorAttributeName: [UIColor orangeColor],
                                    NSFontAttributeName: [UIFont italicSystemFontOfSize:12.0] };
                options.baseAttributes = baseAttributes;
            });
            
            it(@"should produce a string with the new attributes", ^{
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"a string" attributes:nil];
                [options updateAttributedString:string updatedWithTags:nil];
                expect(string).to.haveAttributeWithEnd(NSForegroundColorAttributeName, [UIColor orangeColor], 0, string.length);
                expect(string).to.haveAttributeWithEnd(NSFontAttributeName, [UIFont italicSystemFontOfSize:12.0], 0, string.length);
                expect(string.string).to.equal(@"a string");
            });
        });
        
        describe(@"when adding a normal tag attribute", ^{
            beforeEach(^{
                [options setAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor] }
                            forTagName:@"stringType"];
            });
            
            it(@"should produce a string with modified attributes", ^{
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"a happy string" attributes:nil];
                ZSWStringParserTag *tag = [[ZSWStringParserTag alloc] initWithTagName:@"stringType" startLocation:2];
                [tag updateWithTag:[[ZSWStringParserTag alloc] initWithTagName:@"/stringType" startLocation:7]];
                
                [options updateAttributedString:string updatedWithTags:@[ tag ]];
                expect(string).to.haveAttributeWithEnd(NSForegroundColorAttributeName, [UIColor redColor], 0, 2);
                expect(string).to.haveAttributeWithEnd(NSForegroundColorAttributeName, [UIColor blackColor], 2, 7);
                expect(string).to.haveAttributeWithEnd(NSForegroundColorAttributeName, [UIColor redColor], 7, 14);
                expect(string).to.haveAttributeWithEnd(NSFontAttributeName, [UIFont systemFontOfSize:12.0], 0, string.length);
                expect(string.string).to.equal(@"a happy string");
            });
        });
    });
});

SpecEnd
