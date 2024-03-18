//
//  DefaultDateValue.swift
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
public struct DefaultDateValue {

    public static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()

    private let defaultValue: Date?
    private var originalValue: Date?

    enum CodingKeys: CodingKey {
        case wrappedValue
    }

    public var wrappedValue: Date? {
        get {
            originalValue ?? defaultValue
        } set {
            originalValue = newValue
        }
    }

    public init(wrappedValue value: Date?, defaultValue: Date?) {
        self.originalValue = value
        self.defaultValue = defaultValue
    }
}

extension DefaultDateValue: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        defaultValue = nil

        if let value = try? container.decode(String.self) {
            if let value = Self.dateFormatter.date(from: value) {
                originalValue = value
            } else if let value = TimeInterval(value) {
                originalValue = Date(timeIntervalSince1970: value)
            } else if let value = Int(value) {
                originalValue = Date(timeIntervalSince1970: TimeInterval(value))
            } else {
                originalValue = nil
            }
        } else if let value = try? container.decode(Double.self) {
            originalValue = Date(timeIntervalSince1970: value)
        } else if let value = try? container.decode(Int.self) {
            originalValue = Date(timeIntervalSince1970: TimeInterval(value))
        } else {
            originalValue = nil
        }
    }
}

extension DefaultDateValue: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }
}

extension DefaultDateValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension DefaultDateValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension DefaultDateValue: Comparable {
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

extension DefaultDateValue: Sendable {}
