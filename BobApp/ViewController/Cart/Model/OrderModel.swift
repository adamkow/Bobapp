import Foundation

struct OrderModel {
    // store dictionary format.
    var productName: String!
    var sizeType: String!
    var uid: String!
    var milkType : String!
    var qty : String!
    var sugarType : String!
    var topping : String!
    var userId : String!

    init(uid: String, fromDictionary dictionary: [String:Any]) {
        self.uid = uid
        milkType = dictionary["MilkType"] as? String
        qty = dictionary["Qty"] as? String
        sugarType = dictionary["SugarType"] as? String
        topping = dictionary["Topping"] as? String
        userId = dictionary["userId"] as? String
        productName = dictionary["ProductName"] as? String
        sizeType = dictionary["SizeType"] as? String
    }

    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if milkType != nil{
            dictionary["MilkType"] = milkType
        }
        if qty != nil{
            dictionary["Qty"] = qty
        }
        if sugarType != nil{
            dictionary["SugarType"] = sugarType
        }
        if topping != nil{
            dictionary["Topping"] = topping
        }
        if userId != nil{
            dictionary["userId"] = userId
        }
        if productName != nil{
            dictionary["ProductName"] = productName
        }
        if sizeType != nil{
            dictionary["SizeType"] = sizeType
        }
        return dictionary
    }

}
