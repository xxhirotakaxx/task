import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController,
                           UIPickerViewDelegate,
                           UIPickerViewDataSource {
    
    let realm = try! Realm()
    var categoryArray = try! Realm().objects(Category.self)
    var task: Task!
    
    let categoryPicker = UIPickerView()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func doneButton(_ sender: Any) {
        try! realm.write {
            self.task.title    = self.titleTextField.text!
            self.task.category = self.categoryTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date     = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        setNotification(task: task)
        performSegue(withIdentifier: "doneBack", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboad))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text    = task.title
        categoryTextField.text = task.category
        contentsTextView.text  = task.contents
        datePicker.date        = task.date
        
        categoryPicker.dataSource   = self
        categoryPicker.delegate     = self
        categoryTextField.inputView = categoryPicker
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.text    = task.title
        categoryTextField.text = task.category
        contentsTextView.text  = task.contents
        datePicker.date        = task.date
        
        categoryPicker.reloadAllComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCategory" {
            try! realm.write {
                self.task.title    = self.titleTextField.text!
                self.task.category = self.categoryTextField.text!
                self.task.contents = self.contentsTextView.text
                self.task.date     = self.datePicker.date
                self.realm.add(self.task, update: true)
            }
            let addCategoryViewController: addCategoryViewController = segue.destination as! addCategoryViewController
            addCategoryViewController.id = task.id
        }
    }
    
    @objc func dismissKeyboad() {
        view.endEditing(true)
    }
    
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知 OK")
        }
        
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row].category
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categoryArray[row].category
    }
}
