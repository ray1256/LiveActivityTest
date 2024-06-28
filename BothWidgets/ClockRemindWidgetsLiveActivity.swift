//
//  ClockRemindWidgetsLiveActivity.swift
//  LiveActivieyWidgets
//
//  Created by 郭瑋 on 2024/6/27.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ClockRemindWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var image: String
        var remainingTime: String
        var statusText: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ClockRemindWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ClockRemindWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                Spacer().frame(width: 20)
                VStack {
                    Image("\(context.state.image)").resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray,
                                                 lineWidth: 1))
                        .shadow(radius: 5)

                }
                VStack {
                    Text("目前進入\(context.state.statusText)").frame(alignment: .leading)
                    Text("時間還剩餘\(context.state.remainingTime)").frame(alignment: .leading)
                }

                Spacer()
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image("\(context.state.image)").resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray,
                                                 lineWidth: 1))
                        .shadow(radius: 5)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.statusText)")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("剛進入\(context.state.statusText)狀態，還能持續\n\(context.state.remainingTime)")
                    // more content
                }
            }
            compactLeading: {
                Text("目前狀態")
            }
            compactTrailing: {
                Text(context.state.statusText.contains("熱情") ? "燃燒中" : "冷卻中")
            }
            minimal: {
                Text(context.state.statusText)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ClockRemindWidgetsAttributes {
    fileprivate static var preview: ClockRemindWidgetsAttributes {
        ClockRemindWidgetsAttributes(name: "World")
    }
}

extension ClockRemindWidgetsAttributes.ContentState {
     fileprivate static var starEyes: ClockRemindWidgetsAttributes.ContentState {
         ClockRemindWidgetsAttributes.ContentState(image: "carb",
                                                    remainingTime: "05:00",
                                                    statusText: "休息一下")
     }
}

//#Preview("Notification", as: .content, using: ClockRemindWidgetsAttributes.preview) {
//   ClockRemindWidgetsLiveActivity()
//} contentStates: {
////    LiveActivieyWidgetsAttributes.ContentState.smiley
//    ClockRemindWidgetsAttributes.ContentState.starEyes
//}
