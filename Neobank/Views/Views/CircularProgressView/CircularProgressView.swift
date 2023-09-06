//
//  CircularProgressView.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - CircularProgressView

class CircularProgressView: UIView {

    // MARK: - Internal Properties

    var progressColor = UIColor.whiteColor {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }

    var trackColor = UIColor.whiteColor {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }

    var lineWidth: CGFloat = 10.0 {
        didSet {
            trackLayer.lineWidth = lineWidth
            progressLayer.lineWidth = lineWidth
        }
    }

    var timeLeft: Int = .zero

    // MARK: - Private Properties

    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()

    // MARK: - View Lifecycle Methods

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCircularPath()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupCircularPath()
    }

    // MARK: - Internal Methods

    func updateProgress(allottedTime: TimeInterval, timeLeft: TimeInterval) {
        let progressValue: CGFloat = CGFloat(timeLeft / allottedTime)
        setProgress(value: progressValue)
        self.timeLeft = Int(timeLeft)
    }

    // MARK: - Setup

    private func setupCircularPath() {
        backgroundColor = .clear
        layer.cornerRadius = frame.size.width / 2

        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2,
                                                         y: frame.size.height / 2),
                                      radius: (frame.size.width - 1.5) / 2,
                                      startAngle: CGFloat(1.5 * .pi),
                                      endAngle: CGFloat(-0.5 * .pi),
                                      clockwise: false)
        circlePath.lineCapStyle = .round

        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)

        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = .zero
        layer.addSublayer(progressLayer)
    }

    // MARK: - Private Methods

    private func setProgress(value: CGFloat, animated: Bool = false, duration: TimeInterval? = nil) {
        if animated, let duration = duration {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.fromValue = CGFloat.zero
            animation.toValue = value
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            progressLayer.strokeEnd = value
            progressLayer.add(animation, forKey: "animateprogress")
        } else {
            progressLayer.strokeEnd = value
        }
    }
}
