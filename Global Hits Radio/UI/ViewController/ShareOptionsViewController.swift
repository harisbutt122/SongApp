//
//  ShareOptionsViewController.swift
//  Global Hits Radio
//
//  Created by Macbook Pro on 4/7/20.
//  Copyright © 2020 Muhammad Haris Butt. All rights reserved.


//

import UIKit

class ShareOptionsViewController: UIViewController {
    @IBOutlet weak var historyTV: ContentSizedTableView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var whatsappView: UIView!
    @IBOutlet weak var twitterView: UIView!
    @IBOutlet weak var facebookView: UIView!
    
    var dataSource: [String]!
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyTV.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
                
//        self.setupUI()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI(){
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(self.EMAILTAP(_:)))
        emailView.addGestureRecognizer(emailTap)
        
        let facebookTap = UITapGestureRecognizer(target: self, action: #selector(self.FACEBOOKTAP(_:)))
        facebookView.addGestureRecognizer(facebookTap)
        
        let twitterTap = UITapGestureRecognizer(target: self, action: #selector(self.TWITTERTAP(_:)))
        twitterView.addGestureRecognizer(twitterTap)
        
        let whatsappTap = UITapGestureRecognizer(target: self, action: #selector(self.WHATSAPPTAP(_:)))
        emailView.addGestureRecognizer(whatsappTap)
    }
    
    @objc func EMAILTAP(_ sender: UITapGestureRecognizer? = nil) {
        self.shareAcitvity()
    }
    
    @objc func FACEBOOKTAP(_ sender: UITapGestureRecognizer? = nil) {
        self.shareAcitvity()
    }
    
    @objc func WHATSAPPTAP(_ sender: UITapGestureRecognizer? = nil) {
        self.shareAcitvity()
    }
    
    @objc func TWITTERTAP(_ sender: UITapGestureRecognizer? = nil) {
        self.shareAcitvity()
    }
    
    func shareAcitvity(){
        let myWebsite = NSURL(string:"https://globalhitsradio.com/")
        let shareAll = [ myWebsite]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension ShareOptionsViewController:  UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.historyTV.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = UIFont(name:"Poppins", size:11)
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        debugPrint("You tapped cell number \(indexPath.row).")
    }
    
}
