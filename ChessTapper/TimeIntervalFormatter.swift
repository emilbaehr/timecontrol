//
//  TimeFormatter.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 12/10/2020.
//

import Foundation

public class TimeIntervalFormatter: DateComponentsFormatter {
    
    private var numberFormatter: NumberFormatter?
    
    public override init() {
        super.init()
        self.unitsStyle = .positional
        self.allowedUnits = [.hour, .minute, .second]
        self.zeroFormattingBehavior = [.dropLeading, .pad]
        
        self.numberFormatter = NumberFormatter()
        self.numberFormatter?.minimumFractionDigits = 0
        self.numberFormatter?.maximumFractionDigits = 2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func string(from ti: TimeInterval) -> String? {
        
        let seconds = ti / 60 / 60
        let milliseconds = numberFormatter?.string(from: NSNumber(value: seconds))
        
        return super.string(from: ti.rounded(.up))
//        return super.string(from: ti)! + Locale.current.decimalSeparator! + milliseconds!
    }
    
}
