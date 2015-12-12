//
//  ZSWTaggedStringOptions.swift
//  Pods
//
//  Created by Zachary West on 12/6/15.
//
//

import ZSWTaggedString.Private

extension ZSWTaggedStringOptions {
    public typealias DynamicAttributes = (tagName: String, tagAttributes: [String: AnyObject], existingStringAttributes: [String: AnyObject]) -> [String: AnyObject]
    
    public enum Attributes {
        case Dynamic(DynamicAttributes)
        case Static([String: AnyObject])
        
        init(wrapper: ZSWTaggedStringAttribute) {
            if let dictionary = wrapper.staticDictionary {
                self = .Static(dictionary)
            } else if let block = wrapper.dynamicAttributes {
                self = .Dynamic(block)
            } else {
                fatalError("Not static or dynamic")
            }
        }
        
        var wrapper: ZSWTaggedStringAttribute {
            let wrapper = ZSWTaggedStringAttribute()
            
            switch self {
            case .Dynamic(let attributes):
                wrapper.dynamicAttributes = attributes
            case .Static(let attributes):
                wrapper.staticDictionary = attributes
            }
            
            return wrapper
        }
    }
    
    public var unknownTagAttributes: Attributes? {
        get {
            if let wrapper = unknownTagWrapper {
                return Attributes(wrapper: wrapper)
            } else {
                return nil
            }
        }
        set {
            unknownTagWrapper = newValue?.wrapper
        }
    }
    
    public subscript (tagName: String) -> Attributes? {
        get {
            if let currentValue = tagToAttributesMap[tagName] {
                return Attributes(wrapper: currentValue)
            } else {
                return nil
            }
        }
        set {
            setWrapper(newValue?.wrapper, forTagName: tagName)
        }
    }
    
    
}