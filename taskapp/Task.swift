import RealmSwift

class Task: Object {
    @objc dynamic var id       = 0
    @objc dynamic var title    = ""
    @objc dynamic var category = ""
    @objc dynamic var contents = ""
    @objc dynamic var date     = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
