-- AlterTable
ALTER TABLE "Show" ALTER COLUMN "quality" DROP NOT NULL,
ALTER COLUMN "date" DROP NOT NULL,
ALTER COLUMN "hasDownload" DROP NOT NULL;