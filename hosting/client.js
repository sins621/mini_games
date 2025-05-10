import WebSocket from "ws";

const PORT = process.env.PORT || 5004;

const ws = new WebSocket(`ws://localhost:${PORT}`);

ws.addEventListener("error", (e) => {
  console.log(e);
});

ws.addEventListener("open", () => {
  console.log("Web Socket Connection Open");
});

ws.addEventListener("close", () => {
  console.log("Web Socket Connection Closed");
});

ws.addEventListener("message", (msg) => {
  console.log(msg);
});
