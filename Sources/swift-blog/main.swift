import CloudFoundryEnv
import Configuration
import Foundation
import HeliumLogger
import Kitura
import KituraStencil

HeliumLogger.use()

private let configuration = ConfigurationManager().load(.environmentVariables)

private let blogPosts: [BlogPost] = {
    let url = URL(fileURLWithPath: ConfigurationManager.BasePath.pwd.path + "/posts.json")
    let data = try! Data(contentsOf: url)
    return try! JSONDecoder().decode(Array<BlogPost>.self, from: data)
}()

private let router = Router()
router.setDefault(templateEngine: StencilTemplateEngine())

router.all("public", middleware: StaticFileServer())

router.get("/") {
    request, response, next in
    try response.render("index", context: [:])
    next()
}

router.get("books") {
    request, response, next in
    try response.render("books", context: [:])
    next()
}

router.get("about") {
    request, response, next in
    try response.render("about", context: [:])
    next()
}

router.get("blog") {
    request, response, next in
    try response.render("blog", with: blogPosts, forKey: "posts")
    next()
}

router.get("blog/:name") {
    request, response, next in
    let name = request.parameters["name"]!
    guard !name.hasSuffix(".html") else {
        /*
         Forward requests for 'post.html' to 'post'.
         This code is included to remain backwards compatible with existing links that include the extension.
         */
        let extensionIndex = name.index(name.endIndex, offsetBy: -5)
        let trimmedName = name[..<extensionIndex]
        try response.redirect("/blog/\(trimmedName)", status: .movedPermanently)
        return next()
    }
    guard let post = blogPosts.first(where: { $0.name == name }) else {
        response.statusCode = .notFound
        return next()
    }
    try response.render("blog/\(name)", with: post, forKey: "post")
    next()
}

Kitura.addHTTPServer(onPort: configuration.port, with: router)
Kitura.run()
