//
//  CapsuleProgressViewStyle.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//
//  Thanks for the tutorial from https://www.jianshu.com/p/99dd4e2c4ae2
//

import SwiftUI

struct CapsuleProgressViewStyle: ProgressViewStyle {
    let showPercentage : Bool
    let additionalLabel : String?
    let textColor : Color
    let progressColor : Color
    
    init(
        showPercentage: Bool = true,
        additionalLabel: String? = nil,
        textColor: Color = .secondary,
        progressColor: Color = .accentColor
    ) {
        self.showPercentage = showPercentage
        self.additionalLabel = additionalLabel
        self.textColor = textColor
        self.progressColor = progressColor
    }
    
    public func makeBody(configuration: LinearProgressViewStyle.Configuration) -> some View {
        VStack {
            configuration.label
                .foregroundColor(Color.secondary)
            
            GeometryReader { metric in
                ZStack {
                    Capsule()
                        .opacity(0.3)
                        .foregroundColor(progressColor.opacity(0.5))
                    
                    Capsule()
                        .size(width: metric.size.width * (configuration.fractionCompleted ?? 0), height: metric.size.height)
                        .foregroundColor(progressColor)
                    
                    additionalLabel != nil || showPercentage ?
                    AnyView(
                        Text((additionalLabel ?? "") + (showPercentage ? "\(Int((configuration.fractionCompleted ?? 0) * 100)) %" : ""))
                        .font(.headline)
                        .foregroundColor(textColor)
                    ) : AnyView(EmptyView())
                }
            }
        }
    }
}

struct CapsuleDemoPageView: View {
    
    @State private var doubleAmount = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                ProgressView("Downloading...", value: doubleAmount, total: 100)
                    .progressViewStyle(CapsuleProgressViewStyle(
                        showPercentage: true,
                        additionalLabel: "Progress: ",
                        textColor: .purple,
                        progressColor: .gray
                    ))
                    .frame(height: 70, alignment: .center)
                    .padding()
                
                Button(action: {
                    withAnimation {
                        if doubleAmount < 100 {
                            doubleAmount += 5
                        }
                    }
                },label: {
                    Text("+5%").foregroundColor(.primary)
                })
            }
            .navigationBarTitle("ProgressView",displayMode: .inline)
        }
    }
}

struct CapsuleDemoPageView_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleDemoPageView().environment(\.colorScheme, .light)
    }
}
