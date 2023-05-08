//
//  ViewController.swift
//  Property Wrappers
//
//  Created by Iftekhar on 4/13/23.
//

import UIKit
import IQPropertyWrapper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let obj2 = Wrap(key1: true, key2: "something", key3: 3.5, key4: 6, key5: false, key6: 20, key7: 5, key8: "")
        print(obj2)

        do {
            let attributes: [String: Any] = [
                "key1": "true",
                "key2": "string",
                "key3": "3.2",
                "key4": "5",
                "key5": "1",
                "key6": 30,
                "key7": NSNull(),
                "key8": NSNull(),
            ]

            let data = try JSONSerialization.data(withJSONObject: attributes)
            let obj = try JSONDecoder().decode(Wrap.self, from: data)
            print(obj)
        } catch {
            print(error)
        }
    }
}

struct Wrap: Codable {
    @BoolValue                          var key1: Bool
    @StringValue                        var key2: String
    @DoubleValue                        var key3: Double
    @IntValue                           var key4: Int
    @BoolValue                          var key5: Bool
    @OptionalIntValue                   var key6: Int?
    @DefaultIntValue(defaultValue: 20)  var key7: Int = 10
    @OptionalStringValue                var key8: String?
}
