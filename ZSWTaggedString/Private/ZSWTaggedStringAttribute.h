//
//  ZSWTaggedStringAttribute.h
//  Pods
//
//  Created by Zachary West on 12/6/15.
//
//

#import <ZSWTaggedString/ZSWTaggedString.h>

@interface ZSWTaggedStringAttribute: NSObject <NSCopying>
@property (nonatomic, copy) NSDictionary<NSString *, id> *staticDictionary;
@property (nonatomic, copy) ZSWDynamicAttributes dynamicAttributes;
@end
