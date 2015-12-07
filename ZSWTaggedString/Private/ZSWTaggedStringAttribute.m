//
//  ZSWTaggedStringAttribute.m
//  Pods
//
//  Created by Zachary West on 12/6/15.
//
//

#import "ZSWTaggedStringAttribute.h"

@implementation ZSWTaggedStringAttribute
@synthesize staticDictionary = _staticDictionary;
@synthesize dynamicAttributes = _dynamicAttributes;

- (id)copyWithZone:(NSZone *)zone {
    ZSWTaggedStringAttribute *attribute = [[[self class] alloc] init];
    attribute->_staticDictionary = _staticDictionary;
    attribute->_dynamicAttributes = _dynamicAttributes;
    return attribute;
}

@end
