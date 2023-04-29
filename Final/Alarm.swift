//
//  Alarm.swift
//  Final
//
//  Created by Luke Briguglio on 4/29/23.
//

import Foundation

struct Alarm {
    var time: Date
    private(set) var timeDifference: String = ""
    var reached: Bool = false
    var turnedOff: Bool = false

    mutating func updateTimeDifference(_ diff: String) {
        timeDifference = diff
    }
}


