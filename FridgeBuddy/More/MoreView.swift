//
//  MoreView.swift
//  FridgeBuddy
//
//  Created by Inderdeep on 2022-10-28.
//

import SwiftUI
import WebKit

struct TipsUrl: Identifiable, Hashable{
    var id = UUID()
    var name : String = ""
    var url : String = ""
}

struct MoreView: View {
    @StateObject var moreViewModel = MoreViewModel()
    @EnvironmentObject var launchViewModel : LaunchViewModel
    @State private var showWebView : Bool = false

    @State private var tipurl = TipsUrl(name: "Banana", url :"https://stilltasty.com/fooditems/index/16451")
    private var TipsURLS = [TipsUrl(name: "Banana", url :"https://stilltasty.com/fooditems/index/16451"),
                            TipsUrl(name: "Apple", url :"https://stilltasty.com/fooditems/index/16383"),
                            TipsUrl(name: "Eggs", url :"https://stilltasty.com/fooditems/index/17144"),
                            TipsUrl(name: "Milk", url :"https://stilltasty.com/fooditems/index/17687"),
                            TipsUrl(name: "Bell Pepper", url :"https://stilltasty.com/fooditems/index/16523")]
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Hello, \(moreViewModel.name)!")
                    .padding(.vertical, 10.0)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.green, lineWidth: 2))
                    .padding(.top)
                
                List(TipsURLS) { t in
                    Button {
                        tipurl = t
                        showWebView.toggle()
                    } label: {
                        Text("See Tips for \(t.name)")
                    }
                    .sheet(isPresented: $showWebView) {
                        if #available(iOS 16.0, *){
                            WebView(url: URL(string: tipurl.url)!)
                                .presentationDetents([.fraction(0.85)])
                        }
                        else{
                            WebView(url: URL(string: tipurl.url)!)
                        }
                    }
                }.navigationTitle("Tips and Tricks")
                
                Button {
                    moreViewModel.signOut()
                    launchViewModel.checkLogin()
                } label: {
                    ButtonView(buttonText: "Sign Out")
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            moreViewModel.getName()
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

