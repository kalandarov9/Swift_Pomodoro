//
//  ViewController.swift
//  HW11_Pomodoro_new
//
//  Created by Yuri Kalandarov on 25.12.2021.
//  Copyright © 2021 Yuri Kalandarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

    var timer = Timer()

    private var isTimeStarted = false
    private var isAnimationStarted = false
    private var time = 1500
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private let animation = CABasicAnimation(keyPath: "strokeEnd")
    private var isWorkingTime = true
    private var isVisialClossButton =  false

    private lazy var labelCount: UILabel = {

        var label = UILabel()
        label.text = formatTime()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 31, weight: .light)

        return label
    }()

    private lazy var buttonPlay: UIButton = {

        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "play.fill"), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        return button
    }()

    private lazy var stopButton: UIButton = {

        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "x.circle"), for: .normal)
        button.addTarget(self, action: #selector(stopAnimation), for: .touchUpInside)

        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(labelCount)
        view.addSubview(buttonPlay)
        view.addSubview(stopButton)

        labelCount.translatesAutoresizingMaskIntoConstraints = false
        labelCount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelCount.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true

        buttonPlay.translatesAutoresizingMaskIntoConstraints = false
        buttonPlay.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        buttonPlay.topAnchor.constraint(equalTo: labelCount.bottomAnchor, constant: 50).isActive = true
        buttonPlay.heightAnchor.constraint(equalToConstant: 70 ).isActive = true
        buttonPlay.widthAnchor.constraint(equalToConstant: 70 ).isActive = true

        createCircularPath(isWorkingTime: isWorkingTime)
    }

    func showButtonClose() {
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 110).isActive = true
        stopButton.topAnchor.constraint(equalTo: labelCount.bottomAnchor, constant: -100).isActive = true
        stopButton.heightAnchor.constraint(equalToConstant: 30 ).isActive = true
        stopButton.widthAnchor.constraint(equalToConstant: 30 ).isActive = true
    }

    @objc func buttonAction() {
        labelCount.text = formatTime()

        showButtonClose()

        if isTimeStarted == false {
            drawAnimateLayer(isWorkingTime: isWorkingTime)
            startOrResumeAnimation()
            startTime()
            isTimeStarted = true
            buttonPlay.setBackgroundImage(UIImage(named: "pause.fill"), for: .normal)
        } else {
            pauseAnimation()
            timer.invalidate()
            buttonPlay.setBackgroundImage(UIImage(named: "play.fill"), for: .normal)
            isTimeStarted = false
        }
    }

    func startTime()  {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }

    @objc func fireTimer() {
        if time < 1 {
            buttonPlay.setBackgroundImage(UIImage(named: "play.fill"), for: .normal)
            timer.invalidate()
            time = Metric.workingTime
            if !isWorkingTime {
                time = Metric.freetime
            } else {
                time = Metric.freetime
            }
            isTimeStarted = false
        } else {
            time -= 1
            labelCount.text = formatTime()
        }
    }

    // MARK: - Properties -

    func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%0.2d:%0.2d",minutes, seconds)
    }

    func createCircularPath(isWorkingTime: Bool) {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 120, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true)

        circleLayer.path = circularPath.cgPath

        if isWorkingTime {
            circleLayer.strokeColor = UIColor.black.cgColor
            circleLayer.strokeColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) //#b2e9af

        } else {
            circleLayer.strokeColor = UIColor.white.cgColor
            circleLayer.strokeColor = #colorLiteral(red: 0.4723537564, green: 0.7611255646, blue: 0.7046559453, alpha: 1) //#b2e9af
        }

        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 15

        view.layer.addSublayer(circleLayer)
    }

    func drawAnimateLayer(isWorkingTime: Bool) {
        progressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 120, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 15.0
        if isWorkingTime {
            progressLayer.strokeColor = #colorLiteral(red: 0.9892888665, green: 0.5561057925, blue: 0.5085045695, alpha: 1)
        } else {
            progressLayer.strokeColor = #colorLiteral(red: 0.4723537564, green: 0.7611255646, blue: 0.7046559453, alpha: 1) //#b2e9af
        }
        view.layer.addSublayer(progressLayer)
    }

    func startAnimation(duration: TimeInterval) {
        resetAnimation()
        progressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = duration
        animation.delegate = self
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        progressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }

    func startOrResumeAnimation() {
        if !isAnimationStarted {
            startAnimation(duration: TimeInterval(time))
        } else {
            resumeAnimation()
        }
    }

     func pauseAnimation() {
           let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
           progressLayer.speed = 0
           progressLayer.timeOffset = pausedTime
       }

       func resumeAnimation() {
           let pausedTime = progressLayer.timeOffset
           progressLayer.speed = 1.0
           progressLayer.timeOffset = 0.0
           progressLayer.beginTime = 0.0
           let timePaused = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
           progressLayer.beginTime = timePaused
       }

    func resetAnimation() {
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        progressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }

    @objc func stopAnimation() {
        timer.invalidate()

        buttonPlay.setBackgroundImage(UIImage(named: "play.fill"), for: .normal)
        labelCount.text = Metric.labelTextWorkTime
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()

        if isWorkingTime {
            labelCount.text = Metric.labelTextWorkTime
            time = Metric.workingTime
        } else {
            labelCount.text = Metric.labelTextFreeTime
            time = Metric.freetime
        }
        isTimeStarted = false
        isAnimationStarted = false
    }

    func autoStopEnd() {

        if isWorkingTime {
            isWorkingTime = false
            labelCount.text = Metric.labelTextFreeTime
            time = Metric.freetime
            stopAnimation()
        } else {
            isWorkingTime = true
            labelCount.text = Metric.labelTextWorkTime
            time = Metric.freetime
            stopAnimation()
        }

        isAnimationStarted = false
    }

    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        autoStopEnd()
    }
}

extension Double {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

extension ViewController {

    enum Metric {
        static let workingTime = 1500
        static let freetime = 300
        static let labelTextFreeTime = "05:00"
        static let labelTextWorkTime = "25:00"
    }
    
}



