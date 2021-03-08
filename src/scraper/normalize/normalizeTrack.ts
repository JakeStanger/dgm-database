import { startCase } from "lodash";

const RE_SAILORS = () => /(the )?sailors?'?s? tales?/gi;
const RE_LARKS = () =>
  /lark(?:s'|s|'s)(?: *tongues)?(?: in aspic)?[,:]?(?: Pt | Part )([\w]+)/gi;

const RE_PART = () => /(?: Pt | Part )([\w]+)/gi;

function normalisePart(part: string) {
  switch (part.toLowerCase()) {
    case "one":
    case "1":
      return "I";
    case "two":
    case "2":
      return "II";
    case "three":
    case "3":
      return "III";
    case "four":
    case "4":
      return "IV";
    case "five":
    case "5":
      return "V";
    case "six":
    case "6":
      return "VI";
    case "seven":
    case "7":
      return "VII";
    case "eight":
    case "8":
      return "VIII";
    case "nine":
    case "9":
      return "IX";
    default:
      return part;
  }
}

function normalizeTrack(track: string) {
  track = startCase(
    track
      .trim()
      .replace(/\*$/, "")
      .replace(/\.$/, "")
      .replace(/’/g, "'")
      .replace(/^coda /i, "Coda: ")
      .replace(/^dr\.? /i, 'Doctor ')
      .replace(/^improv: /i, 'Improv ')
  );

  if (RE_SAILORS().test(track)) {
    return "Sailor's Tale";
  }

  if (RE_LARKS().test(track)) {
    const reParts = RE_LARKS().exec(track)!;
    const part = reParts[1];

    return `Larks' Tongues In Aspic Part ${normalisePart(part)}`;
  }

  if (RE_PART().test(track)) {
    return track.replace(RE_PART(), (_, part) => ` Part ${normalisePart(part)}`);
  }

  if (track === "A Man A City") {
    return "A Man, A City";
  }

  if (track.toLowerCase() === "bboom") {
    return "B'Boom";
  }

  if(track.toLowerCase() === 'elektrik') {
    return 'ElektriK';
  }

  return track;
}

export default normalizeTrack;
