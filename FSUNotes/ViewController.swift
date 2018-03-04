//
//  ViewController.swift
//  FSUNotes
//
//  Created by Jessica Moreno on 3/3/18.
//  Copyright © 2018 Jessica Moreno. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var table: UITableView!
    var data:[String] = []
    var selectedRow:Int = -1
    var newRowText:String = ""
    
    var fileURL:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table.dataSource = self
        table.delegate = self
        
        self.title = "Notes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        //adds add button
        self.navigationItem.rightBarButtonItem = addButton
        //adds edit button
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        
        let baseURL  = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
       fileURL = baseURL.appendingPathComponent("notes.txt")
        load()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if selectedRow == -1 {
            return
        }
        data[selectedRow] = newRowText
        if newRowText == "" {
            
            data.remove(at: selectedRow)
        }
        table.reloadData()
        save()
    }
    
    @objc func addNote(){
        //doesnt let you add notes when editing
        if table.isEditing{
            
            return
        }
        //adjust data array
        let name:String = ""
        data.insert(name, at: 0)
        
        //show animation for table view
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
         self.view.backgroundColor = UIColor(red: 72/255, green: 209/255, blue: 204/255, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //not recommended by apple
        //let cell: UITableViewCell = UITableViewCell()
        //more optimized version because of the reused identifier
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
         self.view.backgroundColor = UIColor(red: 72/255, green: 209/255, blue: 204/255, alpha: 1)
        return cell
    }
    //adds actual ability to edit
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    //ability to delete when editing
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
         self.view.backgroundColor = UIColor(red: 72/255, green: 209/255, blue: 204/255, alpha: 1)
        save()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("\(data[indexPath.row])")
        self.performSegue(withIdentifier: "detail", sender: nil)
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:DetailViewController = segue.destination as! DetailViewController
        selectedRow = table.indexPathForSelectedRow!.row
        
        detailView.masterView = self
        detailView.setText(t: data[selectedRow])
    }
    func save(){
       // UserDefaults.standard.set(data, forKey: "notes")
        //save to a file
        let a = NSArray(array: data)
        do {
            try a.write(to: fileURL)
        } catch {
            print("error writing file")
        }
        
        
    }
    
    func load(){
        //writing to file
        if let loadedData:[String] = NSArray(contentsOf:fileURL) as? [String]{
            data = loadedData
            table.reloadData()
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

