//
//  ZSWTaggedStringOptions.swift
//  Pods
//
//  Created by Zachary West on 12/6/15.
//
//

import ZSWTaggedString.Private

extension ZSWTaggedStringOptions {
    public enum Attributes {
        case Dynamic(ZSWDynamicAttributes)
        case Static([String: AnyObject])
    }
    
    public subscript (tagName: String) -> Attributes? {
        get {
            if let currentValue = tagToAttributesMap[tagName] {
                if let dictionary = currentValue.staticDictionary {
                    return .Static(dictionary)
                } else if let block = currentValue.dynamicAttributes {
                    return .Dynamic(block)
                }
            }
            
            return nil
        }
        set {
            if let newValue = newValue {
                let wrapper = ZSWTaggedStringAttribute()
                
                switch newValue {
                case .Dynamic(let attributes):
                    wrapper.dynamicAttributes = attributes
                case .Static(let attributes):
                    wrapper.staticDictionary = attributes
                }
                
                setWrapper(wrapper, forTagName: tagName)
            } else {
                setWrapper(nil, forTagName: tagName)
            }
        }
    }
    
    
}