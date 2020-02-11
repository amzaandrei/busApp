//
//  circlePage.swift
//  busssssApp
//
//  Created by Andrew on 1/16/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit
import AudioToolbox
class circlePage: UIViewController{
    
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    var timer: Timer!
    var connectivityHandler: ConnectivityHandler!
    
    let percentage: UILabel = {
        let text = UILabel()
        text.text = "00:00"
        text.textAlignment = .center
        text.font = UIFont.boldSystemFont(ofSize: 16)
//        text.font = UIFont(name: "Futura Extra Bold Condensed Oblique", size: 32)
        text.textColor = UIColor.white
        return text
    }()
    
//    var arrivedOnTime: Bool = false
    
    var initialSeconds: Int! = nil
    var seconds: Int! = nil
    var message: Int! = nil{
        didSet{
            seconds = message * 60
            self.updateLabelTimer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        percentage.font = percentage.font.withSize(32)
        self.connectivityHandler = (UIApplication.shared.delegate as? AppDelegate)?.connectivityHandler
        initialSeconds = seconds
        setupNotificationObservers()
        view.backgroundColor = UIColor.backgroundColor
        
        setupCircleLayers()
        setupPercentageLabel()
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(arrivedWithSuccess))
        viewTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(viewTap)
    }
    
    @objc func arrivedWithSuccess(){
        let value = ["arrival": true]
        self.connectivityHandler.session.sendMessage(value, replyHandler: nil) { (err) in
            print(err.localizedDescription)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupPercentageLabel() {
        view.addSubview(percentage)
        percentage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentage.center = view.center
    }
    
    func setupCircleLayers(){
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
    }
    
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.position = view.center
        return layer
    }
    
    
    
    
    func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.5
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    func animateCircle(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    
    func updateLabelTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabel(){
        let timerStr = stringFromTimeInterval()
        if seconds == 0{
            let value = ["arrival": false]
            self.connectivityHandler.session.sendMessage(value, replyHandler: nil, errorHandler: { (err) in
                print(err.localizedDescription)
            })
            return
        }else if seconds == 60 || seconds == 120{
            // TODO: add iphone notifications
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
        beginAnimation()
        self.seconds = self.seconds - 1
        self.percentage.text = String(timerStr)
    }
    
    
    func stringFromTimeInterval() -> String{
        let minutes = self.seconds / 60 % 60
        let seconds = self.seconds % 60
        return String(format: "%0.2d:%0.2d", arguments: [minutes,seconds])
    }
    
    func beginAnimation(){
        let final: CGFloat = 1 - CGFloat(seconds) / CGFloat(initialSeconds)
        self.shapeLayer.strokeEnd = final
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func handleEnterForeground(){
        animatePulsatingLayer()
    }
}


extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
}
