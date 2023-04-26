//
//  OptionalIntValue.swift
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
public struct OptionalIntValue: Codable, Hashable, Comparable {

    public var wrappedValue: Int?

    public init(wrappedValue value: Int?) {
        self.wrappedValue = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Int.self) {
            wrappedValue = value
        } else if let value = try? container.decode(String.self) {
            if let value = Int(value) {
                wrappedValue = value
            } else {
                wrappedValue = nil
            }
        } else if let value = try? container.decode(Bool.self) {
            switch value {
            case false: wrappedValue = 0
            case true: wrappedValue = 1
            }
        } else if let value = try? container.decode(Double.self) {
            wrappedValue = Int(value)
        } else {
            wrappedValue = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }

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

