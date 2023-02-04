//
//  DateToString.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/3/23.
//

import Foundation

extension Date {
    // amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    // amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    // amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    // amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    // amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    // amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    // amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    // custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date) == 1 { return "\(years(from: date)) year ago" }
        if years(from: date) > 0 { return "\(years(from: date)) years ago" }
        if months(from: date) == 1 { return "\(months(from: date)) month ago" }
        if months(from: date) > 0 { return "\(months(from: date)) months ago" }
        if weeks(from: date) == 1 { return "\(weeks(from: date)) week ago" }
        if weeks(from: date) > 0 { return "\(weeks(from: date)) weeks ago" }
        if days(from: date) == 1 { return "\(days(from: date)) day ago" }
        if days(from: date) > 0 { return "\(days(from: date)) days ago" }
        if hours(from: date) == 1 { return "\(hours(from: date)) hour ago" }
        if hours(from: date) > 0 { return "\(hours(from: date)) hours ago" }
        if minutes(from: date) == 1 { return "\(minutes(from: date)) minute ago" }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) minutes ago" }
        if seconds(from: date) == 1 { return "\(seconds(from: date)) second ago" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) seconds ago" }
        return ""
    }
}
