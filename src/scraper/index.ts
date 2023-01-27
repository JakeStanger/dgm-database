import fetch from "node-fetch";
import $ from "cheerio";
import prisma from "../prisma";
import parseShow from "./parser";
import { range } from "lodash";
import { DateTime } from "luxon";
import * as logger from "../utils/logger";

const BASE_URL = "https://www.dgmlive.com";

async function getMostRecentTour() {
  const URL = BASE_URL + "/tours?order=recently-added";

  const page = await fetch(URL).then((r) => r.text());

  const firstShowSelector =
    "div.tour-date-row:nth-child(1) > div:nth-child(1) > div:nth-child(3) > a:nth-child(1)";
  const url = $(firstShowSelector, page).attr("href");

  if (!url) {
    throw new Error("Failed to find most recent tour");
  }

  const id = /\/(\d+)$/.exec(url.trim())?.[1];

  if (!id) {
    throw new Error("Failed to parse URL for most recent tour");
  }

  return parseInt(id);
}

async function fetchShow(id: number) {
  const url = BASE_URL + `/tour-dates/${id}`;
  const res = await fetch(url);

  if (res.status === 200) {
    return res.text();
  } else {
    return null;
  }
}

export async function sync() {
  logger.log("sync", "Starting sync");

  const startTime = new Date();

  const upperBound = await getMostRecentTour();

  const prevSync = await prisma.tourSync.findFirst({
    orderBy: { date: "desc" },
  });

  if (!prevSync || upperBound > prevSync.upperBound) {
    const ids = range((prevSync?.upperBound || 0) + 1, upperBound + 1);
    for (const id of ids) {
      process.stdout.write(`[${id}/${ids[ids.length - 1]}] `);

      const existing = await prisma.show.findFirst({ where: { id } });
      if (existing) {
        logger.log("sync", "Already fetched");
        continue;
      }

      const html = await fetchShow(id);

      // ignore 404s
      if (!html) {
        logger.log("sync", "Not found");
        continue;
      }

      const data = await parseShow(html, id);

      logger.log(
        "sync",
        `${data.venue} ${data.location} ${
          data.date ? DateTime.fromJSDate(data.date).toISODate() : ""
        }`
      );

      const show = await prisma.show
        .create({
          data: {
            ...data,
            tracks: {
              create: data.tracks.map((track) => ({
                track: {
                  connectOrCreate: {
                    where: { name: track.title },
                    create: { name: track.title },
                  },
                },
                index: track.index,
                length: track.length,
              })),
            },
            members: {
              create: data.members.map((member) => ({
                member: {
                  connectOrCreate: {
                    where: { name: member.name },
                    create: { name: member.name },
                  },
                },
                instruments: member.instruments,
              })),
            },
          },
        })
        .catch((e) => {
          return;
        });

      if (!show) {
        continue;
      }

      // wait for 0.5s so we don't hammer the DGM servers
      await new Promise((resolve) => setTimeout(resolve, 500));
    }

    await prisma.tourSync.create({
      data: { date: startTime, lowerBound: ids[0], upperBound },
    });

    logger.log("sync", "Sync complete");
  } else {
    logger.log("sync", "Nothing to sync");
  }
}
