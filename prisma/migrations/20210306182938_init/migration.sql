/*
  Warnings:

  - You are about to drop the `Instrument` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_InstrumentToShowMember` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "_InstrumentToShowMember" DROP CONSTRAINT "_InstrumentToShowMember_A_fkey";

-- DropForeignKey
ALTER TABLE "_InstrumentToShowMember" DROP CONSTRAINT "_InstrumentToShowMember_B_fkey";

-- AlterTable
ALTER TABLE "ShowMember" ADD COLUMN     "instruments" TEXT[];

-- DropTable
DROP TABLE "Instrument";

-- DropTable
DROP TABLE "_InstrumentToShowMember";
