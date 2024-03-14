//
//  ViewController.swift
//  My Reminder App
//
//  Created by R95 on 13/03/24.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var myTableOutlet: UITableView!
    
    var model = [MyReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableOutlet.dataSource = self
        myTableOutlet.delegate = self
        
    }
    
    @IBAction func didButtonTap() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController else {
            return
        }
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.complition = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date, identifer: "id_\(title)")
                self.model.append(new)
                self.myTableOutlet.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate)  , repeats: false)
                
                let request = UNNotificationRequest(identifier: "Some_Long_Id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("Somthing Was Wrong")
                    }
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true )
    }
    
    @IBAction func didButtonTest () {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge , .sound] , completionHandler: {success, error in
            if success {
                self.schduleTest()
            }
            else if error != nil {
                print("Error")
            }
        } )
    }
    
    func schduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "My Long Body. My Long Body. My Long Body. My Long Body. My Long Body."
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate)  , repeats: false)
        
        let request = UNNotificationRequest(identifier: "Some_Long_Id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("Somthing Was Wrong")
            }
        })
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableOutlet.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableOutlet.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyRemindersTableViewCell
        
        cell.textLabel?.text = model[indexPath.row].title
        
        let date = model[indexPath.row].date
        
        let formtter = DateFormatter()
        formtter.dateFormat = "MM, DD, YYYY at hh:mm a"
        
        cell.detailTextLabel?.text = formtter.string(from: date)
        
        return cell
    }
    
    
}

struct MyReminder {
    let title: String
    let date: Date
    let identifer: String
}
