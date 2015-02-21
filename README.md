# ZSWTaggedString

[![CI Status](http://img.shields.io/travis/zacwest/ZSWTaggedString.svg?style=flat)](https://travis-ci.org/Zachary West/ZSWTaggedString)
[![Version](https://img.shields.io/cocoapods/v/ZSWTaggedString.svg?style=flat)](http://cocoadocs.org/docsets/ZSWTaggedString)
[![License](https://img.shields.io/cocoapods/l/ZSWTaggedString.svg?style=flat)](http://cocoadocs.org/docsets/ZSWTaggedString)
[![Platform](https://img.shields.io/cocoapods/p/ZSWTaggedString.svg?style=flat)](http://cocoadocs.org/docsets/ZSWTaggedString)

## Usage

ZSWTaggedString converts tagged strings into attributed strings for use in your application. Tagged strings are very roughly HTML strings, except you provide the attributes for what a tag means instead of relying on system-defined rules.

Let's turn part of a string bold but leave the rest untouched:

ZSWTaggedString *string = [ZSWTaggedString stringWithString:@"<b>dogs</b> are cute!"];

ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions options];
[options setAttributes:@{
NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0]
} forTagName:@"b"];

NSAttributedString *attributedString = [taggedString attributedStringWithOptions:options];

This produces an NSAttributedString where the `dogs` substring is bold, and the rest normal weight:

spit out -description of this here

By removing the presentation of these tags from the strings, we can produce wildly-different visual presentations based on the same string generation methods. Merely change the options and your display will adjust.

Let's create a string to display where we localize it, italicize a substring, and color the display names of options we're presenting to the user:

NSString *(^sWrap)(Story *) = ^(Story *story) {
return [NSString stringWithFormat:@"<story type='@d'>%@</story>",
@(story.type), ZSWEscapedStringForString(story.name)];
};

NSString *fmt = NSLocalizedString(@"Pick: %@ <i>or</i> %@", /* ... */);
ZSWTaggedString *string = [ZSWTaggedString stringWithFormat:fmt, sWrap(s1), sWrap(s2)];

For the sake of consistency of representation, I recommend you wrap the `<story>` tag in a creator method or block as I have demonstrated. However, you may include them in the format string without problem.

You can now deliver a this non-confusing localized string without having to resort to `-rangeOfString:` hacks to italicize the localized substring or color the story names.

We can put together the attributed version like so:

ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions options];

[options setBaseAttributes:@{
NSFontAttributeName: [UIFont systemFontOfSize:14.0],
NSForegroundColorAttributeName: [UIColor grayColor]
}];

[options setAttributes:@{
NSFontAttributeName: [UIFont italicSystemFontOfSize:14.0]
} forTagName:@"i"];

[options setDynamicAttributes:^(NSString *tagName, NSString *tagAttributes) {
switch ((StoryType)[tagAttributes[@"type"] integerValue]) {
case StoryTypeOne:
return @{ NSForegroundColorAttributeName: [UIColor redColor] };
case StoryTypeTwo:
return @{ NSForegroundColorAttributeName: [UIColor orangeColor]; };
}
return [UIColor blueColor];
} forTagName:@"story"];

If you do not wish to highlight a color difference between the `story` elements, use a non-dynamic version of the attributes. If suddenly your designer doesn't want the `or` italicized, don't set attributes for the `i` tag.

## Gotchas

If any of your composed strings contain a `<` character without being in a tag, you _must_ wrap the string with `ZSWEscapedStringForString()` before parsing. In practice, I've found that most situations do not call for this and have not figured out an easier way to accomplish this.


## Requirements

## Installation

ZSWTaggedString is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

pod "ZSWTaggedString"

## Author

Zachary West, zacwest@gmail.com

## License

ZSWTaggedString is available under the MIT license. See the LICENSE file for more info.
