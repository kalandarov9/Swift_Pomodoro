//
//  ViewController.swift
//  HW11_Pomodoro_new
//
//  Created by Yuri Kalandarov on 25.12.2021.
//  Copyright © 2021 Yuri Kalandarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer = Timer()

    private var isTimeStarted = false
    private var isAnimationStarted = false
    private var time = 1500
    private let workingTime = 1500
    private var freetime = 300
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

        setupHierarchy()
        setupLayout()
        setupView()

    }

    private func setupHierarchy() {
        view.addSubview(labelCount)
        view.addSubview(buttonPlay)
        view.addSubview(stopButton)
    }

    private func setupLayout() {
        labelCount.translatesAutoresizingMaskIntoConstraints = false
        labelCount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelCount.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true

        buttonPlay.translatesAutoresizingMaskIntoConstraints = false
        buttonPlay.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        buttonPlay.topAnchor.constraint(equalTo: labelCount.bottomAnchor, constant: 50).isActive = true
        buttonPlay.heightAnchor.constraint(equalToConstant: 70 ).isActive = true
        buttonPlay.widthAnchor.constraint(equalToConstant: 70 ).isActive = true
    }

    private func setupView() {}

    private func showButtonClose() {
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 110).isActive = true
        stopButton.topAnchor.constraint(equalTo: labelCount.bottomAnchor, constant: -100).isActive = true
        stopButton.heightAnchor.constraint(equalToConstant: 30 ).isActive = true
        stopButton.widthAnchor.constraint(equalToConstant: 30 ).isActive = true
    }

    @objc private func buttonAction() {

    }

    private func startTime()  {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }

    @objc private func fireTimer() {
        if time < 1 {
            buttonPlay.setBackgroundImage(UIImage(named: "play.fill"), for: .normal)
            timer.invalidate()
            time = workingTime
            if !isWorkingTime {
                time = freetime
            } else {
                time = freetime
            }
            isTimeStarted = false
        } else {
            time -= 1
            labelCount.text = formatTime()
        }
    }

    private func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%0.2d:%0.2d",minutes, seconds)
    }

    @objc private func stopAnimation() {}

}


