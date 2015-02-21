//
//  ZSWStringParser.h
//  Pods
//
//  Created by Zachary West on 2015-02-21.
//
//

/*!
 * @private
 */

#import "ZSWTaggedString.h"
#import "ZSWTaggedStringOptions.h"

#define ZSWSelector(selectorName) (NSStringFromSelector(@selector(selectorName)))

@interface ZSWStringParser : NSObject

+ (id)stringWithTaggedString:(ZSWTaggedString *)taggedString
                     options:(ZSWTaggedStringOptions *)options
                 returnClass:(Class)returnClass;

@end

@interface ZSWTaggedString()
@property (nonatomic) NSString *underlyingString;
@end

@interface ZSWTaggedStringOptions (Private)
- (void)updateAttributedString:(NSMutableAttributedString *)string
               updatedWithTags:(NSArray *)tags;
@end
