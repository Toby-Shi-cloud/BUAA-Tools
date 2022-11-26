// From https://blog.csdn.net/qq_36924683/article/details/127748879

import SwiftUI

struct BackgoundView: View {
    var body: some View {
        ZStack {
            //全局渐变色背景
            LinearGradient(colors: [Color.cyan.opacity(0.7), Color.purple.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
            
            Circle()
                .frame(width: 300)
                .foregroundStyle(Color.blue.opacity(0.3))
                .blur(radius: 10)
                .offset(x: -130, y: -150)
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .frame(width: 500, height: 500)
                .foregroundStyle(LinearGradient(colors: [Color.purple.opacity(0.6), Color.mint.opacity(0.5)], startPoint: .top, endPoint: .leading))
                .offset(x: 300)
                .blur(radius: 30)
                .rotationEffect(.degrees(30))
            
            Circle()
                .frame(width: 250)
                .foregroundStyle(Color.pink.opacity(0.6))
                .blur(radius: 20)
                .offset(x: 200, y: -200)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct BackgoundViewDemoPage: View {
    var body: some View {
        ZStack {
            BackgoundView()
            
            VStack(spacing: 20, content: {
                HStack{
                    VStack(alignment: .center) {
                        Text("2")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        Text("rank".uppercased())
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        Text("Nov 3")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        Text("birthday".uppercased())
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        Text("26")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        Text("years old".uppercased())
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                    }
                }
                .padding()
                .foregroundStyle(LinearGradient(colors: [.blue, .indigo], startPoint: .top, endPoint: .bottom))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Communication".uppercased())
                        .font(.headline)
                    
                    HStack(alignment: .top, content: {
                        Text("yeah I tried to go yesterday, but they were closed so maybe tomorrow idk")
                            .font(.caption)
                            .frame(width: 250, height: 32)
                        
                        Spacer()
                        
                        Text("Yesterday")
                            .font(.system(size: 12, weight: .bold))
                    })
                    .padding(.vertical)
                    
                    HStack {
                        VStack(alignment: .center, content: {
                            Text("4.3")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("avg texts / day".uppercased())
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                        })
                        Spacer()
                        VStack(alignment: .center, content: {
                            Text("+19%")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.green)
                            Text("this month".uppercased())
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                        })
                        Spacer()
                        VStack(alignment: .center, content: {
                            Text("12 hrs")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("last spoke".uppercased())
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                        })
                    }
                }
                .padding()
                .foregroundColor(Color.black.opacity(0.8))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            })
            .frame(width: 360)
        }
    }
}

struct BackgoundViewDemoPage_Previews: PreviewProvider {
    static var previews: some View {
        BackgoundViewDemoPage()
    }
}
