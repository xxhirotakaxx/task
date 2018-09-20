import RealmSwift

class Category: Object {
    @objc dynamic var id       = 0
    @objc dynamic var category = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
