//
//  ZSWStringParserTag.m
//  Pods
//
//  Created by Zachary West on 2015-02-21.
//
//

#import "ZSWStringParserTag.h"

@interface ZSWStringParserTag()
@property (nonatomic, readwrite) NSString *tagName;
@property (nonatomic, readwrite) NSInteger location;
@property (nonatomic) NSInteger endLocation;

@property (nonatomic) NSDictionary *tagAttributes;
@end

@implementation ZSWStringParserTag

- (instancetype)initWithTagName:(NSString *)tagName
                  startLocation:(NSInteger)location {
    self = [super init];
    if (self) {
        self.tagName = tagName;
        self.location = location;
    }
    return self;
}

- (BOOL)isEndingTag {
    return [self.tagName hasPrefix:@"/"];
}

- (BOOL)isEndedByTag:(ZSWStringParserTag *)tag {
    if (!tag.isEndingTag) {
        return NO;
    }
    
    if (![[tag.tagName substringFromIndex:1] isEqualToString:self.tagName]) {
        return NO;
    }
    
    return YES;
}

- (void)updateWithTag:(ZSWStringParserTag *)tag {
    NSAssert([self isEndedByTag:tag], @"Didn't check before updating tag");
    self.endLocation = tag.location;
}

- (NSRange)tagRange {
    return NSMakeRange(self.location, self.endLocation - self.location);
}

- (void)addRawTagAttributes:(NSString *)tagAttributes {
    
}



@end
