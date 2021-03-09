/*
  Warnings:

  - The migration will change the primary key for the `MemberInstrument` table. If it partially fails, the table could be left without primary key constraint.
  - Made the column `showId` on table `MemberInstrument` required. The migration will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "MemberInstrument" DROP CONSTRAINT "MemberInstrument_pkey",
ALTER COLUMN "showId" SET NOT NULL,
ADD PRIMARY KEY ("memberId", "instrumentId", "showId");
