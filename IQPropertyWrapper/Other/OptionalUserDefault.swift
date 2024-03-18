//
//  OptionalUserDefault.swift
// https://github.com/hackiftekhar/IQPropertyWrapper
// Created by Iftekhar
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

@propertyWrapper
public struct OptionalUserDefault<T: Codable> {

    public let key: String
    public var userDefaults: UserDefaults = UserDefaults.standard
    public var wrappedValue: T? {
        get {
            userDefaults.value(forKey: key) as? T
        } set {
            if let newValue = newValue {
                userDefaults.set(newValue, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
            userDefaults.synchronize()
        }
    }
}

extension OptionalUserDefault: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }
}

extension OptionalUserDefault: Equatable where T: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension OptionalUserDefault: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension OptionalUserDefault: Comparable where T: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if let lhs = lhs.wrappedValue, let rhs = rhs.wrappedValue {
            return lhs < rhs
        } else if lhs.wrappedValue != nil {
            return true
        } else if rhs.wrappedValue != nil {
            return false
        } else {
            return false
        }
    }
}

extension OptionalUserDefault: Sendable where T: Sendable {}
