//
//  CountDowner.swift
//  LiveActiviyTest
//
//  Created by 郭瑋 on 2024/6/27.
//

import Foundation

class CountDownTimer: ObservableObject {
    /// 剩餘時間
    @Published var timeRemaining: Int

    private var timer: Timer?

    init(time: Int) {
        self.timeRemaining = time
    }

    /// 開始Timer
    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1,
                                     repeats: true,
                                     block: { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
            }
        })
    }

    /// 停止Timer
    func stop() {
        self.timer?.invalidate()
    }


    /// 改變剩餘時間
    func replaceTime(time: Int) {
        self.timeRemaining = time
    }

    /// 將數字轉換成時間文字
    func transformString(time: Int) -> String {
        let components = DateComponents(minute: time / 60,
                                        second: time % 60)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: components) ?? "00:00"
    }
}
