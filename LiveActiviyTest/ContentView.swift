//
//  ContentView.swift
//  LiveActiviyTest
//
//  Created by 郭瑋 on 2024/6/27.
//

import SwiftUI
import ActivityKit

struct ContentView: View {

    @State var activity: Activity<ClockRemindWidgetsAttributes>?

    @StateObject private var countDownTimer = CountDownTimer(time: 10)

    @State var status: Int = 0

    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 40)
                Button(action: {
                    do {
                        if let _ = activity {
                            Task {
                                await updateFireWork()

                            }
                        } else {
                            let initialContentState = ClockRemindWidgetsAttributes.ContentState(
                                image: "dragon2",
                                remainingTime: "00:10",
                                statusText: "熱情如火的工作")

                            let attr = ClockRemindWidgetsAttributes(name: "World")
                            status = 0
                            countDownTimer.start()


                            activity = try Activity.request(attributes: attr,
                                                            contentState: initialContentState,
                                                            pushType: nil)
                        }
                    } catch {
                        print("err \(error)")
                    }
                }, label: {
                    Text("工作Mode")
                })

                Spacer()

                Button(action: {
                    if let _ = activity {
                        Task {
                            await updateCoolDown()
                        }
                    } else {
                        do {
                            let state = ClockRemindWidgetsAttributes.ContentState(
                                image: "carb",
                                remainingTime: "00:10",
                                statusText: "放鬆一下"
                            )
                            let attr = ClockRemindWidgetsAttributes(name: "World")

                            self.countDownTimer.replaceTime(time: 10)
                            status = 1
                            countDownTimer.start()

                            activity = try Activity.request(attributes: attr,
                                                 contentState: state,
                                                 pushType: nil)

                        } catch {
                            print("err \(error)")
                        }
                    }
                },
                       label: {
                    Text("休息Mode")
                })
                Spacer().frame(width: 40)
            }.onReceive(countDownTimer.$timeRemaining,
                        perform: { timeRemaining in
               let text = countDownTimer.transformString(time: timeRemaining)
               updateLiveActivity(timeRemaining: text,
                                  time: timeRemaining,
                                  image: status == 0 ? "dragon2" : "carb",
                                  statusText: status == 0 ? "熱情如火的工作" : "需要冷靜")
           })
        }
        .padding()
    }
    
    /// 更新LiveActivity
    /// - Parameters:
    ///   - timeRemaining: 剩餘時間（String）
    ///   - time: 剩餘時間(Int)
    ///   - image: 狀態Image
    ///   - statusText: 狀態文字
    func updateLiveActivity(timeRemaining: String,
                            time: Int,
                            image: String,
                            statusText: String) {
        Task {
            let state = ClockRemindWidgetsAttributes.ContentState(image: image,
                                                                   remainingTime: timeRemaining,
                                                                   statusText: statusText)

            if time == 0 {
                endLiveActivity()
            } else if time <= 3 {
                // 帶有提示聲
                let alertConfigure = AlertConfiguration(title: "時間結束了",
                                                        body: "開始繼續戰鬥",
                                                        sound: .default)
                            await self.activity?.update(
                                ActivityContent<ClockRemindWidgetsAttributes.ContentState>(state: state,
                                                                                           staleDate: nil),
                                alertConfiguration: alertConfigure
                            )
            } else {
                // 沒帶提示
                await self.activity?.update(using: state)
            }
        }
    }

    func endLiveActivity() {
        let endState = ClockRemindWidgetsAttributes.ContentState(image: "lu",
                                                                 remainingTime: "",
                                                                 statusText: "時間到了")
        let dismissSalPolicy: ActivityUIDismissalPolicy = .default
        await self.activity?.end(
            ActivityContent(state: state,
                            staleDate: nil),
            dismissalPolicy: dismissSalPolicy
        )
    }


    func updateFireWork() async {
        if let activity = activity {
            if activity.activityState == .ended {
                self.countDownTimer.stop()
                status = 0
                self.countDownTimer.replaceTime(time: 10)
                let attr = ClockRemindWidgetsAttributes(name: "World")
                let state = ClockRemindWidgetsAttributes.ContentState(image: "dragon2",
                                                                      remainingTime: "00:10",
                                                                      statusText: "熱情如火的工作")
                do {
                    self.activity = try Activity.request(attributes: attr,
                                                         contentState: state,
                                                         pushType: nil)
                } catch {
                    print("Error", error.localizedDescription)
                }
            } else {
                self.countDownTimer.stop()
                status = 0
                self.countDownTimer.replaceTime(time: 10)

                await activity.update(using:.init(image: "dragon2",
                                                   remainingTime: "00:10",
                                                   statusText: "熱情如火的工作"))
                self.countDownTimer.start()
            }
        }
    }

    func updateCoolDown() async {
        if let activity = activity {
            if activity.activityState == .ended {
                self.countDownTimer.stop()
                status = 1
                let attr = ClockRemindWidgetsAttributes(name: "World")
                let state = ClockRemindWidgetsAttributes.ContentState(image: "carb",
                                                                      remainingTime: "00:10",
                                                                      statusText: "休息一下")
                self.countDownTimer.replaceTime(time: 10)
                do {
                    self.activity = try Activity.request(attributes: attr,
                                                         contentState: state,
                                                         pushType: nil)

                    self.countDownTimer.start()
                } catch {
                    print("Error", error.localizedDescription)
                }
            } else {
                self.countDownTimer.stop()
                status = 1
                let state = ClockRemindWidgetsAttributes.ContentState(image: "carb",
                                                                      remainingTime: "00:10",
                                                                      statusText: "休息一下")
                let alertConfigure = AlertConfiguration(title: "時間結束了",
                                                        body: "開始繼續戰鬥",
                                                        sound: .default)
                self.countDownTimer.replaceTime(time: 10)
                await activity.update(
                    ActivityContent<ClockRemindWidgetsAttributes.ContentState>(state: state,
                                                                               staleDate: nil),
                    alertConfiguration: alertConfigure
                )
                self.countDownTimer.start()
            }
        }
    }
}

#Preview {
    ContentView(activity: nil)
}
