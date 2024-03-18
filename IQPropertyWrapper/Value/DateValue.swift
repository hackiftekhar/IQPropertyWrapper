//
//  DateValue.swift
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
public struct DateValue {

    public static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()

    public var wrappedValue: Date

    public init(wrappedValue value: Date) {
        self.wrappedValue = value
    }
}

extension DateValue: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

       if let value = try? container.decode(String.self) {
            if let value = Self.dateFormatter.date(from: value) {
                wrappedValue = value
            } else if let value = TimeInterval(value) {
                wrappedValue = Date(timeIntervalSince1970: value)
            } else if let value = Int(value) {
                wrappedValue = Date(timeIntervalSince1970: TimeInterval(value))
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expect date value but found `\(value)` instead")
            }
        } else if let value = try? container.decode(Double.self) {
            wrappedValue = Date(timeIntervalSince1970: value)
        } else if let value = try? container.decode(Int.self) {
            wrappedValue = Date(timeIntervalSince1970: TimeInterval(value))
        } else {
            wrappedValue = try container.decode(Date.self)
        }
    }
}

extension DateValue: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }
}

extension DateValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension DateValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension DateValue: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue < rhs.wrappedValue
    }
}

extension DateValue: Sendable {}
