//
//  LiveActivieyWidgetsBundle.swift
//  LiveActivieyWidgets
//
//  Created by 郭瑋 on 2024/6/27.
//

import WidgetKit
import SwiftUI

@main
struct BothWidgetsBundle: WidgetBundle {
    var body: some Widget {
        NormalWidgets()
        ClockRemindWidgetsLiveActivity()
    }
}
