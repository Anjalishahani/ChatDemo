//
//  ViewController.swift
//  DemoChat
//
//  Created by Enterprise Mobility on 21/11/17.
//  Copyright © 2017 RIL. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData
let appDelegateInstance = UIApplication.shared.delegate as! AppDelegate
class ViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendBtnBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var txtWidthOfName: NSLayoutConstraint!
    var textArray = [NSManagedObject]()
    @IBOutlet weak var textView: UITextView!
    
    lazy var chats : NSFetchedResultsController<ChatData> =
        {
        let request : NSFetchRequest<ChatData> = ChatData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:"chatTime",ascending: true)]
        let chats = NSFetchedResultsController(fetchRequest : request , managedObjectContext: appDelegateInstance.persistentContainer.viewContext ,sectionNameKeyPath:nil,cacheName: nil)
        chats.delegate = self
        return chats
    }()
  @IBOutlet weak var   loader : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow,object: nil)
        
        center.addObserver(self,selector: #selector(keyboardWillHide(_:)),name: .UIKeyboardWillHide,object: nil)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 10
        
         loader.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do{
            try chats.performFetch()
            
            
        }
        catch let error as NSError
        {
            print("error fetching Data : \(error.localizedDescription)")
        }
        tableView.reloadData()
        scrollTableToLastIndex(animated: false)
    }
    @IBAction func sendMessage(_ sender: UIButton) {
      
        if textView.text.count > 0
        {
            save(data: textView.text)
          

          textView.text = ""
          tableView.contentOffset = CGPoint.init(x: 0, y: CGFloat.greatestFiniteMagnitude)
          textView.resignFirstResponder()
          txtWidthOfName.constant = 28

            DispatchQueue(label: "RandomMessage").async {
                sleep(UInt32(1.0))
                DispatchQueue.main.async {
                    self.save(data: self.randomString())
                }
            }
        }
    }
    func save(data: String)
    {
  
        let managedContext =
            appDelegateInstance.persistentContainer.viewContext
        
        let newChat = ChatData.newEntity(forContext: managedContext) as ChatData
        
        newChat.chat = data
        newChat.chatTime = Date().timeIntervalSince1970
      
        appDelegateInstance.saveContext()
    
    }
    fileprivate func scrollTableToLastIndex(animated:Bool)
    {
        let sectionCount = tableView.numberOfSections
        if sectionCount > 0
        {
            let rows = tableView.numberOfRows(inSection: sectionCount - 1)
            if rows > 0{
                let indexpath = IndexPath(row: rows - 1, section: sectionCount - 1)
                tableView.scrollToRow(at: indexpath, at: .top, animated: animated)
            }
            
        }
    }
}

extension ViewController
{
    func keyboardWillShow(_ notify : Notification)
    {
        if let keyboardFrame: NSValue = notify.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.textViewBottomConstraint.constant = keyboardHeight + 20
            self.sendBtnBottomConstraint.constant = keyboardHeight + 20
        }
        
    }
        
    func keyboardWillHide(_ notify : Notification)
    {
        self.textViewBottomConstraint.constant =  10
        self.sendBtnBottomConstraint.constant = 10
        loader.isHidden = true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.chats.sections?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let objects = self.chats.sections
        {
            let rows = objects[section].numberOfObjects
            return rows
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
        
        let chat =  chats.object(at: indexPath)
        
        if indexPath.row % 2 == 0
        {
            cell.labelInput.text = chat.chat

            cell.labelOutput.text = ""
        }
        else
        {
            cell.labelOutput.text = chat.chat

            cell.labelInput.text = ""
        }
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return CGFloat.leastNormalMagnitude
    }
    
    func textViewDidChange(_ textView: UITextView) {
       
        
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: 125.0))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: 125.0))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.view.updateConstraintsIfNeeded()
           txtWidthOfName.constant = newFrame.size.height + 16
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: {
            [weak self] in
            guard let `self` = self else {return}
            self.view.layoutIfNeeded()
        }, completion: nil)
     loader.isHidden = false
 
    }
    func randomString() -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< 20 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}

extension ViewController : NSFetchedResultsControllerDelegate
{
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       
            tableView.endUpdates()
          
        self.scrollTableToLastIndex(animated: true)
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
   
            tableView.beginUpdates()
      
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let indexPaths : (IndexPath?) -> [IndexPath] = {(indexPath) in
            if let path = indexPath {return [path]}
            else {return  [] }
        }
   
      
            switch type {
            case .insert:
                tableView.insertRows(at: indexPaths(newIndexPath), with: .automatic)
            case .delete:
                tableView.deleteRows(at: indexPaths(indexPath), with: .automatic)
            case .update:
                tableView.reloadRows(at: indexPaths(indexPath), with: .automatic)
            default:
                break
            }
        
        
        
        
    }
}

class TextCell : UITableViewCell
{
     @IBOutlet weak var labelInput: UILabel!
     @IBOutlet weak var labelOutput: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelInput.layer.cornerRadius = 10
        labelOutput.layer.cornerRadius = 10
    }
  
}


extension NSManagedObject
{
    @nonobjc public class func newEntity<T : NSManagedObject>(forContext context : NSManagedObjectContext) -> T
    {
        let entityName = String.init(describing: T.self)
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T else {fatalError("NO Enity of this \(entityName) is available")}
        return entity
    }
}

