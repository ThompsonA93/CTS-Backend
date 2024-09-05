FROM rust:latest

COPY . .
RUN cargo install --path .
EXPOSE 8080

CMD ["cargo", "run"]