//
//  All + Ext.swift
//  WeatherApp-UIKit
//
//  Created by Anwesh on 3/30/23.
//

import UIKit


extension UILabel{
    
    static var autoLayoutLabel: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = nil
        label.textColor = .label
        return label
    }
}

extension UIImageView{
    
    static var autoLayoutImageView: UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

extension UIView{
    
    static var autoLayoutView: UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension UIColor {
    static var color1: UIColor = UIColor(named: "Color1")!
}

extension UISearchBar {
    func setColor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
    }
}

extension UIStackView{
    static var autoLayoutStackView: UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension Data {
    
    func printJson() {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                print("Inavlid data")
                return
            }
            print(jsonString)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension Date{
    
    func dateDescription() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "MMM d, h:mm a"
        let time = formatter.string(from: self)
        return time
    }
    
    func getDayOfWeekString()->String{
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: self)
        let weekDay = myComponents.weekday
        switch weekDay {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            print("Error fetching days")
            return "Day"
        }
        
    }
    
    func getTimeinAmPm() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "hh:mm a"
        let time12 = formatter.string(from: self)
        return time12
    }
    
    func getDate() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "d MMM"
        let time12 = formatter.string(from: self)
        return time12
    }
    
    
    func isDateInToday() -> Bool{
        Calendar.current.isDateInToday(self)
    }
    
}

extension String{
    
    func toDate() -> Date?{
        let  df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: self)
        return date
    }
    
}

extension UIView {
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
