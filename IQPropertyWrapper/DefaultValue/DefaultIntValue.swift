//
//  DefaultIntValue.swift
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
public struct DefaultIntValue: Codable, Hashable, Comparable {

    private let defaultValue: Int
    private var originalValue: Int?

    public var wrappedValue: Int {
        get {
            originalValue ?? defaultValue
        } set {
            originalValue = newValue
        }
    }

    public init(wrappedValue value: Int?, defaultValue: Int) {
        self.originalValue = value
        self.defaultValue = defaultValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        defaultValue = 0

        if let value = try? container.decode(Int.self) {
            originalValue = value
        } else if let value = try? container.decode(String.self) {
            if let value = Int(value) {
                originalValue = value
            } else {
                originalValue = nil
            }
        } else if let value = try? container.decode(Bool.self) {
            switch value {
            case false: originalValue = 0
            case true: originalValue = 1
            }
        } else if let value = try? container.decode(Double.self) {
            originalValue = Int(value)
        } else {
            originalValue = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue < rhs.wrappedValue
    }
}
