//  Date+Extensions.swift
import Foundation

extension Date {
    func isInPeriod(_ period: TimePeriod) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .today:
            return calendar.isDateInToday(self)
        case .week:
            guard let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) else { return false }
            return self >= weekAgo
        case .month:
            guard let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) else { return false }
            return self >= monthAgo
        case .year:
            guard let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) else { return false }
            return self >= yearAgo
        }
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func formatted(date: DateFormatter.Style, time: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = date
        formatter.timeStyle = time
        return formatter.string(from: self)
    }
}
