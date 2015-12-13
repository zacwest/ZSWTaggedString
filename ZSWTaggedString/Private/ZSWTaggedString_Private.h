//
//  ZSWTaggedString_Private.h
//  Pods
//
//  Created by Zachary West on 12/12/15.
//
//

NS_ASSUME_NONNULL_BEGIN

@interface ZSWTaggedString()
@property (nonatomic, copy) NSString *underlyingString;
@end

@interface ZSWTaggedStringOptions()
+ (ZSWTaggedStringOptions *)defaultOptionsNoCopy;

- (void)setWrapper:(nullable ZSWTaggedStringAttribute *)attribute forTagName:(NSString *)tagName;

@property (nullable, nonatomic) ZSWTaggedStringAttribute *unknownTagWrapper;
@property (nonatomic) NSDictionary<NSString *, ZSWTaggedStringAttribute *> *tagToAttributesMap;
- (void)updateAttributedString:(NSMutableAttributedString *)string
               updatedWithTags:(NSArray *)tags;
@end

NS_ASSUME_NONNULL_END
