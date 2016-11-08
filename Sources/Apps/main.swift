import URI
import HTTP
import Vapor
import VaporMySQL

let drop = Droplet(
  availableMiddleware: ["cors": CorsMiddleware()],
  serverMiddleware: ["file", "cors"],
  preparations: [Fish.self],
  providers: [VaporMySQL.Provider.self]
)

drop.get { _ in try drop.view.make("welcome") }

drop.grouped(FishURLMiddleware()).resource("fishs", FishController())

drop.run()
