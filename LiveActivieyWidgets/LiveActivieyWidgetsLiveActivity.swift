//
//  LiveActivieyWidgetsLiveActivity.swift
//  LiveActivieyWidgets
//
//  Created by 郭瑋 on 2024/6/27.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivieyWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var image: String
        var remainingTime: String
        var statusText: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LiveActivieyWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivieyWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
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
                    Text("目前進入\(context.state.statusText)")
                    Text("時間還剩餘\(context.state.remainingTime)")
                }
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
                    Text("剛進入\(context.state.statusText)狀態，還能持續\(context.state.remainingTime)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.statusText)")
            } minimal: {
                Text(context.state.statusText)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LiveActivieyWidgetsAttributes {
    fileprivate static var preview: LiveActivieyWidgetsAttributes {
//        LiveActivieyWidgetsAttributes(name: "Wild")
        LiveActivieyWidgetsAttributes(name: "World")
    }
}

extension LiveActivieyWidgetsAttributes.ContentState {
//    fileprivate static var smiley: LiveActivieyWidgetsAttributes.ContentState {
//        LiveActivieyWidgetsAttributes.ContentState(emoji: "😀")
//     }
     
     fileprivate static var starEyes: LiveActivieyWidgetsAttributes.ContentState {
         LiveActivieyWidgetsAttributes.ContentState(image: "carb",
                                                    remainingTime: "05:00",
                                                    statusText: "休息一下")
     }
}

#Preview("Notification", as: .content, using: LiveActivieyWidgetsAttributes.preview) {
   LiveActivieyWidgetsLiveActivity()
} contentStates: {
//    LiveActivieyWidgetsAttributes.ContentState.smiley
    LiveActivieyWidgetsAttributes.ContentState.starEyes
}
