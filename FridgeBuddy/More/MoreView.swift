//
//  MoreView.swift
//  FridgeBuddy
//
//  Created by Inderdeep on 2022-10-28.
//

import SwiftUI
import WebKit

struct MoreView: View {
    @StateObject var moreViewModel = MoreViewModel()
    @EnvironmentObject var launchViewModel : LaunchViewModel
    @State private var showWebView : Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                Text(moreViewModel.name)
                    .padding(.vertical, 10.0)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.green, lineWidth: 2))
                    .padding(.top)
                
                Button {
                    showWebView.toggle()
                } label: {
                    Text("Show Tips")
                }
                .sheet(isPresented: $showWebView) {
                    if #available(iOS 16.0, *){
                        WebView(url: URL(string: "https://stilltasty.com/fooditems/index/16451")!)
                            .presentationDetents([.fraction(0.85)])
                    }
                    else{
                        WebView(url: URL(string: "https://stilltasty.com/fooditems/index/16451")!)
                    }
                    
                }
                
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

