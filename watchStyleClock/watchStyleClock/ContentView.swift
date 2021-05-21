//
//  ContentView.swift
//  watchStyleClock
//
//  Created by iM27 on 2021/05/21.
//

import SwiftUI


struct Time {
    var min: Int
    var sec: Int
    var hour: Int
}


struct ContentView: View {
    
    
    @State var timeRepeat = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var currentTime = Time(min: 0, sec: 0, hour: 0)
    @State var secondNotify : Int = 0
    
    @State var todayString = ""
    @SceneStorage("dateFormatStyle") var dateFormatStyle: Bool = true // 날짜 표현 방식 일,월,요일 순인지 아닌지
    
    @SceneStorage("hourFillOrStroke") var hourFillOrStroke = true // true -> N1, false -> S1
    @SceneStorage("minFillOrStroke") var minFillOrStroke = true // true -> N1, false -> S1
    
    let ColorsArray = [
        Color.init(#colorLiteral(red: 0.517097259, green: 0.7031672236, blue: 0.9265705959, alpha: 1)),
        Color.init(#colorLiteral(red: 0.5936723865, green: 0.8363088447, blue: 0.9031938148, alpha: 1)),
        Color.init(#colorLiteral(red: 0.5945862284, green: 0.9031938148, blue: 0.7144676199, alpha: 1)),
        Color.init(#colorLiteral(red: 0.7817133973, green: 0.9031938148, blue: 0.5341807299, alpha: 1)),
        Color.init(#colorLiteral(red: 0.9260241256, green: 0.8649940925, blue: 0.7823919368, alpha: 1)),
        Color.init(#colorLiteral(red: 0.9031938148, green: 0.7972016356, blue: 0.579209718, alpha: 1)),
        Color.init(#colorLiteral(red: 0.9549465674, green: 0.7068084577, blue: 0.6176115995, alpha: 1)),
        Color.init(#colorLiteral(red: 0.9414264897, green: 0.6713687952, blue: 0.7092445153, alpha: 1)),
        Color.init(#colorLiteral(red: 1, green: 0.662143596, blue: 0.8702468436, alpha: 1)),
        Color.init(#colorLiteral(red: 0.9282192306, green: 0.6413871627, blue: 1, alpha: 1)),
        Color.init(#colorLiteral(red: 0.6920863672, green: 0.6586222186, blue: 0.9308209197, alpha: 1)),
        Color.init(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
        Color.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
    ]
    
    @SceneStorage("hourColorProgress") var hourColorProgress: Int = Int.random(in: 0...12)
    var hourColorValue: Int { hourColorProgress % 13 }
    
    @SceneStorage("minColorProgress") var minColorProgress: Int = Int.random(in: 0...12)
    var minColorValue: Int { minColorProgress % 13 }

    
    //세로화면에서 십의자리 시간이 0이면 숨기기 위한 Bool 값인데 없앨순 없을까?
    @State var numberHiddenTrue = true
    @State var numberHiddenFalse = false

    
    @State var screenWidth: CGFloat = 0 // 가로세로 UI 변경을 위해
    
    @State private var hideStatusBar = true // 상태바 숨김
    
    
    //.onReceive 안에서 호줄되는 함수
    func clockLogic() {
        screenWidth = UIScreen.main.bounds.width
        
        let formatter = DateFormatter()
        formatter.dateFormat = self.dateFormatStyle ? "M. d. eee" : "d. MMM. eee"
        todayString = "\(formatter.string(from: Date()))"
    
        let calender = Calendar.current
        let min = calender.component(.minute, from: Date())
        let sec = calender.component(.second, from: Date())
        let hour = calender.component(.hour, from: Date())
        var displayHour: Int {
            var tweleveSystemHour: Int
            if hour > 12 {
                tweleveSystemHour = hour - 12
            } else {
                tweleveSystemHour = hour
            }
            return tweleveSystemHour
        }
        
        currentTime = Time(min: min, sec: sec, hour: displayHour)
        secondNotify = currentTime.sec
    }
    
    // 햅틱피드백
    func hapticFeedback() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
        
    var body: some View {

        ZStack{
            
            Color.black
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: hideStatusBar) // 상단 정보 숨김
                .onAppear{ UIApplication.shared.isIdleTimerDisabled = true } // 화면 자동으로 꺼짐 방지
                .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
//                .prefersHomeIndicatorAutoHidden(true)

            
            VStack{
                    HStack{
                    Spacer()
                    Text("\(todayString)")
                        .font(.system(size: 20, design: .rounded))
                        .bold()
                        .foregroundColor(.gray)
                        // 가로모드로 바뀔때 자동으로 리프레쉬가 안되서 그냥 스페이서로 레이아웃 변경하도록 설정
                        // .frame(width: UIScreen.main.bounds.width, alignment: .topTrailing)
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 20))
                        .onTapGesture(count: 1, perform: { dateFormatStyle.toggle() })
                        .onLongPressGesture(perform: { hideStatusBar.toggle() })
                }
                Spacer()
            }
       
            VStack {
                
                if screenWidth > 500 {
                    //가로화면모드
                    HStack(spacing: 40){
                        // 바인딩된 이니셜라이즈 값은 그냥 숫자 또는 true,false 를 넣을 수 없는가?
                        NumberImages(numberInt: $currentTime.hour, fillOrStroke: $hourFillOrStroke, hiddenZero: $numberHiddenFalse)
                            .onTapGesture { hourColorProgress += 1 }
                            .onLongPressGesture(minimumDuration: 0.2, perform: {
                                                    hapticFeedback()
                                                    hourFillOrStroke.toggle() })
                            .colorMultiply(ColorsArray[hourColorValue]) // 이미지가 하얀색이어야 색상이 멀티플라이 된다.
                        
                        NumberImages(numberInt: $currentTime.min, fillOrStroke: $minFillOrStroke, hiddenZero: $numberHiddenFalse)
                            .onTapGesture { minColorProgress += 1 }
                            .onLongPressGesture(minimumDuration: 0.2, perform: {
                                                    hapticFeedback()
                                                    minFillOrStroke.toggle() })
                            .colorMultiply(ColorsArray[minColorValue])
                    }
//                    .offset(x: currentTime.hour > 9 ? -20 : 0)
                    
                } else {
                    //세로화면모드
                    VStack(alignment: .trailing, spacing: 20){
                        
                        NumberImages(numberInt: $currentTime.hour, fillOrStroke: $hourFillOrStroke, hiddenZero: $numberHiddenTrue)
                            .onTapGesture { hourColorProgress += 1 }
                            .onLongPressGesture(minimumDuration: 0.2, perform: {
                                                    hapticFeedback()
                                                    hourFillOrStroke.toggle() })
                            .colorMultiply(ColorsArray[hourColorValue])
                        
                        NumberImages(numberInt: $currentTime.min, fillOrStroke: $minFillOrStroke, hiddenZero: $numberHiddenFalse)
                            .onTapGesture { minColorProgress += 1 }
                            .onLongPressGesture(minimumDuration: 0.2, perform: {
                                                    hapticFeedback()
                                                    minFillOrStroke.toggle() })
                            .colorMultiply(ColorsArray[minColorValue])
                        
                        
                    }
                }

                SecondDots(secondNotify: $secondNotify)
                    .padding(.top, 20)
                
            }
        }.onReceive(timeRepeat, perform: { _ in
            clockLogic()
            })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



