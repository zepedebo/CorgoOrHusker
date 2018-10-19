import Vapor

struct ImageList: Codable
{
    var images: [DogPic];
    var perRow: Int;
}

struct DogImage: Content {
    var image: Data
}



/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // "It works" page
    router.get { req ->  Future<View> in
        let images = GetPics()
        let t  = ImageList(images: images, perRow: 3)
        
        return try req.view().render("welcome", t)
    }
    
    router.post("upload") { req -> Future<Response> in
        return try req.content.decode(DogImage.self).map(to:  Response.self) { doggo in
            SavePic(pic: doggo.image)
            
            return req.redirect(to: "/")
        }
    }
    
    
    // Says hello
    router.get("hello", String.parameter) { req -> Future<View> in
        return try req.view().render("hello", [
            "name": req.parameters.next(String.self)
        ])
    }
}
