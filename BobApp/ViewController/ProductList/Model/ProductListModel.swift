import Foundation
import SwiftyJSON

class Category : NSObject, NSCoding{
    
    var categoryId : Int!
    var categoryName : String!
    var productType: String!
    var isSelected: Bool = false
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        categoryId = json["CategoryId"].intValue
        categoryName = json["CategoryName"].stringValue
        productType = json["ProductType"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if categoryId != nil{
            dictionary["CategoryId"] = categoryId
        }
        if categoryName != nil{
            dictionary["CategoryName"] = categoryName
        }
        if productType != nil{
            dictionary["ProductType"] = productType
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryId = aDecoder.decodeObject(forKey: "CategoryId") as? Int
        categoryName = aDecoder.decodeObject(forKey: "CategoryName") as? String
        productType = aDecoder.decodeObject(forKey: "ProductType") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: "CategoryId")
        }
        if categoryName != nil{
            aCoder.encode(categoryName, forKey: "CategoryName")
        }
        if productType != nil{
            aCoder.encode(productType, forKey: "ProductType")
        }
    }
}

import Foundation
import SwiftyJSON

class ProductList : NSObject, NSCoding{
    
    var categoryId : Int!
    var productId : Int!
    var productImage : String!
    var productName : String!
    var productType: String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        categoryId = json["CategoryId"].intValue
        productId = json["ProductId"].intValue
        productImage = json["ProductImage"].stringValue
        productName = json["ProductName"].stringValue
        productType = json["ProductType"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if categoryId != nil{
            dictionary["CategoryId"] = categoryId
        }
        if productId != nil{
            dictionary["ProductId"] = productId
        }
        if productImage != nil{
            dictionary["ProductImage"] = productImage
        }
        if productName != nil{
            dictionary["ProductName"] = productName
        }
        if productType != nil{
            dictionary["ProductType"] = productType
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryId = aDecoder.decodeObject(forKey: "CategoryId") as? Int
        productId = aDecoder.decodeObject(forKey: "ProductId") as? Int
        productImage = aDecoder.decodeObject(forKey: "ProductImage") as? String
        productName = aDecoder.decodeObject(forKey: "ProductName") as? String
        productType = aDecoder.decodeObject(forKey: "ProductType") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: "CategoryId")
        }
        if productId != nil{
            aCoder.encode(productId, forKey: "ProductId")
        }
        if productImage != nil{
            aCoder.encode(productImage, forKey: "ProductImage")
        }
        if productName != nil{
            aCoder.encode(productName, forKey: "ProductName")
        }
        if productType != nil{
            aCoder.encode(productType, forKey: "ProductType")
        }
        
    }
    
}
