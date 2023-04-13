//
//  ViewController.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 24.03.2023.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseAuth

enum TimerMode {
   case work, breakTime, longBreak
}


class TimerViewController: UIViewController {
    
    //MARK: -IBOutlets
    @IBOutlet weak var stayFocusedLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var restartTimerButton: UIButton!
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    private var timer = Timer()
    private let userdefaults = UserDefaults.standard
    
    private let foreProgressLayer = CAShapeLayer()
    private let backProgressLayer = CAShapeLayer()
    private let animation = CABasicAnimation(keyPath: "strokeStart")
    private var isAnimationStarted = false
    
    private var isTimeToBreak = true
    private var pomodoroCount = 0
    private var secondsRemaining = 1500
    private var timerMode: TimerMode = .work
    
    private var staticTimeForTimer = "25:00"
    private var staticTimeBreakForTimer = "5"
    private var staticTimeLongBreak = "15:00"
    private var isTimerStarted = false
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBackLayer()
        updateLabel(value: staticTimeForTimer)
        setBreakTime(value: staticTimeBreakForTimer)
        dataUserDefaults()
        stayFocusedLabel.text = "Stay focused"
        stayFocusedLabel.textColor = .systemRed
        UNUserNotificationCenter.current().delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(applicationWillEnterForeground),name:UIApplication.willEnterForegroundNotification,object:nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let registrationViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            registrationViewController.modalPresentationStyle = .fullScreen
            self.present(registrationViewController, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - UserDefaults
    func dataUserDefaults() {
        guard let value = userdefaults.string(forKey: "selectedValue") else { return }
        setStaticTimeForTimer(value: value)
        
        guard let breakValue = userdefaults.string(forKey: "breakSelectedValue") else { return }
        setBreakTime(value: breakValue)
        
        guard let longBreakValue = userdefaults.string(forKey: "longBreakSelectedValue") else { return }
        setLongBreakTime(value: longBreakValue)
    }
    
    @objc func applicationDidEnterBackground() {
        // Остановить анимацию и таймер, когда приложение уходит в фоновый режим
        pauseAnimation()
        
    }
    
    @objc func applicationWillEnterForeground() {
        // Запустить анимацию, когда приложение возвращается из фонового режима
        if isTimerStarted == true {
            startResumeAnimation()
        }
    }
    
    func setLongBreakTime(value: String) {
        staticTimeLongBreak = value + ":00"
    }
    
    func setBreakTime(value: String) {
        staticTimeBreakForTimer = value + ":00"
        
    }
    
    func setStaticTimeForTimer(value: String) {
        let readyTime = value + ":00"
        staticTimeForTimer = readyTime
        updateLabel(value: staticTimeForTimer)
    }
    
    
    func updateLabel(value: String) {
        timerLabel.text = value
        stringToSeconds(value: value)
    }
    
    func stringToSeconds(value: String) {
        let timeComponents = value.split(separator: ":")
        let minutes = Int(timeComponents[0]) ?? 0
        let totalSeconds = minutes * 60
        secondsRemaining = totalSeconds
    }
    
    // MARK: - Timer
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        guard secondsRemaining != 1 else {
            timer.invalidate()
            stopAnimation()
            playPauseButton.setImage(UIImage(systemName: "play"), for: .normal)
            switch timerMode {
            case .work:
                pomodoroCount += 1
                if pomodoroCount % 4 == 0 {
                    scheduleTest(title: "Timer", body: "Пора отдохнуть!")
                    updateLabel(value: staticTimeLongBreak)
                    stayFocusedLabel.text = "Take a long break"
                    stayFocusedLabel.textColor = .green
                    timerMode = .longBreak
                } else {
                    scheduleTest(title: "Timer", body: "Пора отдохнуть!")
                    stayFocusedLabel.text = "Take a break"
                    stayFocusedLabel.textColor = .green
                    updateLabel(value: staticTimeBreakForTimer)
                    timerMode = .breakTime
                }
                
            case .breakTime:
                stayFocusedLabel.text = "Stay focused"
                scheduleTest(title: "Timer", body: "Пора поработать!")
                stayFocusedLabel.textColor = .red
                updateLabel(value: staticTimeForTimer)
                timerMode = .work
                
            case .longBreak:
                stayFocusedLabel.textColor = .red
                scheduleTest(title: "Timer", body: "Время поработать!")
                stayFocusedLabel.text = "Stay focused"
                updateLabel(value: staticTimeForTimer)
                timerMode = .work
                pomodoroCount = 0
            }
            return
        }
        secondsRemaining -= 1
        timerLabel.text = formatTimer()
    }
    
    func formatTimer() -> String {
        let minutes = Int(secondsRemaining) / 60 % 60
        let seconds = Int(secondsRemaining) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    @IBAction func toggleTimer(_ sender: Any) {
        if !isTimerStarted {
            drawForeLayer()
            startResumeAnimation()
            startTimer()
            isTimerStarted = true
            playPauseButton.setImage(UIImage(systemName: "pause"), for: .normal)
        } else {
            timer.invalidate()
            isTimerStarted = false
            pauseAnimation()
            playPauseButton.setImage(UIImage(systemName: "play"), for: .normal)
        }
    }
    
    @IBAction func perehodAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        navigationController?.pushViewController(settingsController, animated: true)
    }
    
    @IBAction func restartTimerAction(_ sender: Any) {
        timer.invalidate()
        stopAnimation()
        pomodoroCount = 0
        playPauseButton.setImage(UIImage(systemName: "play"), for: .normal)
        isTimerStarted = false
        timerLabel.text = staticTimeForTimer
        updateLabel(value: staticTimeForTimer)
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
    }
    
    
    
    //MARK: - Notification
    func scheduleTest(title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Animation
    func drawBackLayer() {
        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 150, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        backProgressLayer.lineWidth = 20
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.strokeColor = UIColor.blue.cgColor
        backProgressLayer.cornerRadius = backProgressLayer.bounds.height / 2
        view.layer.addSublayer(backProgressLayer)
        
    }
    
    func drawForeLayer() {
        foreProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 150, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        foreProgressLayer.strokeColor = UIColor.white.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 20
        view.layer.addSublayer(foreProgressLayer)
    }
    
    func startResumeAnimation() {
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAnimation()
        }
    }
    
    func startAnimation() {
        resetAnimation()
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = CFTimeInterval(secondsRemaining)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        foreProgressLayer.add(animation, forKey: "strokeStart")
        isAnimationStarted = true
    }
    
    func resetAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }
    
    func pauseAnimation() {
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        foreProgressLayer.speed = 0.0
        foreProgressLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused
    }
    
    func stopAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }
}

    //MARK: - Extensions
extension TimerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
       }
}
    
extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}


    
    
    
    
