//
//  ZSWStringParserSpec.m
//  ZSWTaggedString
//
//  Created by Zachary West on 2015-02-22.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

#import "ZSWStringParser.h"

SpecBegin(ZSWStringParser)

describe(@"ZSWStringParser", ^{
    describe(@"when providing erroneous strings", ^{
        it(@"should throw an exception if tags aren't ended", ^{
            expect(^{
                [ZSWStringParser stringWithTaggedString:[ZSWTaggedString stringWithString:@"<tag>moo"]
                                                options:[ZSWTaggedStringOptions options]
                                            returnClass:[NSString class]];
            }).to.raise(NSInvalidArgumentException);
        });
        
        it(@"should throw an exception if tags are ended out-of-order", ^{
            expect(^{
                [ZSWStringParser stringWithTaggedString:[ZSWTaggedString stringWithString:@"<tag><elephant>moo</tag></elephant>"]
                                                options:[ZSWTaggedStringOptions options]
                                            returnClass:[NSString class]];
            }).to.raise(NSInvalidArgumentException);
        });
    });
    
    
});

SpecEnd
