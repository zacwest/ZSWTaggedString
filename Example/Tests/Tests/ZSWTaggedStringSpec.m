//
//  ZSWTaggedStringSpec.m
//  ZSWTaggedString
//
//  Created by Zachary West on 2015-02-21.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

SpecBegin(ZSWTaggedString)

describe(@"ZSWTaggedString", ^{
    __block ZSWTaggedString *taggedString;
    
    describe(@"when initialized with nil", ^{
        beforeEach(^{
            taggedString = [ZSWTaggedString stringWithString:nil];
        });
        
        it(@"should still allow itself to be created", ^{
            expect(taggedString).toNot.beNil();
        });
    });
    
    describe(@"when initialized with another string", ^{
        
    });
    
    describe(@"when initialized with a format", ^{
        
    });
});

SpecEnd
