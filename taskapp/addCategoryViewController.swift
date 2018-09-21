import UIKit
import RealmSwift

class addCategoryViewController: UIViewController {
    
    var category: Category!
    var taskArray = try! Realm().objects(Task.self)
    let realm = try! Realm()
    var id: Int!
    
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBAction func addButton(_ sender: Any) {
        if self.categoryTextField!.text == "" {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let category = Category()
        let allCategories = try! Realm().objects(Category.self)
        if allCategories.count != 0 {
            category.id = allCategories.max(ofProperty: "id")! + 1
        }
        try! realm.write {
            category.category = self.categoryTextField.text!
            self.realm.add(category, update: true)
        }
        //performSegue(withIdentifier: "backInputviewController", sender: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
