//
//  ZSWTaggedStringSpec.m
//  ZSWTaggedString
//
//  Created by Zachary West on 2015-02-21.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

@import ZSWTaggedString;
@import ZSWTaggedString.Private;

SpecBegin(ZSWTaggedString)

describe(@"ZSWTaggedString", ^{
    sharedExamples(@"a happy string", ^(NSDictionary *data) {
        __block ZSWTaggedString *taggedString;
        
        beforeEach(^{
            taggedString = data[@"s"];
            expect(taggedString).toNot.beNil();
        });
        
        describe(@"when encoded and decoded", ^{
            __block ZSWTaggedString *unarchivedString;
            
            beforeEach(^{
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:taggedString];
                unarchivedString = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            });
            
            it(@"should compare equal", ^{
                expect(unarchivedString).to.equal(taggedString);
                expect(unarchivedString.hash).to.equal(taggedString.hash);
            });
        });
        
        describe(@"when copied", ^{
            __block ZSWTaggedString *copiedString;
            
            beforeEach(^{
                copiedString = [taggedString copy];
            });
            
            it(@"should compare equal", ^{
                expect(copiedString).to.equal(taggedString);
                expect(copiedString.hash).to.equal(taggedString.hash);
            });
        });
        
        describe(@"when asking for representations", ^{
            __block id mockParser;
            
            beforeEach(^{
                mockParser = [OCMockObject mockForClass:[ZSWStringParser class]];
            });
            
            afterEach(^{
                [mockParser stopMocking];
            });
            
            describe(@"when asking for a basic string with no options", ^{
                beforeEach(^{
                    [[[mockParser expect] andReturn:@"yay"] stringWithTaggedString:taggedString
                                                                           options:[ZSWTaggedStringOptions defaultOptions]
                                                                       returnClass:[NSString class]
                                                                             error:(NSError __autoreleasing **)[OCMArg anyPointer]];
                    
                    expect(taggedString.string).to.equal(@"yay");
                });
               
                it(@"should have asked the parser for the string", ^{
                    [mockParser verify];
                });
            });
            
            describe(@"when asked for a basic string with options", ^{
                beforeEach(^{
                    ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions options];
                    [options setBaseAttributes:@{ NSForegroundColorAttributeName: [UIColor redColor] }];
                    
                    [[[mockParser expect] andReturn:@"moo"] stringWithTaggedString:taggedString
                                                                           options:options
                                                                       returnClass:[NSString class]
                                                                             error:(NSError __autoreleasing **)[OCMArg anyPointer]];
                    
                    expect([taggedString stringWithOptions:options]).to.equal(@"moo");
                });
                
                it(@"should have asked the parser for the string", ^{
                    [mockParser verify];
                });
            });
            
            describe(@"when asked for an attributed string", ^{
                beforeEach(^{
                    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"hooray" attributes:nil];
                    [[[mockParser expect] andReturn:string] stringWithTaggedString:taggedString
                                                                           options:[ZSWTaggedStringOptions defaultOptions]
                                                                       returnClass:[NSAttributedString class]
                                                                             error:(NSError __autoreleasing **)[OCMArg anyPointer]];
                    
                    expect(taggedString.attributedString).to.equal(string);
                });
                
                it(@"should have asked the parser for the string", ^{
                    [mockParser verify];
                });
            });
            
            describe(@"when asked for an attributed string with options", ^{
                beforeEach(^{
                    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"mooark" attributes:nil];
                    ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions options];
                    [options setBaseAttributes:@{ NSForegroundColorAttributeName: [UIColor orangeColor] }];
                    
                    [[[mockParser expect] andReturn:string] stringWithTaggedString:taggedString
                                                                           options:options
                                                                       returnClass:[NSAttributedString class]
                                                                             error:(NSError __autoreleasing **)[OCMArg anyPointer]];
                    
                    expect([taggedString attributedStringWithOptions:options]).to.equal(string);
                });
                
                it(@"should have asked the parser for the string", ^{
                    [mockParser verify];
                });
            });
        });
    });
    
    describe(@"when initialized with nil", ^{
        __block ZSWTaggedString *taggedString;
        
        beforeEach(^{
            taggedString = [ZSWTaggedString stringWithString:nil];
        });
        
        it(@"should still allow itself to be created", ^{
            expect(taggedString).toNot.beNil();
        });
        
        itShouldBehaveLike(@"a happy string", ^{ return @{ @"s": taggedString }; });
    });
    
    describe(@"when initialized with another string", ^{
        __block ZSWTaggedString *taggedString;
        
        beforeEach(^{
            NSMutableString *someString = [NSMutableString stringWithString:@"Before"];
            taggedString = [ZSWTaggedString stringWithString:someString];
            [someString appendString:@"After"];
        });
        
        it(@"should not have mutated", ^{
            expect(taggedString.string).to.equal(@"Before");
        });
        
        itShouldBehaveLike(@"a happy string", ^{ return @{ @"s": taggedString }; });
    });
    
    describe(@"when initialized with a format", ^{
        __block ZSWTaggedString *taggedString;
        
        beforeEach(^{
            taggedString = [ZSWTaggedString stringWithFormat:@"a %@ b %.02f c", @(1), 1.1];
        });
        
        it(@"should have created the right string", ^{
            expect(taggedString.string).to.equal(@"a 1 b 1.10 c");
        });
        
        itShouldBehaveLike(@"a happy string", ^{ return @{ @"s": taggedString }; });
    });
});

SpecEnd
