FROM rust:latest as core

COPY . .
RUN cargo install --path .
EXPOSE 8080

CMD ["cargo", "run"]