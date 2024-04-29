//
//  ContentView.swift
//  MyOkashi
//
//  Created by 笠井翔雲 on 2024/04/29.
//

import SwiftUI

struct ContentView: View {
    //OkashiDataを参照する変数
    var okashiDataList = OkashiData()
    //入力された文字列を保持する状態変数
    @State var inputText = ""
    @State var isShowSafari = false
    var body: some View {
        TextField("キーワード",text: $inputText,
        prompt: Text("キーワードを入力してください"))
        .onSubmit {
            okashiDataList.searchOkashi(keyword: inputText)
        }
        //キーボードの改行を検索に変更する
        .submitLabel(.search)
        .padding()
        List(okashiDataList.okashiList){ okashi in
            
            Button{
                okashiDataList.okashiLink = okashi.link
                
                isShowSafari.toggle()
            }label: {
                HStack{
                    AsyncImage(url: okashi.image){ image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height:40)
                    }placeholder: {
                        //読み込み中はインジケーターを表示する
                        ProgressView()
                    }
                    Text(okashi.name)
                }
            }
        }
        .sheet(isPresented: $isShowSafari, content: {
            SafariView(url: okashiDataList.okashiLink!)
                .ignoresSafeArea(edges: [.bottom])
        })
    }
}

#Preview {
    ContentView()
}
