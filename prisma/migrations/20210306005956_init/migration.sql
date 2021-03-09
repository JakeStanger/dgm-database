/*
  Warnings:

  - You are about to drop the column `instrumentId` on the `Show` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Show" DROP CONSTRAINT "Show_instrumentId_fkey";

-- AlterTable
ALTER TABLE "Show" DROP COLUMN "instrumentId";
