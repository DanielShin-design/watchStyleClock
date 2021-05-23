//
//  ClockComponents.swift
//  WatchStyleClock
//
//  Created by Dan-Mini on 2021/04/17.
//

import SwiftUI


// 시간과 분을 숫자이미지로 표현
struct NumberImages: View {
    
//    let frameWidth: CGFloat = 85
    let frameheight: CGFloat = 120 // 화면에 보이는 숫자의 크기 값
    
    @Binding var numberInt: Int // 시간 또는 분 숫자값
    @Binding var fillOrStroke: Bool // 숫자 표시 스타일
    @Binding var hiddenZero: Bool // 예를들어 08시 일때 십의자리 0을 숨길지 말지 불리언 밸류
//    init(hiddenZero: Bool) { self.hiddenZero = hiddenZero }
    


    var body: some View {
        let qoutient: Int = numberInt / 10 // 몫
        let residual: Int = numberInt % 10 // 나머지
//        Button(action: { colorProgress += 1 }, label: { }) 버튼으로 하면 누를 때마다 약간 어두워졌다가 밝아지는 피드백이 있지만 제스쳐로하면 피드백 없이 바로 액션이 실행된다.
        HStack(spacing: 13) {
                Image(self.fillOrStroke ? "N\(qoutient)" : "S\(qoutient)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: frameheight)
                    .opacity(qoutient == 0 && hiddenZero == true ? 0.0 : 1.0) // 세로모드 시간이 십의 자리가 0이면 투명도로 안보이게 설정
                    
                Image(self.fillOrStroke ? "N\(residual)" : "S\(residual)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 87, height: frameheight, alignment: .trailing)
                    .frame(height: frameheight, alignment: .trailing)

        }
    }
}


// 초침을 표현하는 bar
struct SecondDots: View {
    
    @Binding var secondNotify: Int
    
    var body: some View {
        ZStack{
            //10초 마다 표시
            HStack(spacing: 2){
                ForEach(0..<60) { dot in
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 2, height: 4, alignment: .center)
                        .foregroundColor(
                            (dot % 10 == 0) ? Color.init(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)) : Color.init(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5031910211))
                        )
                }
            }
            // 초침 움직임
            HStack(spacing: 2){
                ForEach(0..<60) { dot in
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 2,
                               height: secondNotify == dot ? 10 : 4, alignment: .center)
                        .foregroundColor(
                            secondNotify >= dot ? Color.init(#colorLiteral(red: 0.8067924223, green: 0.8067924223, blue: 0.8067924223, alpha: 1)) : .clear
                        )
                }
            }
        }
    }
}

