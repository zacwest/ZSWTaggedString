//
//  ZSWTaggedStringOptions.m
//  Pods
//
//  Created by Zachary West on 2015-02-21.
//
//

#import <ZSWTaggedString/ZSWTaggedStringOptions.h>
#import <ZSWTaggedString/ZSWStringParser.h>
#import <ZSWTaggedString/ZSWStringParserTag.h>

@implementation ZSWTaggedStringOptions

static ZSWTaggedStringOptions *ZSWStringParserDefaultOptions;

+ (ZSWTaggedStringOptions *)defaultOptions {
    return [[self defaultOptionsNoCopy] copy];
}

+ (ZSWTaggedStringOptions *)defaultOptionsNoCopy {
    ZSWTaggedStringOptions *options;
    
    @synchronized (self) {
        if (!ZSWStringParserDefaultOptions) {
            ZSWStringParserDefaultOptions = [ZSWTaggedStringOptions options];
        }
        
        options = ZSWStringParserDefaultOptions;
    }
    
    return options;
}

+ (void)registerDefaultOptions:(ZSWTaggedStringOptions *)options {
    @synchronized(self) {
        ZSWStringParserDefaultOptions = [options copy];
    }
}

- (void)commonInit {
    
}

+ (ZSWTaggedStringOptions *)options {
    return [[[self class] alloc] init];
}

+ (ZSWTaggedStringOptions *)optionsWithBaseAttributes:(NSDictionary *)attributes {
    ZSWTaggedStringOptions *options = [[[self class] alloc] initWithBaseAttributes:attributes];
    return options;
}

- (instancetype)init {
    return [self initWithBaseAttributes:@{}];
}

- (instancetype)initWithBaseAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        [self commonInit];
        
        self.baseAttributes = attributes ?: [NSDictionary dictionary];
        self.tagToAttributesMap = [NSDictionary dictionary];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    ZSWTaggedStringOptions *options = [[[self class] allocWithZone:zone] init];
    options->_baseAttributes = self->_baseAttributes;
    options->_tagToAttributesMap = self->_tagToAttributesMap;
    options->_unknownTagWrapper = self->_unknownTagWrapper;
    return options;
}

- (BOOL)isEqual:(ZSWTaggedStringOptions *)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (![object.baseAttributes isEqualToDictionary:self.baseAttributes]) {
        return NO;
    }
    
    if (![object.tagToAttributesMap isEqualToDictionary:self.tagToAttributesMap]) {
        return NO;
    }
    
    if (![object.unknownTagWrapper isEqual:self.unknownTagWrapper]) {
        return NO;
    }
    
    return YES;
}

- (NSUInteger)hash {
    return self.baseAttributes.hash + self.tagToAttributesMap.hash;
}

#pragma mark -

- (void)setWrapper:(ZSWTaggedStringAttribute *)attribute forTagName:(NSString *)tagName {
    NSMutableDictionary *mutableMap = [self.tagToAttributesMap mutableCopy];
    mutableMap[tagName.lowercaseString] = [attribute copy];
    self.tagToAttributesMap = mutableMap;
}

- (void)setAttributes:(NSDictionary<NSString *,id> *)dict forTagName:(NSString *)tagName {
    NSParameterAssert(tagName.length > 0);
    
    ZSWTaggedStringAttribute *attribute = [[ZSWTaggedStringAttribute alloc] init];
    attribute.staticDictionary = dict;
    
    [self setWrapper:attribute forTagName:tagName];
}

- (void)setDynamicAttributes:(ZSWDynamicAttributes)dynamicAttributes forTagName:(NSString *)tagName {
    NSParameterAssert(tagName != nil);
    ZSWTaggedStringAttribute *attribute = [[ZSWTaggedStringAttribute alloc] init];
    attribute.dynamicAttributes = dynamicAttributes;
    [self setWrapper:attribute forTagName:tagName];
}

- (void)setUnknownTagDynamicAttributes:(ZSWDynamicAttributes)unknownTagDynamicAttributes {
    ZSWTaggedStringAttribute *attribute = [[ZSWTaggedStringAttribute alloc] init];
    attribute.dynamicAttributes = unknownTagDynamicAttributes;
    self.unknownTagWrapper = attribute;
}

- (ZSWDynamicAttributes)unknownTagDynamicAttributes {
    return self.unknownTagWrapper.dynamicAttributes;
}

#pragma mark - Internal/updating
- (void)updateAttributedString:(NSMutableAttributedString *)string
               updatedWithTags:(NSArray *)tags {
    NSParameterAssert([string isKindOfClass:[NSMutableAttributedString class]]);
    
    [string setAttributes:self.baseAttributes range:NSMakeRange(0, string.length)];
    
    ZSWTaggedStringAttribute *unknownTagWrapper = self.unknownTagWrapper;
    
    for (ZSWStringParserTag *tag in tags) {
        ZSWTaggedStringAttribute *tagValue = self.tagToAttributesMap[tag.tagName.lowercaseString];
        NSDictionary<NSString *, id> *attributes = nil;
        
        if (tagValue) {
            attributes = [tagValue attributesForTag:tag forString:string];
        } else if (unknownTagWrapper) {
            attributes = [unknownTagWrapper attributesForTag:tag forString:string];
        }
        
        if (attributes) {
            [string addAttributes:attributes range:tag.tagRange];
        }
    }
}

@end
