//
//  OkashiData.swift
//  MyOkashi
//
//  Created by 笠井翔雲 on 2024/04/29.
//

import SwiftUI

struct OkashiItem : Identifiable{
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}
//お菓子データ検索用クラス
@Observable class OkashiData{
    //JSONのitem内のデータ構造
    struct ResultJson: Codable{
        struct Item: Codable{
            let name: String?
            
            let url: URL?
            
            let image: URL?
        }
        let item: [Item]?
    }
    var okashiList: [OkashiItem] = []
    
    var okashiLink: URL?
    //Web Api検索用メソッド　第一引数:keyword　検索したいワード
    func searchOkashi(keyword: String){
        print("searchOkashiメソッドで受け取った値：\(keyword)")
        
        //Taskは非同期で処理を実行できる
        Task{
            //ここから先は非同期で処理される
            await search(keyword: keyword)
        }
    }
    @MainActor
    private func search(keyword: String) async{
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)else{
            return
        }
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r")else{
            return
        }
        print(req_url)
        
        do{
            //リクエストURLからダウンロード
            let(data, _) = try await URLSession.shared.data(from: req_url)
            //JSONDecoderのインスタンス取得
            let decoder = JSONDecoder()
            //受け取ったJSONデータをパース(解析）して格納
            let json = try decoder.decode(ResultJson.self, from:data)
//            print(json)
            guard let items = json.item else{ return }
            
            okashiList.removeAll()
            
            for item in items {
                if let name = item.name,
                   let link = item.url,
                   let image = item.image {
                    
                    let okashi = OkashiItem(name: name, link: link, image: image)
                    
                    okashiList.append(okashi)
                }
            }
            print(okashiList)
        } catch{
            print("エラーが出ました")
        }
    }
}
