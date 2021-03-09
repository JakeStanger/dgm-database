/*
  Warnings:

  - You are about to drop the `MemberInstrument` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_InstrumentToMember` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_MemberToShow` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "MemberInstrument" DROP CONSTRAINT "MemberInstrument_instrumentId_fkey";

-- DropForeignKey
ALTER TABLE "MemberInstrument" DROP CONSTRAINT "MemberInstrument_memberId_fkey";

-- DropForeignKey
ALTER TABLE "MemberInstrument" DROP CONSTRAINT "MemberInstrument_showId_fkey";

-- DropForeignKey
ALTER TABLE "_InstrumentToMember" DROP CONSTRAINT "_InstrumentToMember_A_fkey";

-- DropForeignKey
ALTER TABLE "_InstrumentToMember" DROP CONSTRAINT "_InstrumentToMember_B_fkey";

-- DropForeignKey
ALTER TABLE "_MemberToShow" DROP CONSTRAINT "_MemberToShow_A_fkey";

-- DropForeignKey
ALTER TABLE "_MemberToShow" DROP CONSTRAINT "_MemberToShow_B_fkey";

-- DropTable
DROP TABLE "MemberInstrument";

-- DropTable
DROP TABLE "_InstrumentToMember";

-- DropTable
DROP TABLE "_MemberToShow";

-- CreateTable
CREATE TABLE "ShowMember" (
    "id" SERIAL NOT NULL,
    "memberId" INTEGER NOT NULL,
    "showId" INTEGER NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_InstrumentToShowMember" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_InstrumentToShowMember_AB_unique" ON "_InstrumentToShowMember"("A", "B");

-- CreateIndex
CREATE INDEX "_InstrumentToShowMember_B_index" ON "_InstrumentToShowMember"("B");

-- AddForeignKey
ALTER TABLE "ShowMember" ADD FOREIGN KEY ("memberId") REFERENCES "Member"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ShowMember" ADD FOREIGN KEY ("showId") REFERENCES "Show"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_InstrumentToShowMember" ADD FOREIGN KEY ("A") REFERENCES "Instrument"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_InstrumentToShowMember" ADD FOREIGN KEY ("B") REFERENCES "ShowMember"("id") ON DELETE CASCADE ON UPDATE CASCADE;
