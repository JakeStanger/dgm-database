import { startCase } from "lodash";

function normalizeInstrument(instrument: string) {
  instrument = startCase(
    instrument.trim()
      .replace(/ {2,}/, " ")
      .replace("&", "And")
  );

  return instrument;
}

export default normalizeInstrument;
