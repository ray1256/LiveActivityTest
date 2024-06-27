//
//  CountDowner.swift
//  LiveActiviyTest
//
//  Created by 郭瑋 on 2024/6/27.
//

import Foundation

class CountDownTimer: ObservableObject {
    @Published var timeRemaining: Int

    private var timer: Timer?

    init(time: Int) {
        self.timeRemaining = time
    }

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

    func stop() {
        self.timer?.invalidate()
    }
}
