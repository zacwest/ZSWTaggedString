//
//  ZSWMatchers+haveAttribute.m
//  ZSWStringParser
//
//  Created by Zachary West on 2015-02-21.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

#import "ZSWMatchers+haveAttribute.h"
#import "EXPMatcherHelpers.h"

EXPMatcherImplementationBegin(_haveAttributeWithEnd, (id attributeName, id attributeValue, id locationStart, id locationEnd)) {
    BOOL actualIsNotAttributed = ![actual isKindOfClass:[NSAttributedString class]];
    BOOL attributeNameIsNotString = ![attributeName isKindOfClass:[NSString class]];
    BOOL locationStartNotNumber = ![locationStart isKindOfClass:[NSNumber class]];
    BOOL locationEndNotNumber = (locationEnd && ![locationEnd isKindOfClass:[NSNumber class]]);
    
    BOOL locationStartOutOfBounds = NO, locationEndOutOfBounds = NO;
    if (!actualIsNotAttributed) {
        if ([locationStart integerValue] < 0 || [locationStart integerValue] >= [actual length]) {
            locationStartOutOfBounds = YES;
        }
        
        if (locationEnd && ([locationEnd integerValue] < 0 || [locationEnd integerValue] >= [actual length])) {
            locationEndOutOfBounds = YES;
        }
    }
                        
    __block id stringsValue;
    __block NSRange effectiveRange;
    __block BOOL containsEndLocation;
    
    prerequisite(^BOOL{
        if (actualIsNotAttributed || attributeNameIsNotString || locationStartNotNumber || locationEndNotNumber || locationStartOutOfBounds || locationEndOutOfBounds) {
            return NO;
        }
        
        stringsValue = [(NSAttributedString *)actual attribute:attributeName atIndex:[locationStart integerValue] effectiveRange:&effectiveRange];
        containsEndLocation = NSLocationInRange([locationEnd integerValue], effectiveRange);
        
        return YES;
    });
    
    match(^BOOL{
        BOOL valueMatches = (stringsValue == attributeValue || [stringsValue isEqual:attributeValue]);
        BOOL rangeMatches = (!locationEnd || containsEndLocation);
        return valueMatches && rangeMatches;
    });

    failureMessageForTo(^NSString *{
        if (actualIsNotAttributed) {
            return [NSString stringWithFormat:@"the actual value is a %@ not an attributed string", NSStringFromClass([actual class])];
        }
        
        if (attributeNameIsNotString) {
            return [NSString stringWithFormat:@"the attribute name is a %@ not a string", NSStringFromClass([attributeName class])];
        }
        
        if (locationStartNotNumber) {
            return [NSString stringWithFormat:@"the start location is a %@ not a number", NSStringFromClass([locationStart class])];
        }
        
        if (locationEndNotNumber) {
            return [NSString stringWithFormat:@"the end location is a %@ not a number", NSStringFromClass([locationEnd class])];
        }
        
        if (locationStartOutOfBounds) {
            return [NSString stringWithFormat:@"the start location %@ is out of the bounds of string length %@", locationStart, @([(NSAttributedString *)actual length])];
        }
        
        if (locationEndOutOfBounds) {
            return [NSString stringWithFormat:@"the end location %@ is out of the bounds of string length %@", locationEnd, @([(NSAttributedString *)actual length])];
        }
        
        if (locationEnd) {
            return [NSString stringWithFormat:@"expected: %@ at range (%@, %@), got: %@ with %@", attributeValue, locationStart, locationEnd, stringsValue, NSStringFromRange(effectiveRange)];
        } else {
            return [NSString stringWithFormat:@"expected: %@, got: %@", attributeValue, stringsValue];
        }
    });
}
EXPMatcherImplementationEnd
