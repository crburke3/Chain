//
//  ChristiansLibrary.swift
//  MarketPlaceMedium
//
//  Created by Christian Burke on 2/6/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Kingfisher
import PopupDialog
import Pastel

extension MKPlacemark{
    func parseAddress() -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (self.subThoroughfare != nil && self.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (self.subThoroughfare != nil || self.thoroughfare != nil) && (self.subAdministrativeArea != nil || self.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (self.subAdministrativeArea != nil && self.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            self.subThoroughfare ?? "",
            firstSpace,
            // street name
            self.thoroughfare ?? "",
            comma,
            // city
            self.locality ?? "",
            secondSpace,
            // state
            self.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension UITableViewCell{
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func firstIndex(of word:String)->Int?{
        var wordStart = 0
        for letter in self{
            if letter == word.first!{
                
                
                var checkCount = wordStart
                for i in word{
                    if i != self[checkCount]{
                        break
                    }
                    checkCount += 1
                }
                if (checkCount - wordStart) >= word.count - 1{
                    return wordStart
                }
                
                
            }
            wordStart += 1
        }
        return nil
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}
extension Substring {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}

extension UIImage{
    func resized(sizeChange:CGSize)-> UIImage{
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}

extension UIImageView {
    
    func rotate(radians: CGFloat, animated:Bool = false) {
        if animated{
            UIView.animate(withDuration: 0.2) {
                self.transform =  CGAffineTransform(rotationAngle: radians)
            }
        }else{
            self.transform =  CGAffineTransform(rotationAngle: radians)
        }
        // If you like to use layer you can uncomment the following line
        //layer.transform = CATransform3DMakeRotation(degreesToRadians(degrees), 0.0, 0.0, 1.0)
    }
    
    func rotate(degrees: CGFloat) {

        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
        // If you like to use layer you can uncomment the following line
        //layer.transform = CATransform3DMakeRotation(degreesToRadians(degrees), 0.0, 0.0, 1.0)
    }
    
    
    func addEdgeBlur(inset:CGFloat = 5.0, cornerRadius:CGFloat = 10.0, color:UIColor){
        let maskLayer = CAGradientLayer()
        maskLayer.frame = self.bounds
        maskLayer.shadowRadius = 5
        maskLayer.shadowPath = CGPath(roundedRect: self.bounds.insetBy(dx: inset, dy: inset), cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = color.cgColor
        self.layer.mask = maskLayer;
    }
    
    func downloaded(from url: URL) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        for view in self.superview!.subviews{
            if(view is UIActivityIndicatorView){
                if self.frame.contains(view.frame){
                    let spinner: UIActivityIndicatorView = view as! UIActivityIndicatorView
                    spinner.startAnimating()
                }
            }
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    if let safeImage = UIImage(named: "Qmark"){
                        DispatchQueue.main.async {
                            self.image = safeImage
                        }
                    }
                    return
                    }
            DispatchQueue.main.async() {
                if(self.superview != nil){
                    for view in self.superview!.subviews{
                        if self.frame.contains(view.frame){
                            if(view is UIActivityIndicatorView){
                                let spinner: UIActivityIndicatorView = view as! UIActivityIndicatorView
                                spinner.stopAnimating()
                            }
                        }
                    }
                }
                self.image = image
            }
            }.resume()
    }
    
    func downloaded(from link: String) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
    

    func downloadWithHolder(_url:String, _placeholder:UIImage){
        if let realURL = URL(string: _url){
            kf.setImage(with: realURL, placeholder: _placeholder, options: nil, progressBlock: nil) { (image, error, cacheType, imageUrl) in
                if error == nil{
                    self.stopSpinner()
                }else if error != nil{
                    self.stopSpinner()
                }
            }
        }
    }
    
    private func stopSpinner(){
        if(self.superview != nil){
            for view in self.superview!.subviews{
                if(view is UIActivityIndicatorView){
                    let spinner: UIActivityIndicatorView = view as! UIActivityIndicatorView
                    spinner.stopAnimating()
                }
            }
        }
    }
    
}


extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

class roundLabel:UILabel{
    @IBInspectable var cornerRadius: Int = 0 {
        didSet{
            layer.masksToBounds = true
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: Int = 0 {
        didSet{
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var underlineWidth: Int = 0 {
        didSet{
            if let textString = self.text {
                let attributedString = NSMutableAttributedString(string: textString)
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: underlineWidth, range: NSRange(location: 0, length: attributedString.length))
                attributedText = attributedString
            }
        }
    }
    
    @IBInspectable var label_Rotation: Double = 0 {
        didSet {
            rotateLabel(labelRotation: label_Rotation)
            self.layoutIfNeeded()
        }
    }
    
    func rotateLabel(labelRotation: Double)  {
        self.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi * 2) + labelRotation))
    }
}

class RoundView:UIView{
     
    @IBInspectable var addShadow: Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.addShadow{
            self.addShadow()
        }
    }
    
    @IBInspectable var cornerRadius: Int = 0 {
        didSet{
            layer.masksToBounds = true
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }

    @IBInspectable var borderWidth: Int = 0 {
        didSet{
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }

    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        if (self.isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
    
    
    func addShadow(offset: CGSize = CGSize.init(width: 0, height: 3), color: UIColor = UIColor.black, radius: CGFloat = 4.0, opacity: Float = 0.35) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func addGradient(colorScheme:GradientColorScheme){
        let pastelView = PastelView(frame: self.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3.0
        pastelView.setColors(colorScheme.colors)
        pastelView.startAnimation()
        self.insertSubview(pastelView, at: 0)
    }
}

enum GradientColorScheme:String{
    case ChainOriginal
    
    var colors:[UIColor]{
        get{
            return [UIColor.Chain.mainBlue, UIColor.Chain.mainOrange]
        }
    }
}

class BorderTextView:UITextView{
    @IBInspectable var borderWidth: Int = 0 {
        didSet{
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
}

@IBDesignable class RoundButton: UIButton{
    
    private var spinner:UIActivityIndicatorView?
    private var previousTitle:String?
    
    func startSpinner(){
        if spinner == nil{
            spinner = UIActivityIndicatorView(style: .white)
            spinner!.hidesWhenStopped = true
            self.addSubview(spinner!)
            spinner!.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
            spinner!.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
            spinner!.translatesAutoresizingMaskIntoConstraints = false
        }
        spinner!.startAnimating()
        self.setInactive()
        self.previousTitle = self.titleLabel?.text
        self.setTitle(nil, for: .normal)
    }
    
    func stopSpinner(){
        spinner?.stopAnimating()
        self.setTitle(previousTitle, for: .normal)
        self.setActive()
    }
    
    @IBInspectable var cornerRadius: Int = 0 {
        didSet{
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: Int = 0 {
        didSet{
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var underline: Bool = false {
        didSet{
            
            let attrs = [
                //NSAttributedString.Key.font : titleLabel?.font,
                //NSAttributedString.Key.foregroundColor : UIColor.red,
                NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
            
            let attributedString = NSMutableAttributedString(string:"")
            let buttonTitleStr = NSMutableAttributedString(string:(self.titleLabel?.text)!, attributes:attrs)
            attributedString.append(buttonTitleStr)
            setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    //---------------GRADIENT-------------------------
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        if (self.isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
}

@IBDesignable class RoundImageView: UIImageView{
    
    @IBInspectable var cornerRadius: Int = 0 {
        didSet{
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: Int = 0 {
        didSet{
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var blurImage: Bool = false{
        didSet{
            if blurImage{
                updateImage()
            }
        }
    }
    
    func updateImage(){
        if self.image != nil{
            let contentMode = self.contentMode
            let imageToBlur:CIImage = CIImage(image: self.image!)!
            let blurFilter:CIFilter = CIFilter(name: "CIGaussianBlur")!
            blurFilter.setValue(imageToBlur, forKey: "inputImage")
            let resultImage:CIImage = blurFilter.value(forKey: "outputImage")! as! CIImage
            self.image = UIImage(ciImage: resultImage)
            self.contentMode = contentMode
        }
    }
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}


extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}

extension UIButton{
    func setInactive(){
        self.isUserInteractionEnabled = false
        if self.backgroundColor != nil{
            self.backgroundColor = self.backgroundColor!.withAlphaComponent(0.3)
        }
    }
    
    func setActive(){
        self.isUserInteractionEnabled = true
        if self.backgroundColor != nil{
            self.backgroundColor = self.backgroundColor!.withAlphaComponent(1.0)
        }
    }
}

extension MKMapView{
    func centerMapOnLocation(location: CLLocation, regionRadius:Double = 500.0) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.setRegion(coordinateRegion, animated: true)
    }

}

extension UINavigationController{
    func popToViewController(_identifier:String) -> Bool{
        for controller in self.viewControllers as Array {
            if let restoreID = controller.restorationIdentifier{
                if restoreID.contains(find: _identifier){
                    self.popToViewController(controller, animated: true)
                    return true
                    break
                }
            }
        }
        return false
    }
}

extension UIColor{
    struct Brakez {
        static var mainBlue: UIColor  { return UIColor(red: 52/255, green: 96/255, blue: 184/255, alpha: 1) }
        static var disableBlue: UIColor  { return UIColor(red: 52/255, green: 96/255, blue: 184/255, alpha: 0.5) }
        static var errorRed: UIColor  { return UIColor(red: 255/255, green: 76/255, blue: 84/255, alpha: 1) }
    }
    
    struct marketplace {
        static var mainBlue: UIColor  { return UIColor(red: 122/255, green: 163/255, blue: 1, alpha: 1) }
        static var errorRed: UIColor  { return UIColor(red: 255/255, green: 76/255, blue: 84/255, alpha: 1) }
    }
    
    struct FlexForum{
        static var backgroundGrey: UIColor  { return UIColor(red: 48/255, green: 56/255, blue: 66/255, alpha: 1) }
        static var flexRed: UIColor  { return UIColor(red: 216/255, green: 112/255, blue: 53/255, alpha: 1) }
        static var errorRed: UIColor  { return UIColor(red: 255/255, green: 76/255, blue: 84/255, alpha: 1) }
        static var navOrange: UIColor  { return UIColor(red: 232/255, green: 121/255, blue: 58/255, alpha: 1) }
    }
    
    struct InstaLayer{
        static var backgroundGrey: UIColor  { return UIColor(red: 48/255, green: 56/255, blue: 66/255, alpha: 1) }
        static var flexRed: UIColor  { return UIColor(red: 216/255, green: 112/255, blue: 53/255, alpha: 1) }
        static var errorRed: UIColor  { return UIColor(red: 255/255, green: 76/255, blue: 84/255, alpha: 1) }
        static var navOrange: UIColor  { return UIColor(red: 232/255, green: 121/255, blue: 58/255, alpha: 1) }
    }
    
    struct Chain{
        static var mainOrange: UIColor  { return UIColor(red: 240/255, green: 106/255, blue: 93/225, alpha: 1) }
        static var mainBlue: UIColor  { return UIColor(red: 0/255, green: 174/255, blue: 239/255, alpha: 1) }
        static var lightTan: UIColor  { return UIColor(red: 239/255, green: 242/255, blue: 220/255, alpha: 1) }
        static var mediumBlue: UIColor  { return UIColor(red: 80/255, green: 99/255, blue: 101/255, alpha: 1) }
        static var lightBlue: UIColor  { return UIColor(red: 126/255, green: 157/255, blue: 157/255, alpha: 1) }

    }
}

extension UIViewController{
    func showPopUp(_title:String, _message:String){
        let title = _title
        let message = _message
        let popup = PopupDialog(title: title, message: message)
        
        let buttonOne = CancelButton(title: "okay") {
            print("You canceled the car dialog.")
        }
        popup.addButtons([buttonOne])
        self.present(popup, animated: true, completion: nil)
    }
}

extension UIView {
    
    func fadeIn(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
                        if let complete = onCompletion { complete() }
        }
        )
    }
    
    func fadeOut(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 0 },
                       completion: { (value: Bool) in
                        self.isHidden = true
                        if let complete = onCompletion { complete() }
                        
        }
        )
    }
    
}


extension UISearchBar{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        self.resignFirstResponder()
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension Dictionary{
    static func fromJson(text: String)->[String:Any]?{
        if let data = text.data(using: .utf8) {
            do {
                let dict =  try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                return dict
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
}

extension UINavigationController{
    func findViewController(with className: String)->Any?{
        for viewcontroller in self.viewControllers{
            var vcName = String(describing: viewcontroller)
            vcName = String(vcName.split(separator: ".")[1])
            vcName = String(vcName.split(separator: ":")[0])
            if vcName == className{
                return viewcontroller
            }
        }
        return nil
    }
}

extension Double{
    func formatted(_ decimalPlaces: Int?) -> String {
       let theDecimalPlaces : Int
       if decimalPlaces != nil {
          theDecimalPlaces = decimalPlaces!
       }
       else {
          theDecimalPlaces = 2
       }
       let theNumberFormatter = NumberFormatter()
       theNumberFormatter.formatterBehavior = .behavior10_4
       theNumberFormatter.minimumIntegerDigits = 1
       theNumberFormatter.minimumFractionDigits = 1
       theNumberFormatter.maximumFractionDigits = theDecimalPlaces
       theNumberFormatter.usesGroupingSeparator = true
       theNumberFormatter.groupingSeparator = " "
       theNumberFormatter.groupingSize = 3

       if let theResult = theNumberFormatter.string(from: NSNumber(value:self)) {
          return theResult
       }
       else {
          return "\(self)"
        }
    }
}


extension Date{
    func toChainString()->String{
        let dateFormat = "yyyy/MM/dd HH:mm:ss"
        let seconds = -TimeInterval(TimeZone.current.secondsFromGMT())
        let globalTime = Date(timeInterval: seconds, since: self)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: globalTime)
    }
    
    func toNiceString()->String{
        let dateFormat = "MM/dd/yyyy"
        let seconds = -TimeInterval(TimeZone.current.secondsFromGMT())
        let globalTime = Date(timeInterval: seconds, since: self)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: globalTime)    }
    
    init(chainString: String){
        let dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let gmtDate = dateFormatter.date(from: chainString)!
        let localOffeset = TimeInterval(TimeZone.current.secondsFromGMT())
        self = gmtDate.addingTimeInterval(localOffeset)
    }
    
    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }

    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
}
