//
//  DetailViewController.swift
//  sampleCoreData
//
//  Created by Eriko Ichinohe on 2017/11/23.
//  Copyright © 2017年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    var selectedSaveDate:Date = Date()
    var contentTitle:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(selectedSaveDate)
    
        read()
    }
    
    //すでに存在するデータの読み込み処理
    func read(){
        
        //一旦空にする（初期化）
        contentTitle = []
        //AppDelegateを使う用意をしておく
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        
        //どのエンティティからデータを取得してくるか設定（ToDoエンティティ）
        let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        //絞り込み検索(ここを追加!！！！！)---------------------------------------
        //絞込の条件　saveDate = %@ のsaveDateはattribute名
        let saveDatePredicate = NSPredicate(format: "saveDate = %@", selectedSaveDate as CVarArg)
        query.predicate = saveDatePredicate
        
        //------------------------------------------------------------------
        
        
        do{
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //きちんと保存できてるか、一行ずつ表示（デバッグエリア）
            for result: AnyObject in fetchResults {
                let title :String? = result.value(forKey:"title") as? String
                let saveDate :Date? = result.value(forKey:"saveDate") as? Date
                
                print("絞り込んだ結果")
                print("title:\(title!) saveDate:\(saveDate!)")
                
                var dic = ["title":title,"saveDate":saveDate] as [String : Any]
                
                contentTitle.append(dic as NSDictionary)
                
            }
            
        }catch{
            
        }
        
        
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
