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
let ball_x = 0;
let ball_y = 0;
let p1_pos = 0;
let p2_pos = 0;
let direction = 2;

server.on("upgrade", (req, socket, head) => {
  socket.on("error", onSocketPreError);

  wss.handleUpgrade(req, socket, head, (ws) => {
    socket.removeListener("error", onSocketPreError);
    wss.emit("connection", ws, req);
    console.log("Client Connected");
    ball_x = 160;
    ball_y = 90;
    p1_pos = 0;
    p2_pos = 0;
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
    const message = JSON.parse(msg.toString());
    p1_pos += message.client?.p1_y * 100 * message.client?.delta;
    p2_pos += message.client?.p2_y * 100 * message.client?.delta;
  });

  ws.on("close", () => {
    console.log("Connection Closed");
  });
});

function broadcast(data) {
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(data);
    }
  });
}

setInterval(() => {
  ball_x += direction;
  if (ball_x > 280 || ball_x < 20) {
    direction *= -1;
  }
  const message = JSON.stringify({
    server: {
      ball_x,
      ball_y,
      p1_pos,
      p2_pos,
    },
  });
  broadcast(message);
}, 16.66);

server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
