//
//  HomeView.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//

import SwiftUI

struct HomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var user = User.defaultUser
    @ObservedObject var setting = UserSetting.defaultSetting
    @State var showingSetting = false
    @State var modelID: IndexModel.ID? = nil
    private let isPreview: Bool
    private var trafficView: TrafficView?
    private var tdView: TdView?
    private var balanceView: BalanceView?
    private var ncovView: NcovView?
    private var myViews: [AnyView]?
    let viewTitle = UserSetting.viewShowingTitles
    let webURLs: [URL] = [.trafficURL, .tdURL, .balanceWebURL, .ncovWebURL]
    let webViewModel = WebViewModel()
    
    @Sendable func refreshAll() async {
        await User.defaultUser.login()
    }
    
    mutating func initialize() {
        trafficView = TrafficView(content: isPreview ? TrafficView_Previews.content : Traffic())
        tdView = TdView(content: isPreview ? TdView_Previews.content : TdLine())
        balanceView = BalanceView(content: Balance(isPreview: isPreview))
        ncovView = NcovView(content: Ncov(isPreview: isPreview))
        myViews = [AnyView(trafficView), AnyView(tdView), AnyView(balanceView), AnyView(ncovView)]
    }
    
    init(isPreview: Bool = false) {
        self.isPreview = isPreview
        initialize()
    }
    
    var body: some View {
        NavigationSplitView {
            List(setting.viewIndexModel, selection: $modelID) { model in
                Section {
                    Text(viewTitle[model.index]).font(.title2).frame(height: 35).bold(true).buttonStyle(StaticButtonStyle())
                    myViews![model.index].buttonStyle(StaticButtonStyle())
                }.buttonStyle(StaticButtonStyle())
            }
            .buttonStyle(StaticButtonStyle())
            .listStyle(GroupedListStyle())
            .navigationTitle("BUAA Tools")
        } detail: {
            if let modelID,
               let index = setting.viewIndexModel.first(where: {$0.id == modelID})?.index {
                if viewTitle[index] == "TD 次数：" && !setting.tdShowWebsite {
                    TdFullView(content: tdsToTdModels(value: tdView!.content.tdValue))
                } else {
                    WebView(webView: webViewModel.loadUrl(url: webURLs[index]))
                }
            } else {
                BackgoundView().opacity(0.8)
            }
        }
        .refreshable(action: refreshAll)
        .overlay(alignment: .topTrailing) {
            Button {
                showingSetting.toggle()
            } label: {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .scaledToFill()
                    .padding()
                    .frame(width: 50, height: 50)
                    .foregroundColor(colorScheme == .light ? .black : .white)
            }
        }
        .sheet(isPresented: $showingSetting) {
            modelID = nil
        } content: {
            SettingView(showingSetting: $showingSetting)
                .ignoresSafeArea(.all)
        }
        .alert(isPresented: $user.refreshError) {
            Alert(
                title: Text("刷新失败"),
                message: Text("刷新失败！请稍后再试！")
            )
        }
        .onChange(of: scenePhase) { value in
            if value == .active {
                Task { await self.refreshAll() }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isPreview: true).environment(\.colorScheme, .light)
    }
}
