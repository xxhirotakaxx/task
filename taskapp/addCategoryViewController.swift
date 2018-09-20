import UIKit
import RealmSwift

class addCategoryViewController: UIViewController {
    
    var category: Category!
    var taskArray = try! Realm().objects(Task.self)
    let realm = try! Realm()
    var id: Int!
    
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBAction func addButton(_ sender: Any) {
        let category = Category()
        let allCategories = try! Realm().objects(Category.self)
        if allCategories.count != 0 {
            category.id = allCategories.max(ofProperty: "id")! + 1
        }
        try! realm.write {
            category.category = self.categoryTextField.text!
            self.realm.add(category, update: true)
        }
        performSegue(withIdentifier: "backInputviewController", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        for task in taskArray {
            if task.id == id {
                let inputViewController: InputViewController = segue.destination as! InputViewController
                inputViewController.task = task
            }
        }
    }

}
