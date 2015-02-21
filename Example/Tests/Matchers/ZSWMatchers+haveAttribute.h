//
//  ZSWMatchers+haveAttribute.h
//  ZSWStringParser
//
//  Created by Zachary West on 2015-02-21.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

#import "Expecta.h"

EXPMatcherInterface(_haveAttributeWithEnd, (id attributeName, id attributeValue, id locationStart, id locationEnd));
EXPMatcherInterface(haveAttributeWithEnd, (id attributeName, id attributeValue, id locationEnd, id locationStart));

#define haveAttribute(attributeName, attributeValue, locationStart) _haveAttributeWithEnd(attributeName, attributeValue, EXPObjectify(locationStart), nil)
#define haveAttributeWithEnd(attributeName, attributeValue, locationStart, locationEnd) _haveAttributeWithEnd(attributeName, attributeValue, EXPObjectify(locationStart), EXPObjectify(locationEnd))
