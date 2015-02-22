//
//  READMEExamples.m
//  ZSWTaggedString
//
//  Created by Zachary West on 2015-02-22.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

typedef NS_ENUM(NSInteger, StoryType) {
    StoryTypeOne,
    StoryTypeTwo
};

@interface Story : NSObject
@property StoryType type;
@property NSString *name;
@end

@implementation Story
@end

SpecBegin(READMEExamples)

describe(@"READMEExamples", ^{
    it(@"should have bold dogs", ^{
        NSString *localizedString = NSLocalizedString(@"<b>dogs</b> are cute!", nil);
        ZSWTaggedString *taggedString = [ZSWTaggedString stringWithString:localizedString];
        
        ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions options];
        [options setAttributes:@{
                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0]
                                 } forTagName:@"b"];
        
        NSLog(@"%@", [taggedString attributedStringWithOptions:options]);
    });
    
    it(@"should have story types", ^{
        Story *story1 = [[Story alloc] init], *story2 = [[Story alloc] init];
        story1.type = StoryTypeOne; story2.type = StoryTypeTwo;
        story1.name = @"on<e"; story2.name = @"tw<o";
        
        NSString *(^sWrap)(Story *) = ^(Story *story) {
            // You should separate data-level tags from the localized strings
            // so you can iterate on their definition without the .strings changing
            // Ideally you'd place this on the Story class itself.
            return [NSString stringWithFormat:@"<story type='%@'>%@</story>",
                    @(story.type), ZSWEscapedStringForString(story.name)];
        };
        
        NSString *fmt = NSLocalizedString(@"Pick: %@ <i>or</i> %@", @"On the story, ...");
        ZSWTaggedString *string = [ZSWTaggedString stringWithFormat:fmt,
                                   sWrap(story1), sWrap(story2)];
        
        ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions options];
        
        // Base attributes apply to the whole string, before any tag attributes.
        [options setBaseAttributes:@{
                                     NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                     NSForegroundColorAttributeName: [UIColor grayColor]
                                     }];
        
        // Normal attributes just add their attributes to the attributed string.
        [options setAttributes:@{
                                 NSFontAttributeName: [UIFont italicSystemFontOfSize:14.0]
                                 } forTagName:@"i"];
        
        // Dynamic attributes give you an opportunity to decide what to do for each tag
        [options setDynamicAttributes:^(NSString *tagName,
                                        NSDictionary *tagAttributes,
                                        NSDictionary *existingAttributes) {
            switch ((StoryType)[tagAttributes[@"type"] integerValue]) {
                case StoryTypeOne:
                    return @{ NSForegroundColorAttributeName: [UIColor redColor] };
                case StoryTypeTwo:
                    return @{ NSForegroundColorAttributeName: [UIColor orangeColor] };
            }
            return @{ NSForegroundColorAttributeName: [UIColor blueColor] };
        } forTagName:@"story"];
        
        NSLog(@"%@", [string attributedStringWithOptions:options]);
    });
    
    it(@"should make dynamic bold and stuff easier", ^{
        ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions options];
        [options setBaseAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12.0] }];
        
        [options setUnknownTagDynamicAttributes:^(NSString *tagName,
                                                  NSDictionary *tagAttributes,
                                                  NSDictionary *existingStringAttributes) {
            BOOL isBold = [tagName isEqualToString:@"b"];
            BOOL isItalic = [tagName isEqualToString:@"i"];
            BOOL isUnderline = [tagName isEqualToString:@"u"];
            UIFont *font = existingStringAttributes[NSFontAttributeName];
            
            if ((isBold || isItalic) && font) {
                if (isBold) {
                    return @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:font.pointSize] };
                } else if (isItalic) {
                    return @{ NSFontAttributeName: [UIFont italicSystemFontOfSize:font.pointSize] };
                }
            } else if (isUnderline) {
                return @{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
            }
            
            return (NSDictionary *)nil;
        }];
        
        ZSWTaggedString *string = [ZSWTaggedString stringWithString:@"<u>underline</u> <i>italic<u>andunder</u></i> <b>bo<u>l<i>d</i></u></b>"];
        NSLog(@"%@", [string attributedStringWithOptions:options]);
    });
});

SpecEnd
