use actix_web::{web, App, HttpResponse, HttpServer};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| App::new().route("/ping", web::get().to(HttpResponse::Ok)))
        .bind(("0.0.0.0", 8080))?
        .run()
        .await
}