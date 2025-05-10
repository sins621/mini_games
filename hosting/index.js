import express from "express";
import path from "path";
import { fileURLToPath } from "url";
import { WebSocketServer, WebSocket } from "ws";
import morgan from "morgan";
import http from "http";
import { parse } from "url";

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
app.use(
  "/game/multiplayer_test",
  express.static(path.join(__dirname, "public", "multiplayer_test"))
);

const server = http.createServer(app);
const wss = new WebSocketServer({ noServer: true });
let ball_x = 0;
let ball_y = 0;
let p1_pos = 0;
let p2_pos = 0;
let direction_x = 2;
let direction_y = 0;

server.on("upgrade", (req, socket, head) => {
  socket.on("error", onSocketPreError);

  const { pathname } = parse(req.url);

  if (pathname === "/game/multiplayer_test") {
    socket.on("error", onSocketPreError);
  }

  wss.handleUpgrade(req, socket, head, (ws) => {
    socket.removeListener("error", onSocketPreError);
    wss.emit("connection", ws, req);
    console.log("Client Connected");
    ball_x = 160;
    ball_y = 90;
    p1_pos = 75;
    p2_pos = 75;
    direction_x = 2;
    direction_y = 0;
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
  ball_x += direction_x;
  ball_y += direction_y;

  if (ball_x > 290) {
    if (ball_y > p2_pos - 10 && ball_y < p2_pos + 30) {
      direction_x *= -1;
      direction_y -= (ball_y - p2_pos + 16.5) * 0.05;
    }
  }

  if (ball_x < 20) {
    if (ball_y > p1_pos - 10 && ball_y < p1_pos + 30) {
      direction_x *= -1;
      direction_y -= (ball_y - p1_pos + 16.5) * 0.05;
    }
  }

  if (ball_y > 180 || ball_y < 0) {
    direction_y *= -1;
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
