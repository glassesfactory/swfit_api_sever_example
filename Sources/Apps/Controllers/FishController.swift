import HTTP
import Vapor
import Fluent

final class FishController: ResourceRepresentable {
  func index(request: Request) throws -> ResponseRepresentable {
    return try Fish.query().sort("id", Sort.Direction.descending).all().makeNode().converted(to: JSON.self)
  }

  func create(request: Request) throws -> ResponseRepresentable {
    var fish = try request.fish()
    try fish.save()
    return fish
  }

  func show(request: Request, fish: Fish) throws -> ResponseRepresentable {
    return fish
  }

  func delete(request: Request, fish: Fish) throws -> ResponseRepresentable {
    try fish.delete()
    return JSON([:])
  }

  func clear(request: Request) throws -> ResponseRepresentable {
    try Fish.deleteAll()
    return JSON([])
  }

  func update(request: Request, fish: Fish) throws -> ResponseRepresentable {
    let new = try request.fish()
    var fish = fish
    fish.merge(updates: new)
    try fish.save()
    return fish
  }

  func replace(request: Request, fish: Fish) throws -> ResponseRepresentable {
    try fish.delete()
    return try create(request: request)
  }

  func makeResource() -> Resource<Fish> {
    return Resource(
      index: index,
      store: create,
      show: show,
      replace: replace,
      modify: update,
      destroy: delete,
      clear: clear
    )
  }
}

extension Request {
  func fish() throws -> Fish {
    guard let json = json else { throw Abort.badRequest }
    return try Fish(node: json)
  }
}
