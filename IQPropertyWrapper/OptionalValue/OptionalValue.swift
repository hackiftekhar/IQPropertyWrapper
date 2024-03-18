//
//  OptionalValue.swift
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
public struct OptionalValue<T> {

    public var wrappedValue: T?

    public init(wrappedValue value: T?) {
        self.wrappedValue = value
    }
}

extension OptionalValue: Decodable where T: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try? container.decode(T.self)
    }
}

extension OptionalValue: Encodable where T: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }
}

extension OptionalValue: Equatable where T: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension OptionalValue: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension OptionalValue: Comparable where T: Comparable {

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

extension OptionalValue: Sendable where T: Sendable {}

//extension KeyedDecodingContainer {
//    func decode<T>(_ type: OptionalValue<T>.Type, forKey key: K) throws -> OptionalValue<T> where T: ExpressibleByNilLiteral, T: Decodable {
//        if let value = try self.decodeIfPresent(type, forKey: key) {
//            return value
//        }
//
//        return OptionalValue(wrappedValue: nil)
//    }
//}
