//
//  ZSWTaggedStringAttribute.m
//  Pods
//
//  Created by Zachary West on 12/6/15.
//
//

#import <ZSWTaggedString/ZSWTaggedStringAttribute.h>
#import <ZSWTaggedString/ZSWStringParserTag.h>

@implementation ZSWTaggedStringAttribute
@synthesize staticDictionary = _staticDictionary;
@synthesize dynamicAttributes = _dynamicAttributes;

- (id)copyWithZone:(NSZone *)zone {
    ZSWTaggedStringAttribute *attribute = [[[self class] alloc] init];
    attribute->_staticDictionary = _staticDictionary;
    attribute->_dynamicAttributes = _dynamicAttributes;
    return attribute;
}

- (NSDictionary<NSString *, id> *)attributesForTag:(ZSWStringParserTag *)tag forString:(NSAttributedString *)string {
    if (self.staticDictionary) {
        return self.staticDictionary;
    }
    
    if (self.dynamicAttributes) {
        NSDictionary *existingAttributes = [string attributesAtIndex:tag.location effectiveRange:NULL];
        return self.dynamicAttributes(tag.tagName, tag.tagAttributes, existingAttributes);
    }
    
    return @{};
}

@end
