import cheerio from "cheerio";
import { DateTime, Duration } from "luxon";
import normalizeInstrument from "./normalize/normalizeInstrument";
import normalizeTrack from "./normalize/normalizeTrack";

function getLocation($: cheerio.Root) {
  let locationBox = $(".content-past").first();
  if (!locationBox) {
    locationBox = $(".content.col-xs-7.col-xs-7").first();
  }

  const venue = locationBox.find("a p:nth-child(1)").text();
  const location = locationBox.find("a p:nth-child(2)").text();

  return [venue, location];
}

function getDate($: cheerio.Root) {
  const dateBox = $(".date-box").first();

  if (!dateBox) {
    return;
  }

  const day = dateBox.find(".part-left").text();
  const month = dateBox.find(".part-right div:nth-child(1)").text();
  const year = dateBox.find(".part-right div:nth-child(2)").text();

  return DateTime.fromFormat(
    `${day} ${month} ${year}`,
    "dd MMM yyyy"
  ).toJSDate();
}

function getQuality($: cheerio.Root) {
  const qualityRatingImage =
    "https://www.dgmlive.com/img/assets/albums//audio-rating-white.png";

  return $(`img[src='${qualityRatingImage}']`).length;
}

function getAudioSource($: cheerio.Root) {
  const container = $("#audio-source");
  if (container) {
    return container.contents().get(1)?.nodeValue.trim();
  }
}

function getDescription($: cheerio.Root) {
  const node = $("#description");

  if (!node) {
    return;
  }

  return node.text().trim();
}

function getMembers(
  $: cheerio.Root
): { name: string; instruments: string[] }[] {
  const membersContainer = $(".members-list ul").first();
  const members = membersContainer.find("li > a");

  return members
    .map((i, member) => {
      const text = $(member).text().split("-");

      const name = text[0].trim();
      const instruments =
        text[1]
          ?.trim()
          .split(/[,.]+/)
          .map(normalizeInstrument)
          .filter((i) => i) || [];

      return {
        name,
        instruments,
      };
    })
    .get();
}

function getTracks(
  $: cheerio.Root
): { title: string; index: number; length: number }[] {
  const tracks = $(".album-content-line");

  return tracks
    .map((i, row) => {
      const rowEl = $(row);

      const index = parseInt(rowEl.find(".track-number").text().trim());

      const titleRaw = rowEl.find(".track-title").contents().get(0).nodeValue;
      const title = normalizeTrack(titleRaw);

      // really wish they'd added a class name here...
      const lengthRaw = rowEl.find(".col-sm-2.hide-on-mobile").text().trim();
      const length = getTrackLength(lengthRaw);

      return {
        title,
        index,
        length,
      };
    })
    .get();
}

function getTrackLength(raw: string): number | undefined {
  if (!raw || raw === "--") {
    return;
  }

  // pad to include hours
  if (raw.length === 4) {
    raw = `00:${raw}`;
  }

  return Duration.fromISOTime(raw).as("seconds");
}

function getCover($: cheerio.Root) {
  const node = $(".album-cover img");
  if (node) {
    return node.attr("src");
  }
}

function hasDownload($: cheerio.Root) {
  const downloadImage =
    "https://www.dgmlive.com/img/assets/albums/download-black.png";
  return $(`img[src='${downloadImage}']`).length > 0;
}

function parse(html: string, id: number) {
  const root = cheerio.load(html);

  const [venue, location] = getLocation(root);

  const date = getDate(root);
  const source = getAudioSource(root);
  const quality = getQuality(root);
  const description = getDescription(root);
  const cover = getCover(root);
  const download = hasDownload(root);
  const members = getMembers(root);
  const tracks = getTracks(root);

  return {
    id,
    date,
    venue,
    location,
    source,
    quality,
    description,
    cover,
    hasDownload: download,
    members,
    tracks,
  };
}

export default parse;
