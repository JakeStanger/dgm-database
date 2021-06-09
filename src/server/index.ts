import express from "express";
import * as logger from "../utils/logger";
import prisma from "../prisma";

const app = express();

app.get("/", (req, res) => {
  return res.send("dgm api");
});

app.get("/show", async (req, res) => {
  const shows = await prisma.show.findMany({ orderBy: { date: "desc" } });

  return res.json({ data: shows });
});

app.get("/show/:id", async (req, res) => {
  const id = parseInt(req.params.id);

  const show = await prisma.show.findUnique({
    where: { id },
    include: {
      tracks: {
        orderBy: { index: "asc" },
        select: { id: true, index: true, length: true, track: true },
      },
      members: { select: { id: true, member: true, instruments: true } },
    },
  });

  return res.json({ data: show });
});

app.get("/track", async (req, res) => {
  const tracks = await prisma.track.findMany({
    where: { primaryTrack: true },
    orderBy: { name: "asc" },
  });

  return res.json({ data: tracks });
});

app.get("/track/:id", async (req, res) => {
  const track = await prisma.track.findUnique({
    where: { id: parseInt(req.params.id) },
    include: { album: true },
  });

  return res.json({ data: track });
});

app.listen(process.env.PORT || 3000, () => {
  logger.log("http", `Server ready on port ${process.env.PORT || 3000}`);
});
