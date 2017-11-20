//
//  ViewController.swift
//  sampleCoreData
//
//  Created by Eriko Ichinohe on 2017/11/20.
//  Copyright © 2017年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CoreDataからDataを読み込む処理
        read()
        
    }
    
    //すでに存在するデータの読み込み処理
    func read(){
        
        //AppDelegateを使う用意をしておく
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        
        //どのエンティティからデータを取得してくるか設定（ToDoエンティティ）
        let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        
        do{
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
        
            //きちんと保存できてるか、一行ずつ表示（デバッグエリア）
            for result: AnyObject in fetchResults {
                let title :String? = result.value(forKey:"title") as? String
                let saveDate :Date? = result.value(forKey:"saveDate") as? Date

                print("title:\(title!) saveDate:\(saveDate!)")
            }
        
        }catch{
            
        }
        
        
        
        
    }

    //リターンキーが押されたとき発動
    @IBAction func tapReturn(_ sender: UITextField) {
    }
    
    //追加ボタンが押されたとき発動
    @IBAction func tapSave(_ sender: UIButton) {
        //AppDelegateを使う用意をしておく（インスタンス化）
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //ToDoエンティティオブジェクトを作成
        let ToDo = NSEntityDescription.entity(forEntityName: "ToDo", in: viewContext)
        
        //ToDoエンティティにレコード（行）を挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)
        
        //値のセット
        newRecord.setValue(txtTitle.text, forKey: "title")  //title列に文字をセット
        newRecord.setValue(Date(), forKey: "saveDate")      //saveDate列に現在日時をセット
        
        //レコード（行）の即時保存
        do{
            try viewContext.save()
        } catch{
            //エラーが発生したときに行う例外処理を書いておく場所
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

