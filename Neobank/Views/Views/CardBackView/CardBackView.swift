//
//  CardBackView.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - CardBackView

class CardBackView: UIView {

    // MARK: - Outlets

    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var cardNumberLabels: [UILabel]!
    @IBOutlet private var expireTitleLabel: UILabel!
    @IBOutlet private var expireDateLabel: UILabel!
    @IBOutlet private var cvvView: UIView!
    @IBOutlet private var cvvLabel: UILabel!
    @IBOutlet private var progressViewContainer: UIView!
    @IBOutlet private var timeLabel: UILabel!

    // MARK: - Private Properties

    private var progressView: CircularProgressView!
    private let allotedTime: TimeInterval = 30
    private var timeLeft: TimeInterval = .zero
    private var endTime: Date?
    private var timer = Timer()

    // MARK: - View Lifecycle Methods

    static func instantiate() -> CardBackView {
        let view: CardBackView = CardBackView.loadFromNib()
        view.setupProgressView()
        view.updateCVV()
        return view
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        cardNumberLabels.forEach({ $0.textColor = .gunmetalColor })
        [expireDateLabel, cvvLabel, timeLabel].forEach({ $0.textColor = .gunmetalColor })
        expireTitleLabel.textColor = .gunmetalColor.withAlphaComponent(0.4)
    }

    // MARK: - Private Methods

    private func setupProgressView() {
        progressView = CircularProgressView(frame: progressViewContainer.frame)

        progressView.trackColor = UIColor.ghostWhiteColor.withAlphaComponent(0.4)
        progressView.progressColor = UIColor.philippineSilverColor
        progressView.lineWidth = 3.0
        progressViewContainer.addSubview(progressView)
        progressView.adjustFrame(inView: progressViewContainer)
    }

    private func startTimer() {
        timeLeft = allotedTime
        endTime = Date().addingTimeInterval(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil,
                                     repeats: true)
    }

    private func generateCVV() {
        let cvvNumber = Int.random(in: 100...999)
        cvvLabel.text = "\(cvvNumber)"
    }

    private func updateCVV() {
        generateCVV()
        startTimer()
    }

    @objc private func updateTime() {
        if timeLeft > .zero {
            timeLeft = endTime?.timeIntervalSinceNow ?? .zero
        } else {
            updateCVV()
        }
        timeLabel.text = "\(Int(timeLeft))"
        progressView.updateProgress(allottedTime: allotedTime, timeLeft: timeLeft)
    }
}
