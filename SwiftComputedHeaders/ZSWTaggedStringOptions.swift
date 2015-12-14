
public class ZSWTaggedStringOptions : NSObject, NSCopying {
    
    /*!
     * @brief Register a set of default options
     *
     * A copy of the options provided is used as the default options. If you wish to make changes after registration,
     * you must re-register.
     */
    public class func registerDefaultOptions(options: ZSWTaggedStringOptions)
    public class func defaultOptions() -> ZSWTaggedStringOptions
    
    public init(baseAttributes attributes: [String : AnyObject])
    
    public var baseAttributes: [String : AnyObject]
}

extension ZSWTaggedStringOptions {
    /**
     Dynamic attributes executed for a tag
     
     Below parameters are for an example tag of:
     
     `<a href="http://google.com">`
     
     - Parameter tagName: This would be `"a"` in the example.
     - Parameter tagAttributes: This would be `["href": "http://google.com"]` in the example.
     - Parameter existingStringAttributes: The attributes for the generated attributed string at the given tag start location before applying the given attributes.
     
     - Returns: The `NSAttributedString` attributes you wish to be applied for the tag.
     
     */
    public typealias DynamicAttributes = (tagName: String, tagAttributes: [String : AnyObject], existingStringAttributes: [String : AnyObject]) -> [String : AnyObject]
    /**
     Attributes to be applied to an attributed string.
     
     - Dynamic: Takes input about the tag to generate values.
     - Static: Always returns the same attributes.
     */
    public enum Attributes {
        case Dynamic(ZSWTaggedStringOptions.DynamicAttributes)
        case Static([String : AnyObject])
    }
    /**
     Attributes to be applied for an unknown tag.
     
     For example, if you do not specify attributes for the tag `"a"` and your
     string contains it, these attributes would be invoked for it.
     */
    public var unknownTagAttributes: ZSWTaggedStringOptions.Attributes?
    public subscript (tagName: String) -> ZSWTaggedStringOptions.Attributes?
}
