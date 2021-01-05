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
        self.numberFormatter?.maximumIntegerDigits = 0
        self.numberFormatter?.minimumFractionDigits = 2
        self.numberFormatter?.maximumFractionDigits = 1
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func string(from ti: TimeInterval) -> String? {

        if ti > 59 {
            return super.string(from: ti.rounded())
        }
        
        guard let decimals = numberFormatter?.string(from: NSNumber(value: ti)) else { return .none }
        guard let time = super.string(from: ti.rounded()) else { return .none }
        
        return time + decimals
    }
    
}
