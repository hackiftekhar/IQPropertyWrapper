//
//  StringValue.swift
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
public struct StringValue {

    public var wrappedValue: String

    public init(wrappedValue value: String) {
        self.wrappedValue = value
    }
}

extension StringValue: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(String.self) {
            wrappedValue = value
        } else if let value = try? container.decode(Int.self) {
            wrappedValue = "\(value)"
        } else if let value = try? container.decode(Bool.self) {
            switch value {
            case false: wrappedValue = "false"
            case true: wrappedValue = "true"
            }
        } else if let value = try? container.decode(Double.self) {
            wrappedValue = "\(value)"
        } else {
            wrappedValue = try container.decode(String.self)
        }
    }
}

extension StringValue: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }
}

extension StringValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension StringValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension StringValue: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue < rhs.wrappedValue
    }
}

extension StringValue: Sendable {}
