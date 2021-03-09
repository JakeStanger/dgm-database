-- CreateTable
CREATE TABLE "Sync" (
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lowerBound" INTEGER NOT NULL,
    "upperBound" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Sync.date_unique" ON "Sync"("date");
