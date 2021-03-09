/*
  Warnings:

  - You are about to drop the `Sync` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "Sync";

-- CreateTable
CREATE TABLE "TourSync" (
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lowerBound" INTEGER NOT NULL,
    "upperBound" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "TourSync.date_unique" ON "TourSync"("date");
