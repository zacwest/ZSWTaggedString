# 4.1 (2019-01-26)

Update to Swift 4.2.

# 4.0 (2017-10-16)

Update to Swift 4.

# 3.0 (2017-01-21)

Update to Swift 3.

# 2.0 (2015-12-13)

Swift support! You will need to add the `ZSWTaggedString/Swift` dependency for this. This provides a cleaner API for setting attributes for tags, for example:

```swift
options["a"] = .Static([
    NSForegroundColorAttributeName: UIColor.whiteColor()
])

options["b"] = .Dynamic({ tagName, tagAttributes, existingAttributes in
    if tagAttributes["white"] != nil {
        return [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
    } else {
        return [
            NSForegroundColorAttributeName: UIColor.redColor()
        ]
    }
})
```

This release also fixes `ZSWTaggedString` initialization methods `init(string:)` and `init(format:...)` under Swift.

**Incompatibility notes:** 

- `ZSWTaggedString` no longer accepts `nil` input; it will convert any `nil` input into `@""`.
- `ZSWTaggedStringOptions.returnEmptyStringForNil` flag has been removed.

# 1.1 (2015-06-24)

Fix some cases where escaped strings (e.g. containing <) were not correctly including the start `<`.

# 1.0 (2015-02-22)

Initial release
