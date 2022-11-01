//
//  RecipeWebView.swift
//  FridgeBuddy
//
//  Created by vmadmin on 2022-11-01.
//

import SwiftUI
import WebKit

struct RecipeWebView: UIViewRepresentable {
    let url : URL
    
    func makeUIView(context: UIViewRepresentableContext<RecipeWebView>) -> WKWebView {
        let webView = WKWebView()
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        webView.load(request)
    }
}
