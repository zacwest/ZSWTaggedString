//
//  ZSWStringParserSpec.m
//  ZSWTaggedString
//
//  Created by Zachary West on 2015-02-22.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

@import ZSWTaggedString.Private;

SpecBegin(ZSWStringParser)

describe(@"ZSWStringParser", ^{
    describe(@"when providing erroneous strings", ^{
        it(@"should return an error if tags aren't ended", ^{
            NSError *error;
            id string = [ZSWStringParser stringWithTaggedString:[ZSWTaggedString stringWithString:@"<tag>moo"]
                                                        options:[ZSWTaggedStringOptions options]
                                                    returnClass:[NSString class]
                                                          error:&error];
            
            expect(string).to.beNil();
            expect(error.domain).to.equal(ZSWTaggedStringErrorDomain);
            expect(error.code).to.equal(ZSWTaggedStringErrorCodeInvalidTags);
            
            // and without an error arg
            string = [ZSWStringParser stringWithTaggedString:[ZSWTaggedString stringWithString:@"<tag>moo"]
                                                     options:[ZSWTaggedStringOptions options]
                                                 returnClass:[NSString class]
                                                       error:nil];
            expect(string).to.beNil();
        });
        
        it(@"should throw an exception if tags are ended out-of-order", ^{
            NSError *error;
            
            id string = [ZSWStringParser stringWithTaggedString:[ZSWTaggedString stringWithString:@"<tag><elephant>moo</tag></elephant>"]
                                                        options:[ZSWTaggedStringOptions options]
                                                    returnClass:[NSString class]
                                                          error:&error];
            expect(string).to.beNil();
            expect(error.domain).to.equal(ZSWTaggedStringErrorDomain);
            expect(error.code).to.equal(ZSWTaggedStringErrorCodeInvalidTags);
            
            // and without an error arg
            string = [ZSWStringParser stringWithTaggedString:[ZSWTaggedString stringWithString:@"<tag><elephant>moo</tag></elephant>"]
                                                     options:[ZSWTaggedStringOptions options]
                                                 returnClass:[NSString class]
                                                       error:nil];
            expect(string).to.beNil();
        });
    });
    
    __block id mockOptions;
    
    beforeEach(^{
        mockOptions = [OCMockObject mockForClass:[ZSWTaggedStringOptions class]];
    });
    
    it(@"should handle a tag with no strings", ^{
        ZSWTaggedString *taggedString = [ZSWTaggedString stringWithString:@"<cattail down='true'></cattail>"];
        
        NSArray *tags;
        [[mockOptions expect] _private_updateAttributedString:OCMOCK_ANY
                                              updatedWithTags:[OCMArg capture:&tags]];
        
        NSError *error;
        
        id string = [[ZSWStringParser stringWithTaggedString:taggedString
                                                     options:mockOptions
                                                 returnClass:[NSAttributedString class]
                                                       error:&error] string];
        
        expect(string).to.equal(@"");
        expect(error).to.beNil();
        expect(tags).to.haveCountOf(1);
        
        ZSWStringParserTag *tag = tags.firstObject;
        expect(tag.tagName).to.equal(@"cattail");
        expect(tag.tagRange.location).to.equal(0);
        expect(tag.tagRange.length).to.equal(0);
    });
    
    it(@"should handle a string with no tags", ^{
        ZSWTaggedString *taggedString = [ZSWTaggedString stringWithString:@"no more timothy hay!"];
        
        NSArray *tags;
        [[mockOptions expect] _private_updateAttributedString:OCMOCK_ANY
                                              updatedWithTags:[OCMArg capture:&tags]];
        
        NSError *error;
        
        id string = [[ZSWStringParser stringWithTaggedString:taggedString
                                                     options:mockOptions
                                                 returnClass:[NSAttributedString class]
                                                       error:&error] string];
        
        expect(string).to.equal(@"no more timothy hay!");
        expect(error).to.beNil();
        expect(tags).to.haveCountOf(0);
    });
    
    it(@"should handle a string wrapped in one tag", ^{
        ZSWTaggedString *taggedString = [ZSWTaggedString stringWithString:@"<all>circles presuppose</all>"];
        
        NSArray *tags;
        [[mockOptions expect] _private_updateAttributedString:OCMOCK_ANY
                                              updatedWithTags:[OCMArg capture:&tags]];
        
        NSError *error;
        id string = [[ZSWStringParser stringWithTaggedString:taggedString
                                                     options:mockOptions
                                                 returnClass:[NSAttributedString class]
                                                       error:&error] string];
        
        expect(string).to.equal(@"circles presuppose");
        expect(tags).to.haveCountOf(1);
        expect(error).to.beNil();
        
        ZSWStringParserTag *tag = tags.firstObject;
        expect(tag.tagName).to.equal(@"all");
        expect(tag.tagRange.location).to.equal(0);
        expect(tag.tagRange.length).to.equal(18);
    });
    
    it(@"should handle a string with two outer tags which entirely overlap", ^{
        ZSWTaggedString *taggedString = [ZSWTaggedString stringWithString:@"<some><all>circles presuppose</all></some>"];
        
        NSArray *tags;
        [[mockOptions expect] _private_updateAttributedString:OCMOCK_ANY
                                              updatedWithTags:[OCMArg capture:&tags]];
        
        NSError *error;
        id string = [[ZSWStringParser stringWithTaggedString:taggedString
                                                     options:mockOptions
                                                 returnClass:[NSAttributedString class]
                                                       error:&error] string];
        
        expect(string).to.equal(@"circles presuppose");
        expect(tags).to.haveCountOf(2);
        expect(error).to.beNil();
        
        ZSWStringParserTag *someTag = tags[0];
        // some should go first, because outer ones are processed first
        expect(someTag.tagName).to.equal(@"some");
        expect(someTag.tagRange.location).to.equal(0);
        expect(someTag.tagRange.length).to.equal(18);
        
        ZSWStringParserTag *allTag = tags[1];
        expect(allTag.tagName).to.equal(@"all");
        expect(allTag.tagRange.location).to.equal(0);
        expect(allTag.tagRange.length).to.equal(18);
    });
    
    it(@"should handle a string with multiple overlapping and non-overlapping tags", ^{
        ZSWTaggedString *taggedString = [ZSWTaggedString stringWithString:@"<all><qual>If I come <sad >without</sad> a thing</qual>, <suppose >then I come with <happy>all</happy> I need</suppose></all>"];
        
        NSArray *tags;
        [[mockOptions expect] _private_updateAttributedString:OCMOCK_ANY
                                              updatedWithTags:[OCMArg capture:&tags]];
        
        NSError *error;
        id string = [[ZSWStringParser stringWithTaggedString:taggedString
                                                     options:mockOptions
                                                 returnClass:[NSAttributedString class]
                                                       error:&error] string];
        
        expect(string).to.equal(@"If I come without a thing, then I come with all I need");
        expect(tags).to.haveCountOf(5);
        expect(error).to.beNil();
        
        ZSWStringParserTag *allTag = tags[0];
        expect(allTag.tagName).to.equal(@"all");
        expect(allTag.tagRange.location).to.equal(0);
        expect(allTag.tagRange.length).to.equal(54);
        
        ZSWStringParserTag *supposeTag = tags[1];
        expect(supposeTag.tagName).to.equal(@"suppose");
        expect(supposeTag.tagRange.location).to.equal(27);
        expect(supposeTag.tagRange.length).to.equal(27);
        
        ZSWStringParserTag *happyTag = tags[2];
        expect(happyTag.tagName).to.equal(@"happy");
        expect(happyTag.tagRange.location).to.equal(44);
        expect(happyTag.tagRange.length).to.equal(3);
        
        ZSWStringParserTag *qualTag = tags[3];
        expect(qualTag.tagName).to.equal(@"qual");
        expect(qualTag.tagRange.location).to.equal(0);
        expect(qualTag.tagRange.length).to.equal(25);
        
        ZSWStringParserTag *sadTag = tags[4];
        expect(sadTag.tagName).to.equal(@"sad");
        expect(sadTag.tagRange.location).to.equal(10);
        expect(sadTag.tagRange.length).to.equal(7);
    });
    
    it(@"should handle a string with empty tags", ^{
        ZSWTaggedString *taggedString = [ZSWTaggedString stringWithString:@"i am <hungry type=lol></hungry>banana"];
        
        NSArray *tags;
        [[mockOptions expect] _private_updateAttributedString:OCMOCK_ANY
                                              updatedWithTags:[OCMArg capture:&tags]];
        
        NSError *error;
        id string = [[ZSWStringParser stringWithTaggedString:taggedString
                                                     options:mockOptions
                                                 returnClass:[NSAttributedString class]
                                                       error:&error] string];
        
        expect(string).to.equal(@"i am banana");
        expect(tags).to.haveCountOf(1);
        expect(error).to.beNil();
        
        ZSWStringParserTag *tag = tags.firstObject;
        expect(tag.tagName).to.equal(@"hungry");
        expect(tag.tagRange.location).to.equal(5);
        expect(tag.tagRange.length).to.equal(0);
        
        expect(tag.tagAttributes).to.equal(@{@"type": @"lol"});
    });
    
    it(@"should handle a string containing an escaped string", ^{
        ZSWTaggedString *taggedString = [ZSWTaggedString stringWithFormat:@"i like to eat <eat>%@</eat>", ZSWEscapedStringForString(@"<apples>")];
        
        NSArray *tags;
        [[mockOptions expect] _private_updateAttributedString:OCMOCK_ANY
                                              updatedWithTags:[OCMArg capture:&tags]];
        
        NSError *error;
        id string = [[ZSWStringParser stringWithTaggedString:taggedString
                                                     options:mockOptions
                                                 returnClass:[NSAttributedString class]
                                                       error:&error] string];
        
        expect(string).to.equal(@"i like to eat <apples>");
        expect(tags).to.haveCountOf(1);
        expect(error).to.beNil();
        
        ZSWStringParserTag *tag = tags.firstObject;
        expect(tag.tagName).to.equal(@"eat");
        expect(tag.tagRange.location).to.equal(14);
        expect(tag.tagRange.length).to.equal(8);
    });
    
    it(@"should handle a string containing an escaped string at the very end", ^{
        ZSWTaggedString *taggedString = [ZSWTaggedString stringWithFormat:@"i like to eat %@", ZSWEscapedStringForString(@"<")];
        
        NSArray *tags;
        [[mockOptions expect] _private_updateAttributedString:OCMOCK_ANY
                                              updatedWithTags:[OCMArg capture:&tags]];
        
        NSError *error;
        id string = [[ZSWStringParser stringWithTaggedString:taggedString
                                                     options:mockOptions
                                                 returnClass:[NSAttributedString class]
                                                       error:&error] string];
        
        expect(string).to.equal(@"i like to eat <");
        expect(tags).to.haveCountOf(0);
    });
});

SpecEnd
