//
//  ViewController.swift
//  SleepWithMe
//
//  Created by Ansèlm Joseph on 05/06/18.
//  Copyright © 2018 an23lm. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var isPopover: Bool = false
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var timerView: NSTimerView!
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var minuteTitleLabel: NSTextField!
    
    @IBOutlet weak var decreaseTimeButton: NSTimerButton!
    @IBOutlet weak var increaseTimeButton: NSTimerButton!
    
    @IBOutlet weak var activationButton: NSButton!
    
    @IBOutlet weak var closeButton: NSTimerButton!
    @IBOutlet weak var preferencesButton: NSButton!
    
    private var currentMinutes: Int {
       return SleepTimer.shared.currentMinutes
    }
    
    private var isTimerRunning: Bool {
        return SleepTimer.shared.isTimerRunning
    }

    private var stepSize: CGFloat {
        return SleepTimer.shared.stepSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        SleepTimer.shared.onTimeRemainingChange(onTimeRemainingChange)
        SleepTimer.shared.onTimerActivated(onTimerActivated)
        SleepTimer.shared.onTimerInvalidated(onTimerInvalidated)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.isMovableByWindowBackground = true
        if SleepTimer.shared.isTimerRunning {
            setStopTimerButton()
        } else {
            setStartTimerButton()
        }
    }
    
    private func setup() {
        self.view.wantsLayer = true
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        
        activationButton.wantsLayer = true
        setStartTimerButton()
        activationButton.isBordered = false
        activationButton.layer?.cornerRadius = 5
        
        decreaseTimeButton.style = .decrement
        decreaseTimeButton.wantsLayer = true
        decreaseTimeButton.isBordered = false
        if #available(OSX 10.12, *) {
            decreaseTimeButton.layer?.backgroundColor = NSColor(displayP3Red: 0, green: 105/256.0, blue: 91/256.0, alpha: 1).cgColor
        } else {
            decreaseTimeButton.layer?.backgroundColor = NSColor(deviceRed: 0, green: 105/256.0, blue: 91/256.0, alpha: 1).cgColor
        }
        decreaseTimeButton.layer?.cornerRadius = 25
        
        increaseTimeButton.style = .increment
        increaseTimeButton.wantsLayer = true
        increaseTimeButton.isBordered = false
        if #available(OSX 10.12, *) {
            increaseTimeButton.layer?.backgroundColor = NSColor(displayP3Red: 0, green: 105/256.0, blue: 91/256.0, alpha: 1).cgColor
        } else {
            increaseTimeButton.layer?.backgroundColor = NSColor(deviceRed: 0, green: 105/256.0, blue: 91/256.0, alpha: 1).cgColor
        }
        increaseTimeButton.layer?.cornerRadius = 25
        
        closeButton.style = .close
        closeButton.wantsLayer = true
        closeButton.isBordered = false
        if #available(OSX 10.12, *) {
            closeButton.layer?.backgroundColor = NSColor(displayP3Red: 237/256.0, green: 108/256.0, blue: 97/256.0, alpha: 1).cgColor
        } else {
            closeButton.layer?.backgroundColor = NSColor(deviceRed: 237/256.0, green: 108/256.0, blue: 97/256.0, alpha: 1).cgColor
        }
        closeButton.layer?.cornerRadius = 10
        
        preferencesButton.wantsLayer = true
        preferencesButton.isBordered = false
        preferencesButton.layer?.backgroundColor = NSColor(calibratedWhite: 1, alpha: 0).cgColor
        
        if !isPopover {
            closeButton.isHidden = true
            preferencesButton.isHidden = true
        }
    }
    
    override func viewDidAppear() {
        timerLabel.stringValue = String(currentMinutes)
        timerView.animateBackgroundArc(duration: 1.0)
        timerView.animateForegroundArc(toPosition: CGFloat(self.currentMinutes) * self.stepSize, fromPosition: 0, duration: 1.0)
    }
    
    //MARK: - Callback closures
    lazy var onTimeRemainingChange: SleepTimer.onTimeRemainingCallback = {[weak self] (minutes) in
        self?.timerLabel.stringValue = String(minutes)
        self?.timerView.moveForegorundArc(toPosition: CGFloat(minutes) * SleepTimer.shared.stepSize)
    }
    
    lazy var onTimerActivated: SleepTimer.onTimerActivatedCallback = {[weak self] in
        self?.setStopTimerButton()
    }
    
    lazy var onTimerInvalidated: SleepTimer.onTimerInvalidatedCallback = {[weak self] (_) in
        self?.setStartTimerButton()
    }
    
    //MARK: - Actions
    @IBAction func exit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func onClickPreferencesButton(_ sender: Any) {
        (NSApplication.shared.delegate as! AppDelegate).closePopover(sender)
        performSegue(withIdentifier: "ShowPreferences", sender: self)
    }
    
    @IBAction func decreaseTimer(_ sender: Any) {
        SleepTimer.shared.decreaseTime()
    }
    
    @IBAction func increaseTimer(_ sender: Any) {
        SleepTimer.shared.increaseTime()
    }
    
    @IBAction func timerToggleButton(_ sender: Any) {
        SleepTimer.shared.toggleTimer()
    }
    
    private func setStopTimerButton() {
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        self.activationButton.attributedTitle = NSAttributedString(string: "Stop Timer", attributes: [NSAttributedString.Key.foregroundColor: NSColor.white, NSAttributedString.Key.paragraphStyle: pstyle, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 20, weight: .light)])
        if #available(OSX 10.12, *) {
            self.activationButton.layer?.backgroundColor = NSColor(displayP3Red: 238/256.0, green: 96/256.0, blue: 2/256.0, alpha: 1.0).cgColor
        } else {
            self.activationButton.layer?.backgroundColor = NSColor(deviceRed: 238/256.0, green: 96/256.0, blue: 2/256.0, alpha: 1.0).cgColor
        }
    }
    
    private func setStartTimerButton() {
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        self.activationButton.attributedTitle = NSAttributedString(string: "Start Timer", attributes: [NSAttributedString.Key.foregroundColor: NSColor.white, NSAttributedString.Key.paragraphStyle: pstyle, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 20, weight: .regular)])
        if #available(OSX 10.12, *) {
            self.activationButton.layer?.backgroundColor = NSColor(displayP3Red: 83/256.0, green: 0/256.0, blue: 232/256.0, alpha: 1.0).cgColor
        } else {
            self.activationButton.layer?.backgroundColor = NSColor(deviceRed: 83/256.0, green: 0/256.0, blue: 232/256.0, alpha: 1.0).cgColor
        }
    }
}