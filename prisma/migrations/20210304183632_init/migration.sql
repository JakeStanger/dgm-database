-- CreateTable
CREATE TABLE "Track" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "length" INTEGER NOT NULL,
    "index" INTEGER,
    "albumId" INTEGER,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Album" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "releaseDate" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ShowTrack" (
    "id" SERIAL NOT NULL,
    "index" INTEGER NOT NULL,
    "length" INTEGER NOT NULL,
    "trackId" INTEGER NOT NULL,
    "showId" INTEGER NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Show" (
    "id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "venue" TEXT,
    "location" TEXT,
    "quality" INTEGER NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "Description" TEXT,
    "source" TEXT,
    "cover" TEXT,
    "hasDownload" BOOLEAN NOT NULL,
    "instrumentId" INTEGER,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Member" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Instrument" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MemberInstrument" (
    "memberId" INTEGER NOT NULL,
    "instrumentId" INTEGER NOT NULL,
    "showId" INTEGER,

    PRIMARY KEY ("memberId","instrumentId")
);

-- CreateTable
CREATE TABLE "_MemberToShow" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_InstrumentToMember" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Track.name_unique" ON "Track"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Album.name_unique" ON "Album"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Member.name_unique" ON "Member"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Instrument.name_unique" ON "Instrument"("name");

-- CreateIndex
CREATE UNIQUE INDEX "_MemberToShow_AB_unique" ON "_MemberToShow"("A", "B");

-- CreateIndex
CREATE INDEX "_MemberToShow_B_index" ON "_MemberToShow"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_InstrumentToMember_AB_unique" ON "_InstrumentToMember"("A", "B");

-- CreateIndex
CREATE INDEX "_InstrumentToMember_B_index" ON "_InstrumentToMember"("B");

-- AddForeignKey
ALTER TABLE "Track" ADD FOREIGN KEY ("albumId") REFERENCES "Album"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ShowTrack" ADD FOREIGN KEY ("trackId") REFERENCES "Track"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ShowTrack" ADD FOREIGN KEY ("showId") REFERENCES "Show"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Show" ADD FOREIGN KEY ("instrumentId") REFERENCES "Instrument"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MemberInstrument" ADD FOREIGN KEY ("memberId") REFERENCES "Member"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MemberInstrument" ADD FOREIGN KEY ("instrumentId") REFERENCES "Instrument"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MemberInstrument" ADD FOREIGN KEY ("showId") REFERENCES "Show"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_MemberToShow" ADD FOREIGN KEY ("A") REFERENCES "Member"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_MemberToShow" ADD FOREIGN KEY ("B") REFERENCES "Show"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_InstrumentToMember" ADD FOREIGN KEY ("A") REFERENCES "Instrument"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_InstrumentToMember" ADD FOREIGN KEY ("B") REFERENCES "Member"("id") ON DELETE CASCADE ON UPDATE CASCADE;
