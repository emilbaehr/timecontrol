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

        if ti >= 60 {
            return super.string(from: ti.rounded())
        }
        
        guard let decimals = numberFormatter?.string(from: NSNumber(value: ti)) else { return .none }
        guard let time = super.string(from: ti.rounded(.down)) else { return .none }
        
        return time + decimals
    }
    
}

// MARK: - Extension on TimeInterval
extension TimeInterval {

    public func stringFromTimeInterval() -> String {
        
        // Use the custom TimeIntervalFormatter.
        let formatter = TimeIntervalFormatter()
        guard let string = formatter.string(from: self) else { return "String couldn't be formatted." }
        
        return string
    }
    
}
