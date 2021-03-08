import * as scraper from "./scraper";
import * as schedule from "node-schedule";
import * as logger from './utils/logger';
import './server';

function sync() {
  const syncJob = schedule.scheduleJob("0 2 * * *", async () => {
    await scraper.sync();
    logger.log('sync', "Next sync: " + syncJob.nextInvocation().toISOString());
  });

  syncJob.invoke();
}

sync();