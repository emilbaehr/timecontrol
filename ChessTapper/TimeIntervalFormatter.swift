//
//  TimeFormatter.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 12/10/2020.
//

import Foundation

public class TimeIntervalFormatter: DateComponentsFormatter {
    
    public override init() {
        super.init()
        self.unitsStyle = .positional
        self.allowedUnits = [.hour, .minute, .second]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    public override func string(from ti: TimeInterval) -> String? {
//        return super.string(from: ti)
//    }
    
}
