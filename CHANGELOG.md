# 2.0

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

**Incompatibility note:** Nullability annotations for `ZSWTaggedString` mark its input as non-null. If you provide a `nil` string to initialize it, it will convert this to `@""` internally, and return `@""` when asked for attributed/unattributed versions.

# 1.1 (2015-06-24)

Fix some cases where escaped strings (e.g. containing <) were not correctly including the start `<`.

# 1.0 (2015-02-22)

Initial release
