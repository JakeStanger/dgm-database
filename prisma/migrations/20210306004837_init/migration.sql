/*
  Warnings:

  - You are about to drop the column `Description` on the `Show` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Show" DROP COLUMN "Description",
ADD COLUMN     "description" TEXT;
