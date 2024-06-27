//
//  ContentView.swift
//  LiveActiviyTest
//
//  Created by 郭瑋 on 2024/6/27.
//

import SwiftUI
import ActivityKit

struct ContentView: View {

    @State var activity: Activity<LiveActivieyWidgetsAttributes>?

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")

            Spacer().frame(height: 20)
            Button(action: {
                do {
                    if let activity = activity {
                        Task {
                            await activity.update(using:
                                    .init(image: "carb",
                                          remainingTime: "00:03",
                                          statusText: "熱情如火的工作"))
                        }
                    } else {
                        let state = LiveActivieyWidgetsAttributes.ContentState(
                            image: "carb",
                            remainingTime: "00:03",
                            statusText: "熱情如火的工作")
                        let attr = LiveActivieyWidgetsAttributes(name: "World")

                        let content = ActivityContent(state: <#T##_#>, staleDate: <#T##Date?#>)
                        activity = try Activity.request(attributes: attr,
                                                        contentState: state)
                    }
                } catch {
                    print("err \(error)")
                }
            }, label: {
                Text("點我開始熱情工作Mode")
            })

            Button(action: {
                if let activity = activity {
                    Task {
                        let state = LiveActivieyWidgetsAttributes.ContentState(image: "lu",
                                                                               remainingTime: "05:00",
                                                                               statusText: "休息一下")
                        let alertConfigure = AlertConfiguration(title: "時間結束了",
                                                                body: "開始繼續戰鬥",
                                                                sound: .default)
                        await activity.update(
                            ActivityContent<LiveActivieyWidgetsAttributes>(state: state,
                                                                           staleDate: nil),
                            alertConfiguration: alertConfigure
                        )
                    }
                } else {
                    do {
                        let state = LiveActivieyWidgetsAttributes.ContentState(
                            image: "lu",
                            remainingTime: "05:00",
                            statusText: "放鬆一下"
                        )
                        let attr = LiveActivieyWidgetsAttributes(name: "World")
                        try Activity.request(attributes: attr,
                                             contentState: state)
                    } catch {
                        print("err \(error)")
                    }
                }
            },
                   label: {
                Text("點我觸發")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView(activity: nil)
}
