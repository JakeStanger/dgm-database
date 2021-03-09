/*
  Warnings:

  - Added the required column `sampleUrl` to the `ShowTrack` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "ShowTrack" ADD COLUMN     "sampleUrl" TEXT NOT NULL;
