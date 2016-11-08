import Vapor
import Fluent
import Foundation

struct Fish: Model {
  var id: Node?

  var weight: Float?
  var size: Float?
  var image: String?
  var latitude: Float?
  var longitude: Float?
  var created: Int?
  var updated: Int?
  var exists: Bool = false
}


extension Fish: NodeConvertible {
  init(node: Node, in context: Context) throws {
    id = node["id"]
    weight = node["weight"]?.float
    size = node["size"]?.float
    image = node["image"]?.string
    latitude = node["latitude"]?.float
    longitude = node["longitude"]?.float
    let date = Date()
    let time = Int(date.timeIntervalSince1970)
    created = node["created"]?.int ?? time
    updated = node["updated"]?.int ?? time
  }

  func makeNode(context: Context) throws -> Node {
    return try Node.init(node:
      [
        "id": id,
        "weight": weight,
        "size": size,
        "image": image,
        "latitude": latitude,
        "longitude": longitude,
        "created": created,
        "updated": updated
      ]
    )
  }
}


extension Fish: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create("fishs") { fishes in
      fishes.id()
      fishes.double("weight")
      fishes.double("size", optional: true)
      fishes.string("image", optional: true)
      fishes.double("latitude", optional: true)
      fishes.double("longitude", optional: true)
      fishes.int("created")
      fishes.int("updated")
    }
  }

  static func revert(_ databse: Database) throws {
    fatalError("unimplemented \(#function)")
  }
}


extension Fish {
  mutating func merge(updates: Fish) {
    id = updates.id ?? id
    weight = updates.weight
    size = updates.size ?? size
    image = updates.image ?? image
    latitude = updates.latitude ?? latitude
    longitude = updates.longitude ?? longitude
    created = updates.created
    updated = updates.updated
  }
}
