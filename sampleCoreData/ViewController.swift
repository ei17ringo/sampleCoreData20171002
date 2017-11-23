//
//  ViewController.swift
//  sampleCoreData
//
//  Created by Eriko Ichinohe on 2017/11/20.
//  Copyright © 2017年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import CoreData

//プロトコル追加
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var todoTableView: UITableView!
    
    //TODO（内容）を格納する配列 TableView 表示用
    var contentTitle:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CoreDataからDataを読み込む処理
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
        
        
        do{
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
        
            //きちんと保存できてるか、一行ずつ表示（デバッグエリア）
            for result: AnyObject in fetchResults {
                let title :String? = result.value(forKey:"title") as? String
                let saveDate :Date? = result.value(forKey:"saveDate") as? Date

                print("title:\(title!) saveDate:\(saveDate!)")
                
                var dic = ["title":title,"saveDate":saveDate] as [String : Any]
                
                contentTitle.append(dic as NSDictionary)
                
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
        
        //CoreDataからDataを読み込む処理
        read()
        
        //TableView再読込
        todoTableView.reloadData()
    }
    
    //全削除ボタンが押されたとき
    @IBAction func tapDelete(_ sender: UIButton) {
        
        //AppDelegate使う用意をする（インスタンス化）
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
         let viewContext = appDelegate.persistentContainer.viewContext
        
        //どのエンティティからデータを取得してくるか設定（ToDoエンティティ）
        let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        
        do{
            //削除するデータを取得（今回はすべて取得）
            let fetchResults = try viewContext.fetch(query)
            
            //一行ずつ(取り出した上で)削除
            for result:AnyObject in fetchResults{
                
                //削除処理を行うために型変換
                let record = result as! NSManagedObject
                viewContext.delete(record)
            }
            
            //削除した状態を保存
            try viewContext.save()
            
        }catch{
            
        }
        
        //再読込
        read()
        todoTableView.reloadData()
        
    }
    
    
    // MARK:TableView用処理
    
    // 行数の決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if tableView.tag == 1 {
////            return 10
//        }else{
            return contentTitle.count
//        }
    }
    
    //リストに表示する文字列を決定し、表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //文字列を表示するセルの取得（セルの再利用）
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! customCell
        
        //表示したい文字の設定
        //        cell.textLabel?.text = "\(indexPath.row)行目"
//        cell.textLabel?.text = contentTitle[indexPath.row]
        
        var dic = contentTitle[indexPath.row] as! NSDictionary
        cell.todoLabel.text = dic["title"] as! String
        
        //画像
        cell.statusImageView.image = UIImage(named:"sample.png")
        
        //日付を文字列に変換
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        
        //時差補正（日本時間に変更）
        df.locale = NSLocale(localeIdentifier: "ja_JP") as! Locale!
        
        cell.saveDateLabel.text = df.string(from: dic["saveDate"] as! Date)
        //文字を設定したセルを返す
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

