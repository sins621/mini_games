import express from "express";
import path from "path";
import { fileURLToPath } from "url";
import { WebSocketServer, WebSocket } from "ws";
import morgan from "morgan";
import http from "http";

const app = express();
const PORT = process.env.PORT || 5004;
app.use(morgan("tiny"));

function onSocketPreError(e) {
  console.log(e);
}

function onSocketPostError(e) {
  console.log(e);
}

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.use(express.static(path.join(__dirname, "public")));

app.use("/game/pong", express.static(path.join(__dirname, "public", "pong")));
app.use("/game/snake", express.static(path.join(__dirname, "public", "snake")));
app.use(
  "/game/space_invaders",
  express.static(path.join(__dirname, "public", "space_invaders"))
);

const server = http.createServer(app);
const wss = new WebSocketServer({ noServer: true });

server.on("upgrade", (req, socket, head) => {
  socket.on("error", onSocketPreError);

  wss.handleUpgrade(req, socket, head, (ws) => {
    socket.removeListener("error", onSocketPreError);
    wss.emit("connection", ws, req);
  });
});

wss.on("connection", (ws, req) => {
  ws.on("error", onSocketPostError);

  ws.on("message", (msg, isBinary) => {
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(msg, { binary: isBinary });
      }
    });
  });

  ws.on("close", () => {
    console.log("Connection Closed");
  });
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
