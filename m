Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0T8HJnZ190612 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 02:17:19 -0600
Received: from main.carme.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 651261885767
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 00:16:23 -0800 (PST)
Received: from main.carme.maven.pl (main.carme.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id 8OIqt3FGPSesW98F for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2009 00:16:23 -0800 (PST)
From: =?utf-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH 1/3] [PO]: Switch Polish translation to UTF-8.
Date: Thu, 29 Jan 2009 09:16:16 +0100
Message-Id: <1233216978-22645-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7460526303391746058=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: arekm@carme.pld-linux.org

--===============7460526303391746058==
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit


Signed-off-by: Arkadiusz MiÅ›kiewicz <arekm@maven.pl>
---
 po/pl.po | 3730 +++++++++++++++++++++++++++++++-------------------------------
 1 files changed, 1865 insertions(+), 1865 deletions(-)

diff --git a/po/pl.po b/po/pl.po
index 68cdbf0..71d5fc0 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -11,23 +11,23 @@ msgstr ""
 "Last-Translator: Jakub Bogusz <qboosh@pld-linux.org>\n"
 "Language-Team: Polish <translation-team-pl@lists.sourceforge.net>\n"
 "MIME-Version: 1.0\n"
-"Content-Type: text/plain; charset=ISO-8859-2\n"
+"Content-Type: text/plain; charset=UTF-8\n"
 "Content-Transfer-Encoding: 8bit\n"
 
 #: ../copy/xfs_copy.c:102
 #, c-format
 msgid "Check logfile \"%s\" for more details\n"
-msgstr "Wiêcej szczegó³ów w pliku logu \"%s\"\n"
+msgstr "WiÄ™cej szczegÃ³Å‚Ã³w w pliku logu \"%s\"\n"
 
 #: ../copy/xfs_copy.c:108
 #, c-format
 msgid "%s:  could not write to logfile \"%s\".\n"
-msgstr "%s: nie uda³o siê zapisaæ pliku logu \"%s\".\n"
+msgstr "%s: nie udaÅ‚o siÄ™ zapisaÄ‡ pliku logu \"%s\".\n"
 
 #: ../copy/xfs_copy.c:111
 #, c-format
 msgid "Aborting XFS copy -- logfile error -- reason: %s\n"
-msgstr "Przerwano XFS copy - b³±d pliku logu - przyczyna: %s\n"
+msgstr "Przerwano XFS copy - bÅ‚Ä…d pliku logu - przyczyna: %s\n"
 
 #: ../copy/xfs_copy.c:126 ../copy/xfs_copy.c:286 ../copy/xfs_copy.c:563
 #: ../copy/xfs_copy.c:570
@@ -36,15 +36,15 @@ msgstr "Przerwano XFS copy - przyczyna"
 
 #: ../copy/xfs_copy.c:140
 msgid "THE FOLLOWING COPIES FAILED TO COMPLETE\n"
-msgstr "NASTÊPUJ¡CYCH KOPII NIE UDA£O SIÊ UKOÑCZYÆ\n"
+msgstr "NASTÄ˜PUJÄ„CYCH KOPII NIE UDAÅO SIÄ˜ UKOÅƒCZYÄ†\n"
 
 #: ../copy/xfs_copy.c:144
 msgid "write error"
-msgstr "b³±d zapisu"
+msgstr "bÅ‚Ä…d zapisu"
 
 #: ../copy/xfs_copy.c:146
 msgid "lseek64 error"
-msgstr "b³±d lseek64"
+msgstr "bÅ‚Ä…d lseek64"
 
 #: ../copy/xfs_copy.c:147
 #, c-format
@@ -54,22 +54,22 @@ msgstr " pod offsetem %lld\n"
 #: ../copy/xfs_copy.c:151
 #, c-format
 msgid "All copies completed.\n"
-msgstr "Wszystkie kopie ukoñczone.\n"
+msgstr "Wszystkie kopie ukoÅ„czone.\n"
 
 #: ../copy/xfs_copy.c:154
 #, c-format
 msgid "See \"%s\" for more details.\n"
-msgstr "Wiêcej szczegó³ów w \"%s\".\n"
+msgstr "WiÄ™cej szczegÃ³Å‚Ã³w w \"%s\".\n"
 
 #: ../copy/xfs_copy.c:255
 #, c-format
 msgid "%s:  write error on target %d \"%s\" at offset %lld\n"
-msgstr "%s: b³±d zapisu przy celu %d \"%s\" pod offsetem %lld\n"
+msgstr "%s: bÅ‚Ä…d zapisu przy celu %d \"%s\" pod offsetem %lld\n"
 
 #: ../copy/xfs_copy.c:260
 #, c-format
 msgid "%s:  lseek64 error on target %d \"%s\" at offset %lld\n"
-msgstr "%s: b³±d lseek64 przy celu %d \"%s\" pod offsetem %lld\n"
+msgstr "%s: bÅ‚Ä…d lseek64 przy celu %d \"%s\" pod offsetem %lld\n"
 
 #: ../copy/xfs_copy.c:266
 #, c-format
@@ -78,12 +78,12 @@ msgstr "Przerywano zapis celu %d - przyczyna"
 
 #: ../copy/xfs_copy.c:270
 msgid "Aborting XFS copy - no more targets.\n"
-msgstr "Przerwano XFS copy - nie ma wiêcej celów.\n"
+msgstr "Przerwano XFS copy - nie ma wiÄ™cej celÃ³w.\n"
 
 #: ../copy/xfs_copy.c:281
 #, c-format
 msgid "%s:  thread %d died unexpectedly, target \"%s\" incomplete\n"
-msgstr "%s: w±tek %d zmar³ nieoczekiwanie, cel \"%s\" niekompletny\n"
+msgstr "%s: wÄ…tek %d zmarÅ‚ nieoczekiwanie, cel \"%s\" niekompletny\n"
 
 #: ../copy/xfs_copy.c:283
 #, c-format
@@ -93,12 +93,12 @@ msgstr "%s: offset prawdopodobnie %lld\n"
 #: ../copy/xfs_copy.c:294
 #, c-format
 msgid "%s: Unknown child died (should never happen!)\n"
-msgstr "%s: Nieznany potomek zmar³ (nie powinno siê zdarzyæ!)\n"
+msgstr "%s: Nieznany potomek zmarÅ‚ (nie powinno siÄ™ zdarzyÄ‡!)\n"
 
 #: ../copy/xfs_copy.c:304
 #, c-format
 msgid "Usage: %s [-bd] [-L logfile] source target [target ...]\n"
-msgstr "Sk³adnia: %s [-bd] [-L plik_logu] ¼ród³o cel [cel ...]\n"
+msgstr "SkÅ‚adnia: %s [-bd] [-L plik_logu] ÅºrÃ³dÅ‚o cel [cel ...]\n"
 
 #: ../copy/xfs_copy.c:386
 #, c-format
@@ -108,12 +108,12 @@ msgstr "%s: niepowodzenie lseek64 pod offsetem %lld\n"
 #: ../copy/xfs_copy.c:401
 #, c-format
 msgid "assert error:  buf->length = %d, buf->size = %d\n"
-msgstr "b³±d zapewnienia: buf->length = %d, buf->size = %d\n"
+msgstr "bÅ‚Ä…d zapewnienia: buf->length = %d, buf->size = %d\n"
 
 #: ../copy/xfs_copy.c:408
 #, c-format
 msgid "%s:  read failure at offset %lld\n"
-msgstr "%s: b³±d odczytu pod offsetem %lld\n"
+msgstr "%s: bÅ‚Ä…d odczytu pod offsetem %lld\n"
 
 #: ../copy/xfs_copy.c:543 ../estimate/xfs_estimate.c:141 ../fsr/xfs_fsr.c:243
 #: ../growfs/xfs_growfs.c:182 ../io/init.c:180 ../mkfs/xfs_mkfs.c:1361
@@ -125,50 +125,50 @@ msgstr "%s wersja %s\n"
 #: ../copy/xfs_copy.c:561
 #, c-format
 msgid "%s: couldn't open log file \"%s\"\n"
-msgstr "%s: nie uda³o siê otworzyæ pliku logu \"%s\"\n"
+msgstr "%s: nie udaÅ‚o siÄ™ otworzyÄ‡ pliku logu \"%s\"\n"
 
 #: ../copy/xfs_copy.c:568
 #, c-format
 msgid "%s: couldn't set up logfile stream\n"
-msgstr "%s: nie uda³o siê ustanowiæ strumienia pliku logu\n"
+msgstr "%s: nie udaÅ‚o siÄ™ ustanowiÄ‡ strumienia pliku logu\n"
 
 #: ../copy/xfs_copy.c:580
 msgid "Couldn't allocate target array\n"
-msgstr "Nie uda³o siê przydzieliæ tablicy celów\n"
+msgstr "Nie udaÅ‚o siÄ™ przydzieliÄ‡ tablicy celÃ³w\n"
 
 #: ../copy/xfs_copy.c:595
 #, c-format
 msgid "%s: couldn't register atexit function.\n"
-msgstr "%s: nie uda³o siê zarejestrowaæ funkcji atexit.\n"
+msgstr "%s: nie udaÅ‚o siÄ™ zarejestrowaÄ‡ funkcji atexit.\n"
 
 #: ../copy/xfs_copy.c:604
 #, c-format
 msgid "%s:  couldn't open source \"%s\"\n"
-msgstr "%s: nie uda³o siê otworzyæ ¼ród³a \"%s\"\n"
+msgstr "%s: nie udaÅ‚o siÄ™ otworzyÄ‡ ÅºrÃ³dÅ‚a \"%s\"\n"
 
 #: ../copy/xfs_copy.c:610
 #, c-format
 msgid "%s:  couldn't stat source \"%s\"\n"
-msgstr "%s: nie uda³o siê wykonaæ stat na ¼ródle \"%s\"\n"
+msgstr "%s: nie udaÅ‚o siÄ™ wykonaÄ‡ stat na ÅºrÃ³dle \"%s\"\n"
 
 #: ../copy/xfs_copy.c:620
 #, c-format
 msgid "%s: Cannot set direct I/O flag on \"%s\".\n"
-msgstr "%s: Nie mo¿na ustawiæ flagi bezpo¶redniego we/wy na \"%s\".\n"
+msgstr "%s: Nie moÅ¼na ustawiÄ‡ flagi bezpoÅ›redniego we/wy na \"%s\".\n"
 
 #: ../copy/xfs_copy.c:625
 #, c-format
 msgid "%s: xfsctl on file \"%s\" failed.\n"
-msgstr "%s: xfsctl na pliku \"%s\" nie powiod³o siê.\n"
+msgstr "%s: xfsctl na pliku \"%s\" nie powiodÅ‚o siÄ™.\n"
 
 #: ../copy/xfs_copy.c:648
 #, c-format
 msgid "%s:  Warning -- a filesystem is mounted on the source device.\n"
-msgstr "%s: Uwaga - system plików jest podmontowany na urz±dzeniu ¼ród³owym.\n"
+msgstr "%s: Uwaga - system plikÃ³w jest podmontowany na urzÄ…dzeniu ÅºrÃ³dÅ‚owym.\n"
 
 #: ../copy/xfs_copy.c:651
 msgid "\t\tGenerated copies may be corrupt unless the source is\n"
-msgstr "\t\tWygenerowane kopie mog± byæ uszkodzone o ile ¼ród³o nie jest\n"
+msgstr "\t\tWygenerowane kopie mogÄ… byÄ‡ uszkodzone o ile ÅºrÃ³dÅ‚o nie jest\n"
 
 #: ../copy/xfs_copy.c:653
 msgid "\t\tunmounted or mounted read-only.  Copy proceeding...\n"
@@ -180,7 +180,7 @@ msgid ""
 "%s: couldn't initialize XFS library\n"
 "%s: Aborting.\n"
 msgstr ""
-"%s: nie uda³o siê zainicjowaæ biblioteki XFS\n"
+"%s: nie udaÅ‚o siÄ™ zainicjowaÄ‡ biblioteki XFS\n"
 "%s: Przerwano.\n"
 
 #: ../copy/xfs_copy.c:684
@@ -189,7 +189,7 @@ msgid ""
 "%s: %s filesystem failed to initialize\n"
 "%s: Aborting.\n"
 msgstr ""
-"%s: Nie powiod³a siê inicjalizacja systemu plików %s\n"
+"%s: Nie powiodÅ‚a siÄ™ inicjalizacja systemu plikÃ³w %s\n"
 "%s: Przerwano.\n"
 
 #: ../copy/xfs_copy.c:688
@@ -198,7 +198,7 @@ msgid ""
 "%s %s filesystem failed to initialize\n"
 "%s: Aborting.\n"
 msgstr ""
-"%s: Nie powiod³a siê inicjalizacja systemu plików %s\n"
+"%s: Nie powiodÅ‚a siÄ™ inicjalizacja systemu plikÃ³w %s\n"
 "%s: Przerwano.\n"
 
 #: ../copy/xfs_copy.c:692
@@ -207,7 +207,7 @@ msgid ""
 "%s: %s has an external log.\n"
 "%s: Aborting.\n"
 msgstr ""
-"%s: %s ma zewnêtrzny log.\n"
+"%s: %s ma zewnÄ™trzny log.\n"
 "%s: Przerwano.\n"
 
 #: ../copy/xfs_copy.c:696
@@ -216,7 +216,7 @@ msgid ""
 "%s: %s has a real-time section.\n"
 "%s: Aborting.\n"
 msgstr ""
-"%s: %s ma sekcjê real-time.\n"
+"%s: %s ma sekcjÄ™ real-time.\n"
 "%s: Przerwano.\n"
 
 #: ../copy/xfs_copy.c:721
@@ -224,7 +224,7 @@ msgid ""
 "Error:  filesystem block size is smaller than the disk sectorsize.\n"
 "Aborting XFS copy now.\n"
 msgstr ""
-"B³±d: rozmiar bloku systemu plików jest mniejszy ni¿ rozmiar sektora dysku.\n"
+"BÅ‚Ä…d: rozmiar bloku systemu plikÃ³w jest mniejszy niÅ¼ rozmiar sektora dysku.\n"
 "Przerwano XFS copy.\n"
 
 #: ../copy/xfs_copy.c:742
@@ -238,71 +238,71 @@ msgid ""
 "%s:  a filesystem is mounted on target device \"%s\".\n"
 "%s cannot copy to mounted filesystems.  Aborting\n"
 msgstr ""
-"%s: na urz±dzeniu docelowym \"%s\" jest podmontowany system plików.\n"
-"%s nie mo¿e kopiowaæ na podmontowane systemy plików. Przerwano.\n"
+"%s: na urzÄ…dzeniu docelowym \"%s\" jest podmontowany system plikÃ³w.\n"
+"%s nie moÅ¼e kopiowaÄ‡ na podmontowane systemy plikÃ³w. Przerwano.\n"
 
 #: ../copy/xfs_copy.c:771
 #, c-format
 msgid "%s:  couldn't open target \"%s\"\n"
-msgstr "%s: nie uda³o siê otworzyæ celu \"%s\"\n"
+msgstr "%s: nie udaÅ‚o siÄ™ otworzyÄ‡ celu \"%s\"\n"
 
 #: ../copy/xfs_copy.c:781
 #, c-format
 msgid "%s:  cannot grow data section.\n"
-msgstr "%s: nie mo¿na powiêkszyæ sekcji danych.\n"
+msgstr "%s: nie moÅ¼na powiÄ™kszyÄ‡ sekcji danych.\n"
 
 #: ../copy/xfs_copy.c:789
 #, c-format
 msgid "%s:  xfsctl on \"%s\" failed.\n"
-msgstr "%s: xfsctl na \"%s\" nie powiod³o siê.\n"
+msgstr "%s: xfsctl na \"%s\" nie powiodÅ‚o siÄ™.\n"
 
 #: ../copy/xfs_copy.c:808
 #, c-format
 msgid "%s:  failed to write last block\n"
-msgstr "%s: nie uda³o siê zapisaæ ostatniego bloku\n"
+msgstr "%s: nie udaÅ‚o siÄ™ zapisaÄ‡ ostatniego bloku\n"
 
 #: ../copy/xfs_copy.c:810
 #, c-format
 msgid "\tIs target \"%s\" too small?\n"
-msgstr "\tCzy cel \"%s\" jest zbyt ma³y?\n"
+msgstr "\tCzy cel \"%s\" jest zbyt maÅ‚y?\n"
 
 #: ../copy/xfs_copy.c:820
 msgid "Couldn't initialize global thread mask\n"
-msgstr "Nie uda³o siê zainicjowaæ globalnej maski w±tków\n"
+msgstr "Nie udaÅ‚o siÄ™ zainicjowaÄ‡ globalnej maski wÄ…tkÃ³w\n"
 
 #: ../copy/xfs_copy.c:827
 msgid "Error initializing wbuf 0\n"
-msgstr "B³±d inicjalizacji wbuf 0\n"
+msgstr "BÅ‚Ä…d inicjalizacji wbuf 0\n"
 
 #: ../copy/xfs_copy.c:835
 msgid "Error initializing btree buf 1\n"
-msgstr "B³±d inicjalizacji btree buf 1\n"
+msgstr "BÅ‚Ä…d inicjalizacji btree buf 1\n"
 
 #: ../copy/xfs_copy.c:840
 msgid "Error creating first semaphore.\n"
-msgstr "B³±d tworzenia pierwszego semafora.\n"
+msgstr "BÅ‚Ä…d tworzenia pierwszego semafora.\n"
 
 #: ../copy/xfs_copy.c:855
 msgid "Couldn't malloc space for thread args\n"
-msgstr "Nie uda³o siê przydzieliæ miejsca na argumenty w±tku\n"
+msgstr "Nie udaÅ‚o siÄ™ przydzieliÄ‡ miejsca na argumenty wÄ…tku\n"
 
 #: ../copy/xfs_copy.c:867
 #, c-format
 msgid "Error creating thread mutex %d\n"
-msgstr "B³±d podczas tworzenia sekcji krytycznej %d w±tku\n"
+msgstr "BÅ‚Ä…d podczas tworzenia sekcji krytycznej %d wÄ…tku\n"
 
 #: ../copy/xfs_copy.c:884
 #, c-format
 msgid "Error creating thread for target %d\n"
-msgstr "B³±d podczas tworzenia w±tku dla celu %d\n"
+msgstr "BÅ‚Ä…d podczas tworzenia wÄ…tku dla celu %d\n"
 
 #: ../copy/xfs_copy.c:974
 msgid "WARNING:  source filesystem inconsistent.\n"
-msgstr "UWAGA: ¼ród³owy system plików niespójny.\n"
+msgstr "UWAGA: ÅºrÃ³dÅ‚owy system plikÃ³w niespÃ³jny.\n"
 
 #: ../copy/xfs_copy.c:976
 msgid "  A leaf btree rec isn't a leaf.  Aborting now.\n"
-msgstr " Li¶æ rekordu b-drzewa nie jest li¶ciem. Przerwano.\n"
+msgstr " LiÅ›Ä‡ rekordu b-drzewa nie jest liÅ›ciem. Przerwano.\n"
 
 #: ../estimate/xfs_estimate.c:76
 #, c-format
@@ -317,38 +317,38 @@ msgid ""
 "Note:\tblocksize may have 'k' appended to indicate x1024\n"
 "\tlogsize may also have 'm' appended to indicate (1024 x 1024)\n"
 msgstr ""
-"Sk³adnia: %s [opcje] katalog [katalog ...]\n"
-"\t-b rozmiar_bloku (rozmiar bloku zasadniczego systemu plików)\n"
-"\t-i rozmiar_logu (rozmiar logu wewnêtrznego)\n"
-"\t-e rozmiar_logu (rozmiar logu zewnêtrznego)\n"
-"\t-v wypisywanie bardziej szczegó³owych komunikatów\n"
-"\t-h wypisanie tej informacji o sposobie u¿ycia\n"
+"SkÅ‚adnia: %s [opcje] katalog [katalog ...]\n"
+"\t-b rozmiar_bloku (rozmiar bloku zasadniczego systemu plikÃ³w)\n"
+"\t-i rozmiar_logu (rozmiar logu wewnÄ™trznego)\n"
+"\t-e rozmiar_logu (rozmiar logu zewnÄ™trznego)\n"
+"\t-v wypisywanie bardziej szczegÃ³Å‚owych komunikatÃ³w\n"
+"\t-h wypisanie tej informacji o sposobie uÅ¼ycia\n"
 "\n"
 
 #: ../estimate/xfs_estimate.c:106
 #, c-format
 msgid "blocksize %llu too small\n"
-msgstr "rozmiar bloku %llu jest zbyt ma³y\n"
+msgstr "rozmiar bloku %llu jest zbyt maÅ‚y\n"
 
 #: ../estimate/xfs_estimate.c:111
 #, c-format
 msgid "blocksize %llu too large\n"
-msgstr "rozmiar bloku %llu jest zbyt du¿y\n"
+msgstr "rozmiar bloku %llu jest zbyt duÅ¼y\n"
 
 #: ../estimate/xfs_estimate.c:118
 #, c-format
 msgid "already have external log noted, can't have both\n"
-msgstr "ju¿ jest przypisany zewnêtrzny log, nie mog± istnieæ oba\n"
+msgstr "juÅ¼ jest przypisany zewnÄ™trzny log, nie mogÄ… istnieÄ‡ oba\n"
 
 #: ../estimate/xfs_estimate.c:127
 #, c-format
 msgid "already have internal log noted, can't have both\n"
-msgstr "ju¿ jest przypisany wewnêtrzny log, nie mog± istnieæ oba\n"
+msgstr "juÅ¼ jest przypisany wewnÄ™trzny log, nie mogÄ… istnieÄ‡ oba\n"
 
 #: ../estimate/xfs_estimate.c:157
 #, c-format
 msgid "directory                               bsize   blocks    megabytes    logsize\n"
-msgstr "katalog                                 rozmb   bloków    megabajtów  rozm.logu\n"
+msgstr "katalog                                 rozmb   blokÃ³w    megabajtÃ³w  rozm.logu\n"
 
 #: ../estimate/xfs_estimate.c:171
 #, c-format
@@ -368,27 +368,27 @@ msgstr "isize=%llu\n"
 #: ../estimate/xfs_estimate.c:175
 #, c-format
 msgid "%llu regular files\n"
-msgstr "%llu plików zwyk³ych\n"
+msgstr "%llu plikÃ³w zwykÅ‚ych\n"
 
 #: ../estimate/xfs_estimate.c:176
 #, c-format
 msgid "%llu symbolic links\n"
-msgstr "%llu dowi±zañ symbolicznych\n"
+msgstr "%llu dowiÄ…zaÅ„ symbolicznych\n"
 
 #: ../estimate/xfs_estimate.c:177
 #, c-format
 msgid "%llu directories\n"
-msgstr "%llu katalogów\n"
+msgstr "%llu katalogÃ³w\n"
 
 #: ../estimate/xfs_estimate.c:178
 #, c-format
 msgid "%llu special files\n"
-msgstr "%llu plików specjalnych\n"
+msgstr "%llu plikÃ³w specjalnych\n"
 
 #: ../estimate/xfs_estimate.c:191
 #, c-format
 msgid "%s will take about %.1f megabytes\n"
-msgstr "%s zajmie oko³o %.1f megabajtów\n"
+msgstr "%s zajmie okoÅ‚o %.1f megabajtÃ³w\n"
 
 #: ../estimate/xfs_estimate.c:198
 #, c-format
@@ -398,42 +398,42 @@ msgstr "%-39s %5llu %8llu %10.1fMB %10llu\n"
 #: ../estimate/xfs_estimate.c:204
 #, c-format
 msgid "\twith the external log using %llu blocks "
-msgstr "\tz zewnêtrznym logiem zajmuj±cym %llu bloków "
+msgstr "\tz zewnÄ™trznym logiem zajmujÄ…cym %llu blokÃ³w "
 
 #: ../estimate/xfs_estimate.c:206
 #, c-format
 msgid "or about %.1f megabytes\n"
-msgstr "lub oko³o %.1f megabajtów\n"
+msgstr "lub okoÅ‚o %.1f megabajtÃ³w\n"
 
 #: ../fsr/xfs_fsr.c:216
 #, c-format
 msgid "%s: Stats not yet supported for XFS\n"
-msgstr "%s: statystyki nie s± jeszcze obs³ugiwane dla XFS-a\n"
+msgstr "%s: statystyki nie sÄ… jeszcze obsÅ‚ugiwane dla XFS-a\n"
 
 #: ../fsr/xfs_fsr.c:264 ../fsr/xfs_fsr.c:292
 #, c-format
 msgid "%s: could not stat: %s: %s\n"
-msgstr "%s: nie mo¿na wykonaæ stat: %s: %s\n"
+msgstr "%s: nie moÅ¼na wykonaÄ‡ stat: %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:274
 #, c-format
 msgid "%s: cannot read %s\n"
-msgstr "%s: nie mo¿na odczytaæ %s\n"
+msgstr "%s: nie moÅ¼na odczytaÄ‡ %s\n"
 
 #: ../fsr/xfs_fsr.c:306
 #, c-format
 msgid "%s: char special not supported: %s\n"
-msgstr "%s: urz±dzenia znakowe nie s± obs³ugiwane: %s\n"
+msgstr "%s: urzÄ…dzenia znakowe nie sÄ… obsÅ‚ugiwane: %s\n"
 
 #: ../fsr/xfs_fsr.c:312
 #, c-format
 msgid "%s: cannot defragment: %s: Not XFS\n"
-msgstr "%s: nie mo¿na zdefragmentowaæ: %s: to nie jest XFS\n"
+msgstr "%s: nie moÅ¼na zdefragmentowaÄ‡: %s: to nie jest XFS\n"
 
 #: ../fsr/xfs_fsr.c:322
 #, c-format
 msgid "%s: not fsys dev, dir, or reg file, ignoring\n"
-msgstr "%s: nie jest urz±dzeniem z systemem plików, katalogiem ani zwyk³ym plikiem, zignorowano\n"
+msgstr "%s: nie jest urzÄ…dzeniem z systemem plikÃ³w, katalogiem ani zwykÅ‚ym plikiem, zignorowano\n"
 
 #: ../fsr/xfs_fsr.c:337
 #, c-format
@@ -453,124 +453,124 @@ msgid ""
 "       -d              Debug, print even more.\n"
 "       -v\t\tVerbose, more -v's more verbose.\n"
 msgstr ""
-"Sk³adnia: %s [-d] [-v] [-n] [-s] [-g] [-t czas] [-p przebiegi] [-f leftf] [-m mtab]\n"
+"SkÅ‚adnia: %s [-d] [-v] [-n] [-s] [-g] [-t czas] [-p przebiegi] [-f leftf] [-m mtab]\n"
 "          %s [-d] [-v] [-n] [-s] [-g] xfsdev | katalog | plik ...\n"
 "\n"
 "Opcje:\n"
 "       -n              Nie robienie niczego, przydatne tylko z -v.\n"
 "                       Nieprzydatne w trybie mtab.\n"
 "       -s              Tylko wypisanie statystyk.\n"
-"       -g              Pisanie do sysloga (domy¶lne je¶li stdout to nie tty).\n"
-"       -t czas         Czas dzia³ania w sekundach.\n"
-"       -p przebiegi    Liczba przebiegów przed zakoñczeniem reorganizacji.\n"
-"       -f leftoff      U¿ycie tego pliku zamiast %s.\n"
-"       -m mtab         U¿ycie pliku innego ni¿ /etc/mtab.\n"
-"       -d              Diagnostyka, du¿o wiêcej informacji.\n"
-"       -v              Tym wiêcej szczegó³ów, im wiêcej opcji -v.\n"
+"       -g              Pisanie do sysloga (domyÅ›lne jeÅ›li stdout to nie tty).\n"
+"       -t czas         Czas dziaÅ‚ania w sekundach.\n"
+"       -p przebiegi    Liczba przebiegÃ³w przed zakoÅ„czeniem reorganizacji.\n"
+"       -f leftoff      UÅ¼ycie tego pliku zamiast %s.\n"
+"       -m mtab         UÅ¼ycie pliku innego niÅ¼ /etc/mtab.\n"
+"       -d              Diagnostyka, duÅ¼o wiÄ™cej informacji.\n"
+"       -v              Tym wiÄ™cej szczegÃ³Å‚Ã³w, im wiÄ™cej opcji -v.\n"
 
 #: ../fsr/xfs_fsr.c:368
 #, c-format
 msgid "could not open mtab file: %s\n"
-msgstr "nie uda³o siê otworzyæ pliku mtab: %s\n"
+msgstr "nie udaÅ‚o siÄ™ otworzyÄ‡ pliku mtab: %s\n"
 
 #: ../fsr/xfs_fsr.c:374 ../fsr/xfs_fsr.c:406
 #, c-format
 msgid "out of memory: %s\n"
-msgstr "brak pamiêci: %s\n"
+msgstr "brak pamiÄ™ci: %s\n"
 
 #: ../fsr/xfs_fsr.c:397
 #, c-format
 msgid "Skipping %s: not mounted rw\n"
-msgstr "Pominiêto %s: nie zamontowany rw\n"
+msgstr "PominiÄ™to %s: nie zamontowany rw\n"
 
 #: ../fsr/xfs_fsr.c:411
 #, c-format
 msgid "out of memory on realloc: %s\n"
-msgstr "brak pamiêci przy realloc: %s\n"
+msgstr "brak pamiÄ™ci przy realloc: %s\n"
 
 #: ../fsr/xfs_fsr.c:422
 #, c-format
 msgid "strdup(%s) failed\n"
-msgstr "strdup(%s) nie powiod³o siê\n"
+msgstr "strdup(%s) nie powiodÅ‚o siÄ™\n"
 
 #: ../fsr/xfs_fsr.c:432
 #, c-format
 msgid "no rw xfs file systems in mtab: %s\n"
-msgstr "brak w pliku mtab systemów plików xfs w trybie rw: %s\n"
+msgstr "brak w pliku mtab systemÃ³w plikÃ³w xfs w trybie rw: %s\n"
 
 #: ../fsr/xfs_fsr.c:436
 #, c-format
 msgid "Found %d mounted, writable, XFS filesystems\n"
-msgstr "Liczba znalezionych zamontowanych, zapisywalnych systemów plików XFS: %d\n"
+msgstr "Liczba znalezionych zamontowanych, zapisywalnych systemÃ³w plikÃ³w XFS: %d\n"
 
 #: ../fsr/xfs_fsr.c:466
 #, c-format
 msgid "%s: open failed\n"
-msgstr "%s: open nie powiod³o siê\n"
+msgstr "%s: open nie powiodÅ‚o siÄ™\n"
 
 #: ../fsr/xfs_fsr.c:481
 #, c-format
 msgid "Can't use %s: mode=0%o own=%d nlink=%d\n"
-msgstr "Nie mo¿na u¿yæ %s: mode=0%o own=%d nlink=%d\n"
+msgstr "Nie moÅ¼na uÅ¼yÄ‡ %s: mode=0%o own=%d nlink=%d\n"
 
 #: ../fsr/xfs_fsr.c:501
 #, c-format
 msgid "could not read %s, starting with %s\n"
-msgstr "nie mo¿na odczytaæ %s, rozpoczêcie z %s\n"
+msgstr "nie moÅ¼na odczytaÄ‡ %s, rozpoczÄ™cie z %s\n"
 
 #: ../fsr/xfs_fsr.c:538
 #, c-format
 msgid "START: pass=%d ino=%llu %s %s\n"
-msgstr "START: przebieg=%d i-wêze³=%llu %s %s\n"
+msgstr "START: przebieg=%d i-wÄ™zeÅ‚=%llu %s %s\n"
 
 #: ../fsr/xfs_fsr.c:555
 #, c-format
 msgid "Completed all %d passes\n"
-msgstr "Zakoñczono wszystkie przebiegi w liczbie %d\n"
+msgstr "ZakoÅ„czono wszystkie przebiegi w liczbie %d\n"
 
 #: ../fsr/xfs_fsr.c:565
 msgid "couldn't fork sub process:"
-msgstr "nie uda³o siê uruchomiæ podprocesu:"
+msgstr "nie udaÅ‚o siÄ™ uruchomiÄ‡ podprocesu:"
 
 #: ../fsr/xfs_fsr.c:602
 #, c-format
 msgid "open(%s) failed: %s\n"
-msgstr "open(%s) nie powiod³o siê: %s\n"
+msgstr "open(%s) nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../fsr/xfs_fsr.c:609
 #, c-format
 msgid "write(%s) failed: %s\n"
-msgstr "write(%s) nie powiod³o siê: %s\n"
+msgstr "write(%s) nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../fsr/xfs_fsr.c:616
 #, c-format
 msgid "%s startpass %d, endpass %d, time %d seconds\n"
-msgstr "%s pocz. przebieg %d, koñc. przebieg %d, czas %d sekund\n"
+msgstr "%s pocz. przebieg %d, koÅ„c. przebieg %d, czas %d sekund\n"
 
 #: ../fsr/xfs_fsr.c:638
 #, c-format
 msgid "%s start inode=%llu\n"
-msgstr "%s pocz. i-wêze³=%llu\n"
+msgstr "%s pocz. i-wÄ™zeÅ‚=%llu\n"
 
 #: ../fsr/xfs_fsr.c:643
 #, c-format
 msgid "unable to get handle: %s: %s\n"
-msgstr "nie uda³o siê uzyskaæ uchwytu: %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ uzyskaÄ‡ uchwytu: %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:649
 #, c-format
 msgid "unable to open: %s: %s\n"
-msgstr "nie uda³o siê otworzyæ: %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ otworzyÄ‡: %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:655
 #, c-format
 msgid "Skipping %s: could not get XFS geometry\n"
-msgstr "Pominiêto %s: nie mo¿na odczytaæ geometrii XFS\n"
+msgstr "PominiÄ™to %s: nie moÅ¼na odczytaÄ‡ geometrii XFS\n"
 
 #: ../fsr/xfs_fsr.c:687
 #, c-format
 msgid "could not open: inode %llu\n"
-msgstr "nie uda³o siê otworzyæ: i-wêze³ %llu\n"
+msgstr "nie udaÅ‚o siÄ™ otworzyÄ‡: i-wÄ™zeÅ‚ %llu\n"
 
 #: ../fsr/xfs_fsr.c:717
 #, c-format
@@ -580,37 +580,37 @@ msgstr "%s: xfs_bulkstat: %s\n"
 #: ../fsr/xfs_fsr.c:743
 #, c-format
 msgid "%s: Directory defragmentation not supported\n"
-msgstr "%s: Defragmentacja katalogów nie jest obs³ugiwana\n"
+msgstr "%s: Defragmentacja katalogÃ³w nie jest obsÅ‚ugiwana\n"
 
 #: ../fsr/xfs_fsr.c:762
 #, c-format
 msgid "unable to construct sys handle for %s: %s\n"
-msgstr "nie uda³o siê utworzyæ uchwytu systemowego dla %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ utworzyÄ‡ uchwytu systemowego dla %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:773
 #, c-format
 msgid "unable to open sys handle for %s: %s\n"
-msgstr "nie uda³o siê otworzyæ uchwytu systemowego dla %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ otworzyÄ‡ uchwytu systemowego dla %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:779
 #, c-format
 msgid "unable to get bstat on %s: %s\n"
-msgstr "nie uda³o siê uzyskaæ bstat na %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ uzyskaÄ‡ bstat na %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:787
 #, c-format
 msgid "unable to open handle %s: %s\n"
-msgstr "nie uda³o siê otworzyæ uchwytu %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ otworzyÄ‡ uchwytu %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:795
 #, c-format
 msgid "Unable to get geom on fs for: %s\n"
-msgstr "Nie uda³o siê odczytaæ geometrii systemu plików dla: %s\n"
+msgstr "Nie udaÅ‚o siÄ™ odczytaÄ‡ geometrii systemu plikÃ³w dla: %s\n"
 
 #: ../fsr/xfs_fsr.c:844
 #, c-format
 msgid "sync failed: %s: %s\n"
-msgstr "sync nie powiod³o siê: %s: %s\n"
+msgstr "sync nie powiodÅ‚o siÄ™: %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:850
 #, c-format
@@ -620,32 +620,32 @@ msgstr "%s: zerowy rozmiar, zignorowano\n"
 #: ../fsr/xfs_fsr.c:869
 #, c-format
 msgid "locking check failed: %s\n"
-msgstr "sprawdzenie blokowania nie powiod³o siê: %s\n"
+msgstr "sprawdzenie blokowania nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../fsr/xfs_fsr.c:876
 #, c-format
 msgid "mandatory lock: %s: ignoring\n"
-msgstr "obowi±zkowa blokada: %s: zignorowano\n"
+msgstr "obowiÄ…zkowa blokada: %s: zignorowano\n"
 
 #: ../fsr/xfs_fsr.c:889
 #, c-format
 msgid "unable to get fs stat on %s: %s\n"
-msgstr "nie uda³o siê uzyskaæ stat fs na %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ uzyskaÄ‡ stat fs na %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:896
 #, c-format
 msgid "insufficient freespace for: %s: size=%lld: ignoring\n"
-msgstr "niewystarczaj±ca ilo¶æ miejsca dla: %s: rozmiar=%lld: zignorowano\n"
+msgstr "niewystarczajÄ…ca iloÅ›Ä‡ miejsca dla: %s: rozmiar=%lld: zignorowano\n"
 
 #: ../fsr/xfs_fsr.c:903
 #, c-format
 msgid "failed to get inode attrs: %s\n"
-msgstr "nie uda³o siê uzyskaæ atrybutów i-wêz³a: %s\n"
+msgstr "nie udaÅ‚o siÄ™ uzyskaÄ‡ atrybutÃ³w i-wÄ™zÅ‚a: %s\n"
 
 #: ../fsr/xfs_fsr.c:908
 #, c-format
 msgid "%s: immutable/append, ignoring\n"
-msgstr "%s: niezmienny/tylko do do³±czania, zignorowano\n"
+msgstr "%s: niezmienny/tylko do doÅ‚Ä…czania, zignorowano\n"
 
 #: ../fsr/xfs_fsr.c:913
 #, c-format
@@ -655,22 +655,22 @@ msgstr "%s: oznaczony jako nie do defragmentacji, zignorowano\n"
 #: ../fsr/xfs_fsr.c:919
 #, c-format
 msgid "cannot get realtime geometry for: %s\n"
-msgstr "nie mo¿na uzyskaæ geometrii realtime dla: %s\n"
+msgstr "nie moÅ¼na uzyskaÄ‡ geometrii realtime dla: %s\n"
 
 #: ../fsr/xfs_fsr.c:924
 #, c-format
 msgid "low on realtime free space: %s: ignoring file\n"
-msgstr "ma³o wolnego miejsca realtime: %s: plik zignorowany\n"
+msgstr "maÅ‚o wolnego miejsca realtime: %s: plik zignorowany\n"
 
 #: ../fsr/xfs_fsr.c:931
 #, c-format
 msgid "cannot open: %s: Permission denied\n"
-msgstr "nie mo¿na otworzyæ: %s: brak uprawnieñ\n"
+msgstr "nie moÅ¼na otworzyÄ‡: %s: brak uprawnieÅ„\n"
 
 #: ../fsr/xfs_fsr.c:985
 #, c-format
 msgid "%s already fully defragmented.\n"
-msgstr "%s jest ju¿ ca³kowicie zdefragmentowany.\n"
+msgstr "%s jest juÅ¼ caÅ‚kowicie zdefragmentowany.\n"
 
 #: ../fsr/xfs_fsr.c:990
 #, c-format
@@ -680,27 +680,27 @@ msgstr "%s extents=%d can_save=%d tmp=%s\n"
 #: ../fsr/xfs_fsr.c:996
 #, c-format
 msgid "could not open tmp file: %s: %s\n"
-msgstr "nie uda³o siê otworzyæ pliku tymczasowego: %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ otworzyÄ‡ pliku tymczasowego: %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:1005
 #, c-format
 msgid "could not set ATTR on tmp: %s:\n"
-msgstr "nie uda³o siê ustawiæ ATTR na tmp: %s\n"
+msgstr "nie udaÅ‚o siÄ™ ustawiÄ‡ ATTR na tmp: %s\n"
 
 #: ../fsr/xfs_fsr.c:1010
 #, c-format
 msgid "%s set temp attr\n"
-msgstr "%s ustawianie atrybutów pliku tymczasowego\n"
+msgstr "%s ustawianie atrybutÃ³w pliku tymczasowego\n"
 
 #: ../fsr/xfs_fsr.c:1016
 #, c-format
 msgid "could not set inode attrs on tmp: %s\n"
-msgstr "nie uda³o siê ustawiæ atrybutów i-wêz³a na tmp: %s\n"
+msgstr "nie udaÅ‚o siÄ™ ustawiÄ‡ atrybutÃ³w i-wÄ™zÅ‚a na tmp: %s\n"
 
 #: ../fsr/xfs_fsr.c:1024
 #, c-format
 msgid "could not get DirectIO info on tmp: %s\n"
-msgstr "nie uda³o siê uzyskaæ informacji o bezpo¶rednim we/wy na tmp: %s\n"
+msgstr "nie udaÅ‚o siÄ™ uzyskaÄ‡ informacji o bezpoÅ›rednim we/wy na tmp: %s\n"
 
 #: ../fsr/xfs_fsr.c:1040
 #, c-format
@@ -710,66 +710,66 @@ msgstr "DEBUG: fsize=%lld blsz_dio=%d d_min=%d d_max=%d pgsz=%d\n"
 #: ../fsr/xfs_fsr.c:1047
 #, c-format
 msgid "could not allocate buf: %s\n"
-msgstr "nie uda³o siê przydzieliæ bufora: %s\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ bufora: %s\n"
 
 #: ../fsr/xfs_fsr.c:1058
 #, c-format
 msgid "could not open fragfile: %s : %s\n"
-msgstr "nie uda³o siê otworzyæ pliku frag: %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ otworzyÄ‡ pliku frag: %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:1075
 #, c-format
 msgid "could not trunc tmp %s\n"
-msgstr "nie uda³o siê uci±æ tmp %s\n"
+msgstr "nie udaÅ‚o siÄ™ uciÄ…Ä‡ tmp %s\n"
 
 #: ../fsr/xfs_fsr.c:1090
 #, c-format
 msgid "could not pre-allocate tmp space: %s\n"
-msgstr "nie uda³o siê wstêpnie przydzieliæ miejsca tmp: %s\n"
+msgstr "nie udaÅ‚o siÄ™ wstÄ™pnie przydzieliÄ‡ miejsca tmp: %s\n"
 
 #: ../fsr/xfs_fsr.c:1101
 msgid "Couldn't rewind on temporary file\n"
-msgstr "Nie uda³o siê przewin±æ pliku tymczasowego\n"
+msgstr "Nie udaÅ‚o siÄ™ przewinÄ…Ä‡ pliku tymczasowego\n"
 
 #: ../fsr/xfs_fsr.c:1110
 #, c-format
 msgid "Temporary file has %d extents (%d in original)\n"
-msgstr "Plik tymczasowy ma fragmentów: %d (%d w oryginale)\n"
+msgstr "Plik tymczasowy ma fragmentÃ³w: %d (%d w oryginale)\n"
 
 #: ../fsr/xfs_fsr.c:1113
 #, c-format
 msgid "No improvement will be made (skipping): %s\n"
-msgstr "Nie nast±pi poprawa (pominiêto): %s\n"
+msgstr "Nie nastÄ…pi poprawa (pominiÄ™to): %s\n"
 
 #: ../fsr/xfs_fsr.c:1157
 #, c-format
 msgid "bad read of %d bytes from %s: %s\n"
-msgstr "b³êdny odczyt %d bajtów z %s: %s\n"
+msgstr "bÅ‚Ä™dny odczyt %d bajtÃ³w z %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:1161 ../fsr/xfs_fsr.c:1195
 #, c-format
 msgid "bad write of %d bytes to %s: %s\n"
-msgstr "b³êdny zapis %d bajtów do %s: %s\n"
+msgstr "bÅ‚Ä™dny zapis %d bajtÃ³w do %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:1178
 #, c-format
 msgid "bad write2 of %d bytes to %s: %s\n"
-msgstr "b³êdny zapis 2 %d bajtów do %s: %s\n"
+msgstr "bÅ‚Ä™dny zapis 2 %d bajtÃ³w do %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:1183
 #, c-format
 msgid "bad copy to %s\n"
-msgstr "b³êdna kopia do %s\n"
+msgstr "bÅ‚Ä™dna kopia do %s\n"
 
 #: ../fsr/xfs_fsr.c:1218
 #, c-format
 msgid "failed to fchown tmpfile %s: %s\n"
-msgstr "nie uda³o siê wykonaæ fchown na pliku tymczasowym %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ wykonaÄ‡ fchown na pliku tymczasowym %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:1229
 #, c-format
 msgid "%s: file type not supported\n"
-msgstr "%s: tym pliku nie obs³ugiwany\n"
+msgstr "%s: tym pliku nie obsÅ‚ugiwany\n"
 
 #: ../fsr/xfs_fsr.c:1233
 #, c-format
@@ -779,61 +779,61 @@ msgstr "%s: plik zmodyfikowany, defragmentacja przerwana\n"
 #: ../fsr/xfs_fsr.c:1238
 #, c-format
 msgid "%s: file busy\n"
-msgstr "%s: plik zajêty\n"
+msgstr "%s: plik zajÄ™ty\n"
 
 #: ../fsr/xfs_fsr.c:1240
 #, c-format
 msgid "XFS_IOC_SWAPEXT failed: %s: %s\n"
-msgstr "XFS_IOC_SWAPEXT nie powiod³o siê: %s: %s\n"
+msgstr "XFS_IOC_SWAPEXT nie powiodÅ‚o siÄ™: %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:1249
 #, c-format
 msgid "extents before:%d after:%d %s %s\n"
-msgstr "fragmentów przed: %d po: %d %s %s\n"
+msgstr "fragmentÃ³w przed: %d po: %d %s %s\n"
 
 #: ../fsr/xfs_fsr.c:1275
 #, c-format
 msgid "tmp file name too long: %s\n"
-msgstr "nazwa pliku tymczasowego zbyt d³uga: %s\n"
+msgstr "nazwa pliku tymczasowego zbyt dÅ‚uga: %s\n"
 
 #: ../fsr/xfs_fsr.c:1324
 #, c-format
 msgid "realloc failed: %s\n"
-msgstr "realloc nie powiod³o siê: %s\n"
+msgstr "realloc nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../fsr/xfs_fsr.c:1337
 #, c-format
 msgid "malloc failed: %s\n"
-msgstr "malloc nie powiod³o siê: %s\n"
+msgstr "malloc nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../fsr/xfs_fsr.c:1367
 #, c-format
 msgid "failed reading extents: inode %llu"
-msgstr "nie uda³o siê odczytaæ fragmentów: i-wêze³ %llu"
+msgstr "nie udaÅ‚o siÄ™ odczytaÄ‡ fragmentÃ³w: i-wÄ™zeÅ‚ %llu"
 
 #: ../fsr/xfs_fsr.c:1417
 msgid "failed reading extents"
-msgstr "nie uda³o siê odczytaæ fragmentów"
+msgstr "nie udaÅ‚o siÄ™ odczytaÄ‡ fragmentÃ³w"
 
 #: ../fsr/xfs_fsr.c:1534 ../fsr/xfs_fsr.c:1548
 #, c-format
 msgid "tmpdir already exists: %s\n"
-msgstr "katalog tymczasowy ju¿ istnieje: %s\n"
+msgstr "katalog tymczasowy juÅ¼ istnieje: %s\n"
 
 #: ../fsr/xfs_fsr.c:1537
 #, c-format
 msgid "could not create tmpdir: %s: %s\n"
-msgstr "nie uda³o siê utworzyæ katalogu tymczasowego: %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ utworzyÄ‡ katalogu tymczasowego: %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:1550
 #, c-format
 msgid "cannot create tmpdir: %s: %s\n"
-msgstr "nie mo¿na utworzyæ katalogu tymczasowego: %s: %s\n"
+msgstr "nie moÅ¼na utworzyÄ‡ katalogu tymczasowego: %s: %s\n"
 
 #: ../fsr/xfs_fsr.c:1588 ../fsr/xfs_fsr.c:1596
 #, c-format
 msgid "could not remove tmpdir: %s: %s\n"
-msgstr "nie uda³o siê usun±æ katalogu tymczasowego: %s: %s\n"
+msgstr "nie udaÅ‚o siÄ™ usunÄ…Ä‡ katalogu tymczasowego: %s: %s\n"
 
 #: ../growfs/xfs_growfs.c:34
 #, c-format
@@ -856,22 +856,22 @@ msgid ""
 "\t-m imaxpct  set inode max percent to imaxpct\n"
 "\t-V          print version information\n"
 msgstr ""
-"Sk³adnia: %s [opcje] punkt_montowania\n"
+"SkÅ‚adnia: %s [opcje] punkt_montowania\n"
 "\n"
 "Opcje:\n"
-"\t-d          powiêkszenie sekcji danych/metadanych\n"
-"\t-l          powiêkszenie sekcji logu\n"
-"\t-r          powiêkszenie sekcji realtime\n"
+"\t-d          powiÄ™kszenie sekcji danych/metadanych\n"
+"\t-l          powiÄ™kszenie sekcji logu\n"
+"\t-r          powiÄ™kszenie sekcji realtime\n"
 "\t-n          bez zmian, tylko pokazanie geometrii\n"
-"\t-I          zezwolenie na przekroczenie %d bitów przez numery i-wêz³ów\n"
-"\t-i          przekszta³cenie logu z formatu zewnêtrznego na wewnêtrzny\n"
-"\t-t          inne po³o¿enie tabeli montowañ (/etc/mtab)\n"
-"\t-x          przekszta³cenie logu z formatu wewnêtrznego na zewnêtrzny\n"
-"\t-D rozmiar  powiêkszenie sekcji danych/metadanych do rozmiaru w blokach\n"
-"\t-L rozmiar  powiêkszenie/zmniejszenie sekcji logu do rozmiaru w blokach\n"
-"\t-R rozmiar  powiêkszenie sekcji realtime do rozmiaru w blokach\n"
+"\t-I          zezwolenie na przekroczenie %d bitÃ³w przez numery i-wÄ™zÅ‚Ã³w\n"
+"\t-i          przeksztaÅ‚cenie logu z formatu zewnÄ™trznego na wewnÄ™trzny\n"
+"\t-t          inne poÅ‚oÅ¼enie tabeli montowaÅ„ (/etc/mtab)\n"
+"\t-x          przeksztaÅ‚cenie logu z formatu wewnÄ™trznego na zewnÄ™trzny\n"
+"\t-D rozmiar  powiÄ™kszenie sekcji danych/metadanych do rozmiaru w blokach\n"
+"\t-L rozmiar  powiÄ™kszenie/zmniejszenie sekcji logu do rozmiaru w blokach\n"
+"\t-R rozmiar  powiÄ™kszenie sekcji realtime do rozmiaru w blokach\n"
 "\t-e rozmiar  stawienie rozmiaru fragmentu realtime na rozmiar w blokach\n"
-"\t-m imaxpct  ustawienie maksymalnego procentu i-wêz³ów na imaxpct\n"
+"\t-m imaxpct  ustawienie maksymalnego procentu i-wÄ™zÅ‚Ã³w na imaxpct\n"
 "\t-V          wypisanie informacji o wersji\n"
 
 #: ../growfs/xfs_growfs.c:68
@@ -886,25 +886,25 @@ msgid ""
 "         =%-22s sectsz=%-5u sunit=%u blks, lazy-count=%u\n"
 "realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"
 msgstr ""
-"metadane=%-22s isize=%-6u agcount=%u, agsize=%u bloków\n"
+"metadane=%-22s isize=%-6u agcount=%u, agsize=%u blokÃ³w\n"
 "        =%-22s sectsz=%-5u attr=%u\n"
 "dane    =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
-"        =%-22s sunit=%-6u swidth=%u bloków\n"
+"        =%-22s sunit=%-6u swidth=%u blokÃ³w\n"
 "nazwy   =wersja %-14u bsize=%-6u\n"
 " ascii-ci=%d\n"
 "log     =%-22s bsize=%-6u blocks=%u, wersja=%u\n"
-"        =%-22s sectsz=%-5u sunit=%u bloków, lazy-count=%u\n"
+"        =%-22s sectsz=%-5u sunit=%u blokÃ³w, lazy-count=%u\n"
 "realtime=%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"
 
 #: ../growfs/xfs_growfs.c:83 ../growfs/xfs_growfs.c:448
 #: ../growfs/xfs_growfs.c:449
 msgid "internal"
-msgstr "wewnêtrzny"
+msgstr "wewnÄ™trzny"
 
 #: ../growfs/xfs_growfs.c:83 ../growfs/xfs_growfs.c:86
 #: ../growfs/xfs_growfs.c:448 ../growfs/xfs_growfs.c:449
 msgid "external"
-msgstr "zewnêtrzny"
+msgstr "zewnÄ™trzny"
 
 #: ../growfs/xfs_growfs.c:86 ../mkfs/xfs_mkfs.c:1665
 msgid "none"
@@ -913,108 +913,108 @@ msgstr "brak"
 #: ../growfs/xfs_growfs.c:199
 #, c-format
 msgid "%s: %s is not a mounted XFS filesystem\n"
-msgstr "%s: %s nie jest podmontowanym systemem plików XFS\n"
+msgstr "%s: %s nie jest podmontowanym systemem plikÃ³w XFS\n"
 
 #: ../growfs/xfs_growfs.c:216 ../io/open.c:170
 #, c-format
 msgid "%s: specified file [\"%s\"] is not on an XFS filesystem\n"
-msgstr "%s: podany plik [\"%s\"] nie jest na systemie plików XFS\n"
+msgstr "%s: podany plik [\"%s\"] nie jest na systemie plikÃ³w XFS\n"
 
 #: ../growfs/xfs_growfs.c:233
 #, c-format
 msgid "%s: cannot determine geometry of filesystem mounted at %s: %s\n"
-msgstr "%s: nie mo¿na okre¶liæ geometrii systemu plików podmontowanego pod %s: %s\n"
+msgstr "%s: nie moÅ¼na okreÅ›liÄ‡ geometrii systemu plikÃ³w podmontowanego pod %s: %s\n"
 
 #: ../growfs/xfs_growfs.c:268
 #, c-format
 msgid "%s: failed to access data device for %s\n"
-msgstr "%s: nie uda³o siê uzyskaæ dostêpu do urz±dzenia z danymi dla %s\n"
+msgstr "%s: nie udaÅ‚o siÄ™ uzyskaÄ‡ dostÄ™pu do urzÄ…dzenia z danymi dla %s\n"
 
 #: ../growfs/xfs_growfs.c:273
 #, c-format
 msgid "%s: failed to access external log for %s\n"
-msgstr "%s: nie uda³o siê uzyskaæ dostêpu do zewnêtrznego logu dla %s\n"
+msgstr "%s: nie udaÅ‚o siÄ™ uzyskaÄ‡ dostÄ™pu do zewnÄ™trznego logu dla %s\n"
 
 #: ../growfs/xfs_growfs.c:279
 #, c-format
 msgid "%s: failed to access realtime device for %s\n"
-msgstr "%s: nie uda³o siê uzyskaæ dostêpu do urz±dzenia realtime dla %s\n"
+msgstr "%s: nie udaÅ‚o siÄ™ uzyskaÄ‡ dostÄ™pu do urzÄ…dzenia realtime dla %s\n"
 
 #: ../growfs/xfs_growfs.c:315
 #, c-format
 msgid "data size %lld too large, maximum is %lld\n"
-msgstr "rozmiar danych %lld zbyt du¿y, maksymalny to %lld\n"
+msgstr "rozmiar danych %lld zbyt duÅ¼y, maksymalny to %lld\n"
 
 #: ../growfs/xfs_growfs.c:325
 #, c-format
 msgid "data size %lld too small, old size is %lld\n"
-msgstr "rozmiar danych %lld zbyt ma³y, stary rozmiar to %lld\n"
+msgstr "rozmiar danych %lld zbyt maÅ‚y, stary rozmiar to %lld\n"
 
 #: ../growfs/xfs_growfs.c:333
 #, c-format
 msgid "data size unchanged, skipping\n"
-msgstr "rozmiar danych nie zmieniony, pominiêto\n"
+msgstr "rozmiar danych nie zmieniony, pominiÄ™to\n"
 
 #: ../growfs/xfs_growfs.c:336
 #, c-format
 msgid "inode max pct unchanged, skipping\n"
-msgstr "maksymalny procent i-wêz³ów nie zmieniony, pominiêto\n"
+msgstr "maksymalny procent i-wÄ™zÅ‚Ã³w nie zmieniony, pominiÄ™to\n"
 
 #: ../growfs/xfs_growfs.c:343 ../growfs/xfs_growfs.c:382
 #: ../growfs/xfs_growfs.c:417
 #, c-format
 msgid "%s: growfs operation in progress already\n"
-msgstr "%s: operacja growfs ju¿ trwa\n"
+msgstr "%s: operacja growfs juÅ¼ trwa\n"
 
 #: ../growfs/xfs_growfs.c:347
 #, c-format
 msgid "%s: XFS_IOC_FSGROWFSDATA xfsctl failed: %s\n"
-msgstr "%s: xfsctl XFS_IOC_FSGROWFSDATA nie powiod³o siê: %s\n"
+msgstr "%s: xfsctl XFS_IOC_FSGROWFSDATA nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../growfs/xfs_growfs.c:363
 #, c-format
 msgid "realtime size %lld too large, maximum is %lld\n"
-msgstr "rozmiar realtime %lld zbyt du¿y, maksymalny to %lld\n"
+msgstr "rozmiar realtime %lld zbyt duÅ¼y, maksymalny to %lld\n"
 
 #: ../growfs/xfs_growfs.c:369
 #, c-format
 msgid "realtime size %lld too small, old size is %lld\n"
-msgstr "rozmiar realtime %lld zbyt ma³y, stary rozmiar to %lld\n"
+msgstr "rozmiar realtime %lld zbyt maÅ‚y, stary rozmiar to %lld\n"
 
 #: ../growfs/xfs_growfs.c:375
 #, c-format
 msgid "realtime size unchanged, skipping\n"
-msgstr "rozmiar realtime nie zmieniony, pominiêto\n"
+msgstr "rozmiar realtime nie zmieniony, pominiÄ™to\n"
 
 #: ../growfs/xfs_growfs.c:386
 #, c-format
 msgid "%s: realtime growth not implemented\n"
-msgstr "%s: powiêkszanie realtime nie jest zaimplementowane\n"
+msgstr "%s: powiÄ™kszanie realtime nie jest zaimplementowane\n"
 
 #: ../growfs/xfs_growfs.c:390
 #, c-format
 msgid "%s: XFS_IOC_FSGROWFSRT xfsctl failed: %s\n"
-msgstr "%s: xfsctl XFS_IOC_FSGROWFSRT nie powiod³o siê: %s\n"
+msgstr "%s: xfsctl XFS_IOC_FSGROWFSRT nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../growfs/xfs_growfs.c:411
 #, c-format
 msgid "log size unchanged, skipping\n"
-msgstr "rozmiar logu nie zmieniony, pominiêto\n"
+msgstr "rozmiar logu nie zmieniony, pominiÄ™to\n"
 
 #: ../growfs/xfs_growfs.c:421
 #, c-format
 msgid "%s: log growth not supported yet\n"
-msgstr "%s: powiêkszanie logu nie jest jeszcze obs³ugiwane\n"
+msgstr "%s: powiÄ™kszanie logu nie jest jeszcze obsÅ‚ugiwane\n"
 
 #: ../growfs/xfs_growfs.c:425
 #, c-format
 msgid "%s: XFS_IOC_FSGROWFSLOG xfsctl failed: %s\n"
-msgstr "%s: xfsctl XFS_IOC_FSGROWFSLOG nie powiod³o siê: %s\n"
+msgstr "%s: xfsctl XFS_IOC_FSGROWFSLOG nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../growfs/xfs_growfs.c:433
 #, c-format
 msgid "%s: XFS_IOC_FSGEOMETRY xfsctl failed: %s\n"
-msgstr "%s: xfsctl XFS_IOC_FSGEOMETRY nie powiod³o siê: %s\n"
+msgstr "%s: xfsctl XFS_IOC_FSGEOMETRY nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../growfs/xfs_growfs.c:438
 #, c-format
@@ -1024,7 +1024,7 @@ msgstr "bloki danych zmienione z %lld na %lld\n"
 #: ../growfs/xfs_growfs.c:441
 #, c-format
 msgid "inode max percent changed from %d to %d\n"
-msgstr "maksymalny procent i-wêz³ów zmieniony z %d na %d\n"
+msgstr "maksymalny procent i-wÄ™zÅ‚Ã³w zmieniony z %d na %d\n"
 
 #: ../growfs/xfs_growfs.c:444
 #, c-format
@@ -1034,7 +1034,7 @@ msgstr "bloki logu zmienione z %d na %d\n"
 #: ../growfs/xfs_growfs.c:447
 #, c-format
 msgid "log changed from %s to %s\n"
-msgstr "log zmieniony - by³ %s, jest %s\n"
+msgstr "log zmieniony - byÅ‚ %s, jest %s\n"
 
 #: ../growfs/xfs_growfs.c:451
 #, c-format
@@ -1076,29 +1076,29 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" wy¶wietlanie zbioru rozszerzonych flag i-wêz³ów zwi±zanych z bie¿±cym plikiem\n"
-"\n"
-" Ka¿da flaga jest wy¶wietlana jako pojedynczy znak, w tej kolejno¶ci:\n"
-" r - dane pliku s± zapisane w sekcji realtime\n"
-" p - plik ma ju¿ przydzielone fragmenty (nie do zmiany przez chattr)\n"
-" i - niezmienny, pliku nie mo¿na modyfikowaæ\n"
-" a - tylko do dopisywania, do pliku mo¿na tylko dopisywaæ\n"
-" s - wszystkie uaktualnienia s± synchroniczne\n"
-" A - czas dostêpu nie jest uaktualniany dla tego i-wêz³a\n"
-" d - nie do³±czanie pliku do zrzutu systemu plików\n"
-" t - wpisy tworzone w tym katalogu maj± domy¶lnie ustawiony bit realtime\n"
-" P - wpisy tworzone w tym katalogu maj± domy¶lnie ID projektu rodzica\n"
-" n - w tym katalogu nie mo¿na tworzyæ dowi±zañ symbolicznych\n"
-" e - dla plików nie-realtime - przestrzeganie warto¶ci rozmiaru fragmentu i-wêz³a\n"
-" E - wpisy tworzone w tym katalogu dziedzicz± warto¶æ rozmiaru fragmentu\n"
-" f - nie uwzglêdnianie tego pliku przy defragmentacji systemu plików\n"
-" S - w³±czenie przydzielania strumieni plikowych dla tego katalogu\n"
+" wyÅ›wietlanie zbioru rozszerzonych flag i-wÄ™zÅ‚Ã³w zwiÄ…zanych z bieÅ¼Ä…cym plikiem\n"
+"\n"
+" KaÅ¼da flaga jest wyÅ›wietlana jako pojedynczy znak, w tej kolejnoÅ›ci:\n"
+" r - dane pliku sÄ… zapisane w sekcji realtime\n"
+" p - plik ma juÅ¼ przydzielone fragmenty (nie do zmiany przez chattr)\n"
+" i - niezmienny, pliku nie moÅ¼na modyfikowaÄ‡\n"
+" a - tylko do dopisywania, do pliku moÅ¼na tylko dopisywaÄ‡\n"
+" s - wszystkie uaktualnienia sÄ… synchroniczne\n"
+" A - czas dostÄ™pu nie jest uaktualniany dla tego i-wÄ™zÅ‚a\n"
+" d - nie doÅ‚Ä…czanie pliku do zrzutu systemu plikÃ³w\n"
+" t - wpisy tworzone w tym katalogu majÄ… domyÅ›lnie ustawiony bit realtime\n"
+" P - wpisy tworzone w tym katalogu majÄ… domyÅ›lnie ID projektu rodzica\n"
+" n - w tym katalogu nie moÅ¼na tworzyÄ‡ dowiÄ…zaÅ„ symbolicznych\n"
+" e - dla plikÃ³w nie-realtime - przestrzeganie wartoÅ›ci rozmiaru fragmentu i-wÄ™zÅ‚a\n"
+" E - wpisy tworzone w tym katalogu dziedziczÄ… wartoÅ›Ä‡ rozmiaru fragmentu\n"
+" f - nie uwzglÄ™dnianie tego pliku przy defragmentacji systemu plikÃ³w\n"
+" S - wÅ‚Ä…czenie przydzielania strumieni plikowych dla tego katalogu\n"
 "\n"
 " Opcje:\n"
-" -R - rekurencyjne zag³êbianie siê (przydatne kiedy bie¿±cy plik jest katalogiem)\n"
-" -D - rekurencyjne zag³êbianie siê, ale wypisywanie atrybutów tylko katalogów\n"
-" -a - pokazywanie wszystkich flag, które mo¿na ustawiæ, obok ustawionych\n"
-" -v - tryb szczegó³owy; pokazywanie d³ugich nazw flag zamiast pojedynczych znaków\n"
+" -R - rekurencyjne zagÅ‚Ä™bianie siÄ™ (przydatne kiedy bieÅ¼Ä…cy plik jest katalogiem)\n"
+" -D - rekurencyjne zagÅ‚Ä™bianie siÄ™, ale wypisywanie atrybutÃ³w tylko katalogÃ³w\n"
+" -a - pokazywanie wszystkich flag, ktÃ³re moÅ¼na ustawiÄ‡, obok ustawionych\n"
+" -v - tryb szczegÃ³Å‚owy; pokazywanie dÅ‚ugich nazw flag zamiast pojedynczych znakÃ³w\n"
 "\n"
 
 #: ../io/attr.c:90
@@ -1134,33 +1134,33 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" zmiana zbioru rozszerzonych flag i-wêz³ów zwi±zanych z bie¿±cym plikiem\n"
-"\n"
-" Przyk³ady:\n"
-" 'chattr +a' - ustawia flagê tylko do dopisywania\n"
-" 'chattr -a' - zdejmuje flagê tylko do dopisywania\n"
-"\n"
-" -R - rekurencyjne zag³êbianie siê (przydatne kiedy bie¿±cy plik jest katalogiem)\n"
-" -D - rekurencyjne zag³êbianie siê, ale zmiana atrybutów tylko katalogów\n"
-" +/-r - ustawienie/zdjêcie flagi realtime\n"
-" +/-i - ustawienie/zdjêcie flagi immutable (niezmienno¶ci)\n"
-" +/-a - ustawienie/zdjêcie flagi append-only (tylko do dopisywania)\n"
-" +/-s - ustawienie/zdjêcie flagi sync (synchronicznego zapisu)\n"
-" +/-A - ustawienie/zdjêcie flagi no-atime\n"
-" +/-d - ustawienie/zdjêcie flagi no-dump\n"
-" +/-t - ustawienie/zdjêcie flagi dziedziczenia realtime\n"
-" +/-P - ustawienie/zdjêcie flagi dziedziczenia ID projektu\n"
-" +/-n - ustawienie/zdjêcie flagi braku dowi±zañ symbolicznych\n"
-" +/-e - ustawienie/zdjêcie flagi extent-size (rozmiaru fragmentu)\n"
-" +/-E - ustawienie/zdjêcie flagi dziedziczenia rozmiaru fragmentu\n"
-" +/-f - ustawienie/zdjêcie flagi no-defrag\n"
-" +/-S - ustawienie/zdjêcie flagi przydzielania strumieni plikowych\n"
-" Uwaga1: u¿ytkownik musi mieæ pewne uprawnienia do zmiany flag\n"
+" zmiana zbioru rozszerzonych flag i-wÄ™zÅ‚Ã³w zwiÄ…zanych z bieÅ¼Ä…cym plikiem\n"
+"\n"
+" PrzykÅ‚ady:\n"
+" 'chattr +a' - ustawia flagÄ™ tylko do dopisywania\n"
+" 'chattr -a' - zdejmuje flagÄ™ tylko do dopisywania\n"
+"\n"
+" -R - rekurencyjne zagÅ‚Ä™bianie siÄ™ (przydatne kiedy bieÅ¼Ä…cy plik jest katalogiem)\n"
+" -D - rekurencyjne zagÅ‚Ä™bianie siÄ™, ale zmiana atrybutÃ³w tylko katalogÃ³w\n"
+" +/-r - ustawienie/zdjÄ™cie flagi realtime\n"
+" +/-i - ustawienie/zdjÄ™cie flagi immutable (niezmiennoÅ›ci)\n"
+" +/-a - ustawienie/zdjÄ™cie flagi append-only (tylko do dopisywania)\n"
+" +/-s - ustawienie/zdjÄ™cie flagi sync (synchronicznego zapisu)\n"
+" +/-A - ustawienie/zdjÄ™cie flagi no-atime\n"
+" +/-d - ustawienie/zdjÄ™cie flagi no-dump\n"
+" +/-t - ustawienie/zdjÄ™cie flagi dziedziczenia realtime\n"
+" +/-P - ustawienie/zdjÄ™cie flagi dziedziczenia ID projektu\n"
+" +/-n - ustawienie/zdjÄ™cie flagi braku dowiÄ…zaÅ„ symbolicznych\n"
+" +/-e - ustawienie/zdjÄ™cie flagi extent-size (rozmiaru fragmentu)\n"
+" +/-E - ustawienie/zdjÄ™cie flagi dziedziczenia rozmiaru fragmentu\n"
+" +/-f - ustawienie/zdjÄ™cie flagi no-defrag\n"
+" +/-S - ustawienie/zdjÄ™cie flagi przydzielania strumieni plikowych\n"
+" Uwaga1: uÅ¼ytkownik musi mieÄ‡ pewne uprawnienia do zmiany flag\n"
 "         immutable/append-only\n"
-" Uwaga2: plików immutable/append-only nie mo¿na usuwaæ; usuwanie tych plików\n"
-"         wymaga zdjêcia flag immutable/append-only przed usuniêciem.\n"
-" Uwaga3: flagê realtime mo¿na ustawiæ tylko je¶li system plików ma sekcjê\n"
-"         realtime i (zwyk³y) plik musi byæ pusty przy ustawianiu flagi.\n"
+" Uwaga2: plikÃ³w immutable/append-only nie moÅ¼na usuwaÄ‡; usuwanie tych plikÃ³w\n"
+"         wymaga zdjÄ™cia flag immutable/append-only przed usuniÄ™ciem.\n"
+" Uwaga3: flagÄ™ realtime moÅ¼na ustawiÄ‡ tylko jeÅ›li system plikÃ³w ma sekcjÄ™\n"
+"         realtime i (zwykÅ‚y) plik musi byÄ‡ pusty przy ustawianiu flagi.\n"
 "\n"
 
 #: ../io/attr.c:171 ../io/attr.c:247 ../io/open.c:403 ../io/open.c:475
@@ -1168,18 +1168,18 @@ msgstr ""
 #: ../quota/project.c:105 ../quota/project.c:147 ../quota/project.c:191
 #, c-format
 msgid "%s: cannot open %s: %s\n"
-msgstr "%s: nie mo¿na otworzyæ %s: %s\n"
+msgstr "%s: nie moÅ¼na otworzyÄ‡ %s: %s\n"
 
 #: ../io/attr.c:174 ../io/attr.c:221 ../io/attr.c:250 ../io/attr.c:321
 #: ../quota/project.c:109 ../quota/project.c:152 ../quota/project.c:196
 #, c-format
 msgid "%s: cannot get flags on %s: %s\n"
-msgstr "%s: nie mo¿na pobraæ flag %s: %s\n"
+msgstr "%s: nie moÅ¼na pobraÄ‡ flag %s: %s\n"
 
 #: ../io/attr.c:256 ../io/attr.c:327
 #, c-format
 msgid "%s: cannot set flags on %s: %s\n"
-msgstr "%s: nie mo¿na ustawiæ flag %s: %s\n"
+msgstr "%s: nie moÅ¼na ustawiÄ‡ flag %s: %s\n"
 
 #: ../io/attr.c:291 ../io/attr.c:305
 #, c-format
@@ -1189,7 +1189,7 @@ msgstr "%s: nieznana flaga\n"
 #: ../io/attr.c:311
 #, c-format
 msgid "%s: bad chattr command, not +/-X\n"
-msgstr "%s: z³e polecenie chattr - nie +/-X\n"
+msgstr "%s: zÅ‚e polecenie chattr - nie +/-X\n"
 
 #: ../io/attr.c:336
 msgid "chattr"
@@ -1201,7 +1201,7 @@ msgstr "[-R|-D] [+/-"
 
 #: ../io/attr.c:343
 msgid "change extended inode flags on the currently open file"
-msgstr "zmiana rozszerzonych flag i-wêz³ów aktualnie otwartego pliku"
+msgstr "zmiana rozszerzonych flag i-wÄ™zÅ‚Ã³w aktualnie otwartego pliku"
 
 #: ../io/attr.c:346
 msgid "lsattr"
@@ -1213,7 +1213,7 @@ msgstr "[-R|-D|-a|-v]"
 
 #: ../io/attr.c:353
 msgid "list extended inode flags set on the currently open file"
-msgstr "wypisanie rozszerzonych flag i-wêz³ów aktualnie otwartego pliku"
+msgstr "wypisanie rozszerzonych flag i-wÄ™zÅ‚Ã³w aktualnie otwartego pliku"
 
 #: ../io/bmap.c:30
 #, c-format
@@ -1238,40 +1238,40 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" wypisanie mapowania bloków dla danych lub atrybutów pliku na XFS-ie\n"
-" Przyk³ad:\n"
-" 'bmap -vp' - szczegó³owa mapa w formacie tabeli wraz z nie zapisanymi\n"
+" wypisanie mapowania blokÃ³w dla danych lub atrybutÃ³w pliku na XFS-ie\n"
+" PrzykÅ‚ad:\n"
+" 'bmap -vp' - szczegÃ³Å‚owa mapa w formacie tabeli wraz z nie zapisanymi\n"
 "              fragmentami\n"
 "\n"
-" bmap wypisuje mapê bloków dysku u¿ywanych przez bie¿±cy plik.\n"
-" Mapa opisuje ka¿dy fragment u¿yty przez plik, a tak¿e regiony w pliku\n"
-" nie maj±ce przypisanych bloków (dziury).\n"
-" Domy¶lnie ka¿da linia listingu przyjmuje nastêpuj±c± postaæ:\n"
-"     fragment: [offsetpocz..offsetkoñc]: blokpocz..blokkoñc\n"
-" Dziury s± oznaczane przez zast±pienie blokpocz..blokkoñc przez 'dziura'.\n"
-" Wszystkie offsety w plikach i bloki dysku s± w jednostkach 512-bajtowych.\n"
-" -a - wypisanie mapy ga³êzi atrybutów zamiast ga³êzi danych.\n"
-" -d - pominiêcie zdarzenia odczytu DMAPI, pokazanie czê¶ci offline jako dziur.\n"
-" -l - wy¶wietlenie tak¿e d³ugo¶ci ka¿dego fragmentu w 512-bajtowych blokach.\n"
-" Uwaga: bmap dla plików nie bêd±cych plikami zwyk³ymi mo¿na uzyskaæ pod\n"
-" warunkiem, ¿e plik zosta³ otwarty odpowiednio (w szczególno¶ci musi byæ\n"
+" bmap wypisuje mapÄ™ blokÃ³w dysku uÅ¼ywanych przez bieÅ¼Ä…cy plik.\n"
+" Mapa opisuje kaÅ¼dy fragment uÅ¼yty przez plik, a takÅ¼e regiony w pliku\n"
+" nie majÄ…ce przypisanych blokÃ³w (dziury).\n"
+" DomyÅ›lnie kaÅ¼da linia listingu przyjmuje nastÄ™pujÄ…cÄ… postaÄ‡:\n"
+"     fragment: [offsetpocz..offsetkoÅ„c]: blokpocz..blokkoÅ„c\n"
+" Dziury sÄ… oznaczane przez zastÄ…pienie blokpocz..blokkoÅ„c przez 'dziura'.\n"
+" Wszystkie offsety w plikach i bloki dysku sÄ… w jednostkach 512-bajtowych.\n"
+" -a - wypisanie mapy gaÅ‚Ä™zi atrybutÃ³w zamiast gaÅ‚Ä™zi danych.\n"
+" -d - pominiÄ™cie zdarzenia odczytu DMAPI, pokazanie czÄ™Å›ci offline jako dziur.\n"
+" -l - wyÅ›wietlenie takÅ¼e dÅ‚ugoÅ›ci kaÅ¼dego fragmentu w 512-bajtowych blokach.\n"
+" Uwaga: bmap dla plikÃ³w nie bÄ™dÄ…cych plikami zwykÅ‚ymi moÅ¼na uzyskaÄ‡ pod\n"
+" warunkiem, Å¼e plik zostaÅ‚ otwarty odpowiednio (w szczegÃ³lnoÅ›ci musi byÄ‡\n"
 " otwarty tylko do odczytu).\n"
 "\n"
 
 #: ../io/bmap.c:120
 #, c-format
 msgid "%s: can't get geometry [\"%s\"]: %s\n"
-msgstr "%s: nie mo¿na uzyskaæ geometrii [\"%s\"]: %s\n"
+msgstr "%s: nie moÅ¼na uzyskaÄ‡ geometrii [\"%s\"]: %s\n"
 
 #: ../io/bmap.c:128
 #, c-format
 msgid "%s: cannot read attrs on \"%s\": %s\n"
-msgstr "%s: nie mo¿na odczytaæ atrybutów \"%s\": %s\n"
+msgstr "%s: nie moÅ¼na odczytaÄ‡ atrybutÃ³w \"%s\": %s\n"
 
 #: ../io/bmap.c:146
 #, c-format
 msgid "%s: malloc of %d bytes failed.\n"
-msgstr "%s: przydzielenie %d bajtów nie powiod³o siê.\n"
+msgstr "%s: przydzielenie %d bajtÃ³w nie powiodÅ‚o siÄ™.\n"
 
 #: ../io/bmap.c:194
 #, c-format
@@ -1281,12 +1281,12 @@ msgstr "%s: xfsctl(XFS_IOC_GETBMAPX) iflags=0x%x [\"%s\"]: %s\n"
 #: ../io/bmap.c:225
 #, c-format
 msgid "%s: cannot realloc %d bytes\n"
-msgstr "%s: nie mo¿na wykonaæ realloc na %d bajtów\n"
+msgstr "%s: nie moÅ¼na wykonaÄ‡ realloc na %d bajtÃ³w\n"
 
 #: ../io/bmap.c:234
 #, c-format
 msgid "%s: no extents\n"
-msgstr "%s: brak fragmentów\n"
+msgstr "%s: brak fragmentÃ³w\n"
 
 #: ../io/bmap.c:248 ../io/bmap.c:376
 #, c-format
@@ -1296,7 +1296,7 @@ msgstr "dziura"
 #: ../io/bmap.c:257
 #, c-format
 msgid " %lld blocks\n"
-msgstr " %lld bloków\n"
+msgstr " %lld blokÃ³w\n"
 
 #: ../io/bmap.c:336
 msgid "EXT"
@@ -1308,11 +1308,11 @@ msgstr "OFFSET-W-PLIKU"
 
 #: ../io/bmap.c:338
 msgid "RT-BLOCK-RANGE"
-msgstr "ZAKRES-BLOKÓW-RT"
+msgstr "ZAKRES-BLOKÃ“W-RT"
 
 #: ../io/bmap.c:338
 msgid "BLOCK-RANGE"
-msgstr "ZAKRES-BLOKÓW"
+msgstr "ZAKRES-BLOKÃ“W"
 
 #: ../io/bmap.c:339
 msgid "AG"
@@ -1333,32 +1333,32 @@ msgstr " FLAGI"
 #: ../io/bmap.c:410
 #, c-format
 msgid " FLAG Values:\n"
-msgstr " Warto¶ci FLAG:\n"
+msgstr " WartoÅ›ci FLAG:\n"
 
 #: ../io/bmap.c:411
 #, c-format
 msgid "    %*.*o Unwritten preallocated extent\n"
-msgstr "    %*.*o Nie zapisany, ju¿ przydzielony fragment\n"
+msgstr "    %*.*o Nie zapisany, juÅ¼ przydzielony fragment\n"
 
 #: ../io/bmap.c:413
 #, c-format
 msgid "    %*.*o Doesn't begin on stripe unit\n"
-msgstr "    %*.*o Nie zaczyna siê od jednostki pasa\n"
+msgstr "    %*.*o Nie zaczyna siÄ™ od jednostki pasa\n"
 
 #: ../io/bmap.c:415
 #, c-format
 msgid "    %*.*o Doesn't end   on stripe unit\n"
-msgstr "    %*.*o Nie koñczy siê na jednostce pasa\n"
+msgstr "    %*.*o Nie koÅ„czy siÄ™ na jednostce pasa\n"
 
 #: ../io/bmap.c:417
 #, c-format
 msgid "    %*.*o Doesn't begin on stripe width\n"
-msgstr "    %*.*o Nie zaczyna siê na szeroko¶ci pasa\n"
+msgstr "    %*.*o Nie zaczyna siÄ™ na szerokoÅ›ci pasa\n"
 
 #: ../io/bmap.c:419
 #, c-format
 msgid "    %*.*o Doesn't end   on stripe width\n"
-msgstr "    %*.*o Nie koñczy siê na szeroko¶ci pasa\n"
+msgstr "    %*.*o Nie koÅ„czy siÄ™ na szerokoÅ›ci pasa\n"
 
 #: ../io/bmap.c:430
 msgid "bmap"
@@ -1370,7 +1370,7 @@ msgstr "[-adlpv] [-n nx]"
 
 #: ../io/bmap.c:436
 msgid "print block mapping for an XFS file"
-msgstr "wypisanie mapowania bloków dla pliku na XFS-ie"
+msgstr "wypisanie mapowania blokÃ³w dla pliku na XFS-ie"
 
 #: ../io/fadvise.c:31
 #, c-format
@@ -1394,22 +1394,22 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" doradzenie buforowi stron w sprawie oczekiwanych schematów we/wy na bie¿±cym\n"
+" doradzenie buforowi stron w sprawie oczekiwanych schematÃ³w we/wy na bieÅ¼Ä…cym\n"
 " pliku\n"
 "\n"
-" fadvise modyfikuje zachowanie bufora stron przy operacjach na bie¿±cym pliku.\n"
-" Niektóre polecenia fadvise ([*] poni¿ej) wymagaj± podania zakresu.\n"
-" Bez argumentów zak³ada siê doradzenie POSIX_FADV_NORMAL.\n"
-" -d - podane strony nie s± wymagane (POSIX_FADV_DONTNEED) [*]\n"
-" -n - dostêp do danych bêdzie jednokrotny (POSIX_FADV_NOREUSE) [*]\n"
-" -r - nale¿y oczekiwaæ losowych odwo³añ do stron (POSIX_FADV_RANDOM)\n"
-" -s - nale¿y oczekiwaæ sekwencyjnych odwo³añ do stron (POSIX_FADV_SEQUENTIAL)\n"
-" -w - podane strony bêd± potrzebne (POSIX_FADV_WILLNEED) [*]\n"
-" Uwagi: te interfejsy nie by³y obs³ugiwane przez j±dra Linuksa przed 2.6.\n"
-"  NORMAL ustawia domy¶ln± warto¶æ czytania z wyprzedzeniem dla pliku.\n"
+" fadvise modyfikuje zachowanie bufora stron przy operacjach na bieÅ¼Ä…cym pliku.\n"
+" NiektÃ³re polecenia fadvise ([*] poniÅ¼ej) wymagajÄ… podania zakresu.\n"
+" Bez argumentÃ³w zakÅ‚ada siÄ™ doradzenie POSIX_FADV_NORMAL.\n"
+" -d - podane strony nie sÄ… wymagane (POSIX_FADV_DONTNEED) [*]\n"
+" -n - dostÄ™p do danych bÄ™dzie jednokrotny (POSIX_FADV_NOREUSE) [*]\n"
+" -r - naleÅ¼y oczekiwaÄ‡ losowych odwoÅ‚aÅ„ do stron (POSIX_FADV_RANDOM)\n"
+" -s - naleÅ¼y oczekiwaÄ‡ sekwencyjnych odwoÅ‚aÅ„ do stron (POSIX_FADV_SEQUENTIAL)\n"
+" -w - podane strony bÄ™dÄ… potrzebne (POSIX_FADV_WILLNEED) [*]\n"
+" Uwagi: te interfejsy nie byÅ‚y obsÅ‚ugiwane przez jÄ…dra Linuksa przed 2.6.\n"
+"  NORMAL ustawia domyÅ›lnÄ… wartoÅ›Ä‡ czytania z wyprzedzeniem dla pliku.\n"
 "  RANDOM ustawia czytanie z wyprzedzeniem dla pliku na zero.\n"
-"  SEQUENTIAL ustawia podwójn± domy¶ln± warto¶æ czytania z wyprzedzeniem.\n"
-"  WILLNEED i NOREUSE s± równoznaczne i wymuszaj± maksymalne czytanie\n"
+"  SEQUENTIAL ustawia podwÃ³jnÄ… domyÅ›lnÄ… wartoÅ›Ä‡ czytania z wyprzedzeniem.\n"
+"  WILLNEED i NOREUSE sÄ… rÃ³wnoznaczne i wymuszajÄ… maksymalne czytanie\n"
 "  z wyprzedzeniem.\n"
 "\n"
 
@@ -1418,7 +1418,7 @@ msgstr ""
 #: ../io/pwrite.c:282 ../io/sendfile.c:126
 #, c-format
 msgid "non-numeric offset argument -- %s\n"
-msgstr "nieliczbowy argument bêd±cy offsetem - %s\n"
+msgstr "nieliczbowy argument bÄ™dÄ…cy offsetem - %s\n"
 
 #: ../io/fadvise.c:100 ../io/madvise.c:94 ../io/mincore.c:54 ../io/mmap.c:212
 #: ../io/mmap.c:308 ../io/mmap.c:394 ../io/mmap.c:553 ../io/pread.c:330
@@ -1426,7 +1426,7 @@ msgstr "nieliczbowy argument b
 #: ../io/sendfile.c:133
 #, c-format
 msgid "non-numeric length argument -- %s\n"
-msgstr "nieliczbowy argument bêd±cy d³ugo¶ci± - %s\n"
+msgstr "nieliczbowy argument bÄ™dÄ…cy dÅ‚ugoÅ›ciÄ… - %s\n"
 
 #: ../io/fadvise.c:118
 msgid "fadvise"
@@ -1434,7 +1434,7 @@ msgstr "fadvise"
 
 #: ../io/fadvise.c:123
 msgid "[-dnrsw] [off len]"
-msgstr "[-dnrsw] [offset d³ugo¶æ]"
+msgstr "[-dnrsw] [offset dÅ‚ugoÅ›Ä‡]"
 
 #: ../io/fadvise.c:124
 msgid "advisory commands for sections of a file"
@@ -1463,11 +1463,11 @@ msgstr "niesynchr"
 
 #: ../io/file.c:43 ../io/open.c:83
 msgid "direct"
-msgstr "bezpo¶redni"
+msgstr "bezpoÅ›redni"
 
 #: ../io/file.c:43 ../io/open.c:83
 msgid "non-direct"
-msgstr "niebezpo¶redni"
+msgstr "niebezpoÅ›redni"
 
 #: ../io/file.c:44 ../io/open.c:84
 msgid "read-only"
@@ -1487,12 +1487,12 @@ msgstr ",tylko dopisywanie"
 
 #: ../io/file.c:47 ../io/open.c:87
 msgid ",non-block"
-msgstr ",nieblokuj±cy"
+msgstr ",nieblokujÄ…cy"
 
 #: ../io/file.c:81 ../io/sendfile.c:103 ../quota/path.c:112
 #, c-format
 msgid "value %d is out of range (0-%d)\n"
-msgstr "warto¶æ %d jest spoza zakresu (0-%d)\n"
+msgstr "wartoÅ›Ä‡ %d jest spoza zakresu (0-%d)\n"
 
 #: ../io/file.c:92
 msgid "file"
@@ -1508,7 +1508,7 @@ msgstr "[N]"
 
 #: ../io/file.c:99
 msgid "set the current file"
-msgstr "ustawienie bie¿±cego pliku"
+msgstr "ustawienie bieÅ¼Ä…cego pliku"
 
 #: ../io/file.c:101 ../quota/path.c:133
 msgid "print"
@@ -1520,17 +1520,17 @@ msgstr "p"
 
 #: ../io/file.c:108
 msgid "list current open files and memory mappings"
-msgstr "wypisanie aktualnie otwartych plików i odwzorowañ w pamiêci"
+msgstr "wypisanie aktualnie otwartych plikÃ³w i odwzorowaÅ„ w pamiÄ™ci"
 
 #: ../io/freeze.c:37
 #, c-format
 msgid "%s: cannot freeze filesystem at %s: %s\n"
-msgstr "%s: nie mo¿na zamroziæ systemu plików na %s: %s\n"
+msgstr "%s: nie moÅ¼na zamroziÄ‡ systemu plikÃ³w na %s: %s\n"
 
 #: ../io/freeze.c:54
 #, c-format
 msgid "%s: cannot unfreeze filesystem mounted at %s: %s\n"
-msgstr "%s: nie mo¿na odmroziæ systemu plików podmontowanego pod %s: %s\n"
+msgstr "%s: nie moÅ¼na odmroziÄ‡ systemu plikÃ³w podmontowanego pod %s: %s\n"
 
 #: ../io/freeze.c:65
 msgid "freeze"
@@ -1538,7 +1538,7 @@ msgstr "freeze"
 
 #: ../io/freeze.c:70
 msgid "freeze filesystem of current file"
-msgstr "zamro¿enie systemu plików na bie¿±cym pliku"
+msgstr "zamroÅ¼enie systemu plikÃ³w na bieÅ¼Ä…cym pliku"
 
 #: ../io/freeze.c:72
 msgid "thaw"
@@ -1546,7 +1546,7 @@ msgstr "thaw"
 
 #: ../io/freeze.c:77
 msgid "unfreeze filesystem of current file"
-msgstr "odmro¿enie systemu plików na bie¿±cym pliku"
+msgstr "odmroÅ¼enie systemu plikÃ³w na bieÅ¼Ä…cym pliku"
 
 #: ../io/fsync.c:54
 msgid "fsync"
@@ -1559,7 +1559,7 @@ msgstr " "
 
 #: ../io/fsync.c:59
 msgid "calls fsync(2) to flush all in-core file state to disk"
-msgstr "wywo³anie fsync(2) aby zrzuciæ ca³y stan pliku z pamiêci na dysk"
+msgstr "wywoÅ‚anie fsync(2) aby zrzuciÄ‡ caÅ‚y stan pliku z pamiÄ™ci na dysk"
 
 #: ../io/fsync.c:61
 msgid "fdatasync"
@@ -1571,7 +1571,7 @@ msgstr "ds"
 
 #: ../io/fsync.c:66
 msgid "calls fdatasync(2) to flush the files in-core data to disk"
-msgstr "wywo³anie fdatasync(2) aby zrzuciæ dane pliku z pamiêci na dysk"
+msgstr "wywoÅ‚anie fdatasync(2) aby zrzuciÄ‡ dane pliku z pamiÄ™ci na dysk"
 
 #: ../io/getrusage.c:112
 msgid "getrusage"
@@ -1583,12 +1583,12 @@ msgstr "g"
 
 #: ../io/getrusage.c:118
 msgid "report process resource usage"
-msgstr "informacje o wykorzystaniu zasobów przez proces"
+msgstr "informacje o wykorzystaniu zasobÃ³w przez proces"
 
 #: ../io/imap.c:53
 #, c-format
 msgid "ino %10llu count %2d mask %016llx\n"
-msgstr "i-wêze³ %10llu liczba %2d maska %016llx\n"
+msgstr "i-wÄ™zeÅ‚ %10llu liczba %2d maska %016llx\n"
 
 #: ../io/imap.c:67
 msgid "imap"
@@ -1596,32 +1596,32 @@ msgstr "imap"
 
 #: ../io/imap.c:71
 msgid "[nentries]"
-msgstr "[liczba_wpisów]"
+msgstr "[liczba_wpisÃ³w]"
 
 #: ../io/imap.c:73
 msgid "inode map for filesystem of current file"
-msgstr "map i-wêz³ów dla systemu plików bie¿±cego pliku"
+msgstr "map i-wÄ™zÅ‚Ã³w dla systemu plikÃ³w bieÅ¼Ä…cego pliku"
 
 #: ../io/init.c:35
 #, c-format
 msgid "Usage: %s [-adFfmrRstx] [-p prog] [-c cmd]... file\n"
-msgstr "Sk³adnia: %s [-adFfmrRstx] [-p program] [-c polecenie]... plik\n"
+msgstr "SkÅ‚adnia: %s [-adFfmrRstx] [-p program] [-c polecenie]... plik\n"
 
 #: ../io/init.c:98 ../io/mmap.c:168 ../io/mmap.c:175 ../io/mmap.c:178
 #: ../io/open.c:281
 #, c-format
 msgid "no files are open, try 'help open'\n"
-msgstr "nie ma otwartych plików, spróbuj 'help open'\n"
+msgstr "nie ma otwartych plikÃ³w, sprÃ³buj 'help open'\n"
 
 #: ../io/init.c:102 ../io/mmap.c:167 ../io/mmap.c:174
 #, c-format
 msgid "no mapped regions, try 'help mmap'\n"
-msgstr "nie ma podmapowanych regionów, spróbuj 'help mmap'\n"
+msgstr "nie ma podmapowanych regionÃ³w, sprÃ³buj 'help mmap'\n"
 
 #: ../io/init.c:108
 #, c-format
 msgid "foreign file active, %s command is for XFS filesystems only\n"
-msgstr "aktywny jest plik obcy, polecenie %s jest tylko dla systemów plików XFS\n"
+msgstr "aktywny jest plik obcy, polecenie %s jest tylko dla systemÃ³w plikÃ³w XFS\n"
 
 #: ../io/init.c:153 ../io/open.c:303
 #, c-format
@@ -1643,16 +1643,16 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" wprowadzenie b³êdów do systemu plików aktualnie otwartego pliku\n"
+" wprowadzenie bÅ‚Ä™dÃ³w do systemu plikÃ³w aktualnie otwartego pliku\n"
 "\n"
-" Przyk³ad:\n"
-" 'inject readagf' - spowodowanie b³êdów przy odczytach wolnego miejsca grup\n"
+" PrzykÅ‚ad:\n"
+" 'inject readagf' - spowodowanie bÅ‚Ä™dÃ³w przy odczytach wolnego miejsca grup\n"
 "                    alokacji\n"
 "\n"
-" inject powoduje, ¿e j±dro generuje i reaguje na b³êdy wewn±trz XFS-a,\n"
-" pod warunkiem, ¿e kod XFS-a w j±drze zosta³ zbudowany z w³±czonymi opcjami\n"
-" diagnostycznymi. Bez argumentów wy¶wietla listê znaczników wprowadzania\n"
-" b³êdów.\n"
+" inject powoduje, Å¼e jÄ…dro generuje i reaguje na bÅ‚Ä™dy wewnÄ…trz XFS-a,\n"
+" pod warunkiem, Å¼e kod XFS-a w jÄ…drze zostaÅ‚ zbudowany z wÅ‚Ä…czonymi opcjami\n"
+" diagnostycznymi. Bez argumentÃ³w wyÅ›wietla listÄ™ znacznikÃ³w wprowadzania\n"
+" bÅ‚Ä™dÃ³w.\n"
 "\n"
 
 #: ../io/inject.c:135
@@ -1670,7 +1670,7 @@ msgstr "[znacznik ...]"
 
 #: ../io/inject.c:157
 msgid "inject errors into a filesystem"
-msgstr "wprowadzanie b³êdów do systemu plików"
+msgstr "wprowadzanie bÅ‚Ä™dÃ³w do systemu plikÃ³w"
 
 #: ../io/madvise.c:32
 #, c-format
@@ -1693,19 +1693,19 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" doradzenie buforowi stron w sprawie oczekiwanych schematów dostêpu do odwzorowañ\n"
+" doradzenie buforowi stron w sprawie oczekiwanych schematÃ³w dostÄ™pu do odwzorowaÅ„\n"
 "\n"
-" madvise modyfikuje zachowanie bufora stron przy operacjach na bie¿±cym\n"
-" odwzorowaniu. Niektóre polecenia madvise ([*] poni¿ej) wymagaj± podania zakresu.\n"
-" Bez argumentów zak³ada siê doradzenie POSIX_MADV_NORMAL.\n"
-" -d - podane strony nie s± wymagane (POSIX_MADV_DONTNEED) [*]\n"
-" -r - nale¿y oczekiwaæ losowych odwo³añ do stron (POSIX_MADV_RANDOM)\n"
-" -s - nale¿y oczekiwaæ sekwencyjnych odwo³añ do stron (POSIX_MADV_SEQUENTIAL)\n"
-" -w - podane strony bêd± potrzebne (POSIX_MADV_WILLNEED) [*]\n"
+" madvise modyfikuje zachowanie bufora stron przy operacjach na bieÅ¼Ä…cym\n"
+" odwzorowaniu. NiektÃ³re polecenia madvise ([*] poniÅ¼ej) wymagajÄ… podania zakresu.\n"
+" Bez argumentÃ³w zakÅ‚ada siÄ™ doradzenie POSIX_MADV_NORMAL.\n"
+" -d - podane strony nie sÄ… wymagane (POSIX_MADV_DONTNEED) [*]\n"
+" -r - naleÅ¼y oczekiwaÄ‡ losowych odwoÅ‚aÅ„ do stron (POSIX_MADV_RANDOM)\n"
+" -s - naleÅ¼y oczekiwaÄ‡ sekwencyjnych odwoÅ‚aÅ„ do stron (POSIX_MADV_SEQUENTIAL)\n"
+" -w - podane strony bÄ™dÄ… potrzebne (POSIX_MADV_WILLNEED) [*]\n"
 " Uwagi:\n"
-"  NORMAL ustawia domy¶ln± warto¶æ czytania z wyprzedzeniem dla pliku.\n"
+"  NORMAL ustawia domyÅ›lnÄ… wartoÅ›Ä‡ czytania z wyprzedzeniem dla pliku.\n"
 "  RANDOM ustawia czytanie z wyprzedzeniem dla pliku na zero.\n"
-"  SEQUENTIAL ustawia podwójn± domy¶ln± warto¶æ czytania z wyprzedzeniem.\n"
+"  SEQUENTIAL ustawia podwÃ³jnÄ… domyÅ›lnÄ… wartoÅ›Ä‡ czytania z wyprzedzeniem.\n"
 "  WILLNEED wymusza maksymalne czytanie z wyprzedzeniem.\n"
 "\n"
 
@@ -1719,11 +1719,11 @@ msgstr "ma"
 
 #: ../io/madvise.c:122
 msgid "[-drsw] [off len]"
-msgstr "[-drsw] [offset d³ugo¶æ]"
+msgstr "[-drsw] [offset dÅ‚ugoÅ›Ä‡]"
 
 #: ../io/madvise.c:123
 msgid "give advice about use of memory"
-msgstr "doradzenie w sprawie u¿ycia pamiêci"
+msgstr "doradzenie w sprawie uÅ¼ycia pamiÄ™ci"
 
 #: ../io/mincore.c:87 ../io/mincore.c:97
 #, c-format
@@ -1740,31 +1740,31 @@ msgstr "mi"
 
 #: ../io/mincore.c:117
 msgid "[off len]"
-msgstr "[offset d³ugo¶æ]"
+msgstr "[offset dÅ‚ugoÅ›Ä‡]"
 
 #: ../io/mincore.c:118
 msgid "find mapping pages that are memory resident"
-msgstr "odnalezienie stron odwzorowañ przechowywanych w pamiêci"
+msgstr "odnalezienie stron odwzorowaÅ„ przechowywanych w pamiÄ™ci"
 
 #: ../io/mmap.c:76
 #, c-format
 msgid "offset (%lld) is before start of mapping (%lld)\n"
-msgstr "offset (%lld) przed pocz±tkiem odwzorowania (%lld)\n"
+msgstr "offset (%lld) przed poczÄ…tkiem odwzorowania (%lld)\n"
 
 #: ../io/mmap.c:82
 #, c-format
 msgid "offset (%lld) is beyond end of mapping (%lld)\n"
-msgstr "offset (%lld) za koñcem odwzorowania (%lld)\n"
+msgstr "offset (%lld) za koÅ„cem odwzorowania (%lld)\n"
 
 #: ../io/mmap.c:87
 #, c-format
 msgid "range (%lld:%lld) is beyond mapping (%lld:%ld)\n"
-msgstr "przedzia³ (%lld:%lld) poza odwzorowaniem (%lld:%ld)\n"
+msgstr "przedziaÅ‚ (%lld:%lld) poza odwzorowaniem (%lld:%ld)\n"
 
 #: ../io/mmap.c:93
 #, c-format
 msgid "offset address (%p) is not page aligned\n"
-msgstr "adres offsetu (%p) nie jest wyrównany do rozmiaru strony\n"
+msgstr "adres offsetu (%p) nie jest wyrÃ³wnany do rozmiaru strony\n"
 
 #: ../io/mmap.c:133
 #, c-format
@@ -1787,21 +1787,21 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" odwzorowanie przedzia³u z bie¿±cego pliku w pamiêci\n"
+" odwzorowanie przedziaÅ‚u z bieÅ¼Ä…cego pliku w pamiÄ™ci\n"
 "\n"
-"Przyk³ad:\n"
-" 'mmap -rw 0 1m' - odwzorowuje 1MB od pocz±tku bie¿±cego pliku\n"
+"PrzykÅ‚ad:\n"
+" 'mmap -rw 0 1m' - odwzorowuje 1MB od poczÄ…tku bieÅ¼Ä…cego pliku\n"
 "\n"
-" mmap odwzorowuje w pamiêci przedzia³ z pliku do dalszego wykorzystania przez\n"
+" mmap odwzorowuje w pamiÄ™ci przedziaÅ‚ z pliku do dalszego wykorzystania przez\n"
 " inne polecenia xfs_io.\n"
-" Bez argumentów mmap pokazuje aktualne odwzorowania. Bie¿±ce odwzorowanie\n"
-" mo¿na ustawiæ przy u¿yciu formy jednoargumentowej (mmap numer lub adres).\n"
-" Je¶li podano dwa argumenty (przedzia³), tworzone jest nowe odwzorowanie\n"
-" i dostêpne s± nastêpuj±ce opcje:\n"
-" -r - odwzorowanie z ochron± PROT_READ\n"
-" -w - odwzorowanie z ochron± PROT_WRITE\n"
-" -x - odwzorowanie z ochron± PROT_EXEC\n"
-" Je¶li nie podano trybu ochrony, domy¶lnie u¿ywane s± wszystkie.\n"
+" Bez argumentÃ³w mmap pokazuje aktualne odwzorowania. BieÅ¼Ä…ce odwzorowanie\n"
+" moÅ¼na ustawiÄ‡ przy uÅ¼yciu formy jednoargumentowej (mmap numer lub adres).\n"
+" JeÅ›li podano dwa argumenty (przedziaÅ‚), tworzone jest nowe odwzorowanie\n"
+" i dostÄ™pne sÄ… nastÄ™pujÄ…ce opcje:\n"
+" -r - odwzorowanie z ochronÄ… PROT_READ\n"
+" -w - odwzorowanie z ochronÄ… PROT_WRITE\n"
+" -x - odwzorowanie z ochronÄ… PROT_EXEC\n"
+" JeÅ›li nie podano trybu ochrony, domyÅ›lnie uÅ¼ywane sÄ… wszystkie.\n"
 "\n"
 
 #: ../io/mmap.c:254
@@ -1820,15 +1820,15 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" zrzucenie przedzia³u bajtów w bie¿±cym odwzorowaniu pamiêci\n"
+" zrzucenie przedziaÅ‚u bajtÃ³w w bieÅ¼Ä…cym odwzorowaniu pamiÄ™ci\n"
 "\n"
-" msync zapisuje wszystkie zmodyfikowane kopie stron z podanego przedzia³u\n"
-" (lub ca³ego odwzorowania, je¶li nie podano przedzia³u) do miejsca\n"
-" przechowywania danych. Opcjonalnie uniewa¿nia bufor, ¿eby dalsze odwo³ania\n"
-" do tych stron odbywa³y siê z miejsca przechowywania danych (zamiast kopii\n"
-" w pamiêci podrêcznej).\n"
+" msync zapisuje wszystkie zmodyfikowane kopie stron z podanego przedziaÅ‚u\n"
+" (lub caÅ‚ego odwzorowania, jeÅ›li nie podano przedziaÅ‚u) do miejsca\n"
+" przechowywania danych. Opcjonalnie uniewaÅ¼nia bufor, Å¼eby dalsze odwoÅ‚ania\n"
+" do tych stron odbywaÅ‚y siÄ™ z miejsca przechowywania danych (zamiast kopii\n"
+" w pamiÄ™ci podrÄ™cznej).\n"
 " -a - wykonanie zapisu asynchronicznego (MS_ASYNC)\n"
-" -i - uniewa¿nienie odwzorowanych stron (MS_INVALIDATE)\n"
+" -i - uniewaÅ¼nienie odwzorowanych stron (MS_INVALIDATE)\n"
 " -s - wykonanie zapisu synchronicznego (MS_SYNC)\n"
 "\n"
 
@@ -1856,25 +1856,25 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" odczytanie przedzia³u bajtów w bie¿±cym odwzorowaniu pamiêci\n"
+" odczytanie przedziaÅ‚u bajtÃ³w w bieÅ¼Ä…cym odwzorowaniu pamiÄ™ci\n"
 "\n"
-" Przyk³ad:\n"
-" 'mread -v 512 20' - wyrzucenie 20 bajtów odczytanych od 512 bajtu\n"
+" PrzykÅ‚ad:\n"
+" 'mread -v 512 20' - wyrzucenie 20 bajtÃ³w odczytanych od 512 bajtu\n"
 "                     w odwzorowaniu\n"
 "\n"
-" mread odwo³uje siê do przedzia³u bie¿±cego odwzorowania pamiêci, opcjonalnie\n"
-" wyrzucaj±c go na strumieñ standardowego wyj¶cia (z opcj± -v) do dalszych badañ.\n"
-" -f - tryb szczegó³owy, wyrzucenie bajtów z offsetami wzglêdem pocz±tku pliku.\n"
-" -r - odwrotna kolejno¶æ; dostêp pocz±wszy od koñca przedzia³u do pocz±tku.\n"
-" -v - tryb szczegó³owy, wyrzucenie bajtów z offsetami wzglêdem pocz±tku\n"
+" mread odwoÅ‚uje siÄ™ do przedziaÅ‚u bieÅ¼Ä…cego odwzorowania pamiÄ™ci, opcjonalnie\n"
+" wyrzucajÄ…c go na strumieÅ„ standardowego wyjÅ›cia (z opcjÄ… -v) do dalszych badaÅ„.\n"
+" -f - tryb szczegÃ³Å‚owy, wyrzucenie bajtÃ³w z offsetami wzglÄ™dem poczÄ…tku pliku.\n"
+" -r - odwrotna kolejnoÅ›Ä‡; dostÄ™p poczÄ…wszy od koÅ„ca przedziaÅ‚u do poczÄ…tku.\n"
+" -v - tryb szczegÃ³Å‚owy, wyrzucenie bajtÃ³w z offsetami wzglÄ™dem poczÄ…tku\n"
 " odwzorowania.\n"
-" Dostêpy s± wykonywane sekwencyjnie, domy¶lnie od offsetu pocz±tkowego.\n"
+" DostÄ™py sÄ… wykonywane sekwencyjnie, domyÅ›lnie od offsetu poczÄ…tkowego.\n"
 " Uwagi:\n"
-"   Odwo³ania do ca³ych stron za koñcem pliku powoduj± w efekcie sygna³ SIGBUS.\n"
-"   Sygna³y SIGBUS mog± byæ wywo³ane tak¿e przy ró¿nych zdarzeniach zwi±zanych\n"
-"   z systemem plików, w³±cznie z b³êdami przekroczenia limitów (quota) oraz\n"
-"   fizycznymi b³êdami urz±dzenia (takimi jak nieczytelne bloki dysku). Na tym\n"
-"   etapie nie ma prób wy³apania sygna³ów...\n"
+"   OdwoÅ‚ania do caÅ‚ych stron za koÅ„cem pliku powodujÄ… w efekcie sygnaÅ‚ SIGBUS.\n"
+"   SygnaÅ‚y SIGBUS mogÄ… byÄ‡ wywoÅ‚ane takÅ¼e przy rÃ³Å¼nych zdarzeniach zwiÄ…zanych\n"
+"   z systemem plikÃ³w, wÅ‚Ä…cznie z bÅ‚Ä™dami przekroczenia limitÃ³w (quota) oraz\n"
+"   fizycznymi bÅ‚Ä™dami urzÄ…dzenia (takimi jak nieczytelne bloki dysku). Na tym\n"
+"   etapie nie ma prÃ³b wyÅ‚apania sygnaÅ‚Ã³w...\n"
 "\n"
 
 #: ../io/mmap.c:494
@@ -1894,17 +1894,17 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" zmiana przedzia³u bajtów w bie¿±cym odwzorowaniu pamiêci\n"
+" zmiana przedziaÅ‚u bajtÃ³w w bieÅ¼Ä…cym odwzorowaniu pamiÄ™ci\n"
 "\n"
-" Przyk³ad:\n"
-" 'mwrite 512 20' - zapisuje 20 bajtów od 512 bajtu w bie¿±cym odwzorowaniu.\n"
+" PrzykÅ‚ad:\n"
+" 'mwrite 512 20' - zapisuje 20 bajtÃ³w od 512 bajtu w bieÅ¼Ä…cym odwzorowaniu.\n"
 "\n"
-" mwrite zapisuje bajt do przedzia³u pamiêci w ramach odwzorowania.\n"
-" Domy¶lnie zapisywan± warto¶ci± jest 'X', powtarzane do wype³nienia przedzia³u.\n"
-" -S - u¿ycie alternatywnego znaku\n"
-" -r - odwrotna kolejno¶æ; rozpoczêcie zapisywania od koñca przedzia³u do\n"
-" pocz±tku\n"
-" Zapisy s± wykonywane kolejno, domy¶lnie od offsetu pocz±tkowego.\n"
+" mwrite zapisuje bajt do przedziaÅ‚u pamiÄ™ci w ramach odwzorowania.\n"
+" DomyÅ›lnie zapisywanÄ… wartoÅ›ciÄ… jest 'X', powtarzane do wypeÅ‚nienia przedziaÅ‚u.\n"
+" -S - uÅ¼ycie alternatywnego znaku\n"
+" -r - odwrotna kolejnoÅ›Ä‡; rozpoczÄ™cie zapisywania od koÅ„ca przedziaÅ‚u do\n"
+" poczÄ…tku\n"
+" Zapisy sÄ… wykonywane kolejno, domyÅ›lnie od offsetu poczÄ…tkowego.\n"
 "\n"
 
 #: ../io/mmap.c:530 ../io/pread.c:315 ../io/pwrite.c:249 ../io/pwrite.c:268
@@ -1922,11 +1922,11 @@ msgstr "mm"
 
 #: ../io/mmap.c:586
 msgid "[N] | [-rwx] [off len]"
-msgstr "[N] | [-rwx] [offset d³ugo¶æ]"
+msgstr "[N] | [-rwx] [offset dÅ‚ugoÅ›Ä‡]"
 
 #: ../io/mmap.c:588
 msgid "mmap a range in the current file, show mappings"
-msgstr "odwzorowanie przedzia³u w bie¿±cym pliku, pokazanie odwzorowañ"
+msgstr "odwzorowanie przedziaÅ‚u w bieÅ¼Ä…cym pliku, pokazanie odwzorowaÅ„"
 
 #: ../io/mmap.c:591
 msgid "mread"
@@ -1938,11 +1938,11 @@ msgstr "mr"
 
 #: ../io/mmap.c:597
 msgid "[-r] [off len]"
-msgstr "[-r] [offset d³ugo¶æ]"
+msgstr "[-r] [offset dÅ‚ugoÅ›Ä‡]"
 
 #: ../io/mmap.c:599
 msgid "reads data from a region in the current memory mapping"
-msgstr "odczyt danych z regionu w bie¿±cym odwzorowaniu pamiêci"
+msgstr "odczyt danych z regionu w bieÅ¼Ä…cym odwzorowaniu pamiÄ™ci"
 
 #: ../io/mmap.c:602
 msgid "msync"
@@ -1954,11 +1954,11 @@ msgstr "ms"
 
 #: ../io/mmap.c:608
 msgid "[-ais] [off len]"
-msgstr "[-ais] [offset d³ugo¶æ]"
+msgstr "[-ais] [offset dÅ‚ugoÅ›Ä‡]"
 
 #: ../io/mmap.c:609
 msgid "flush a region in the current memory mapping"
-msgstr "zrzucenie regionu w bie¿±cym odwzorowaniu pamiêci"
+msgstr "zrzucenie regionu w bieÅ¼Ä…cym odwzorowaniu pamiÄ™ci"
 
 #: ../io/mmap.c:612
 msgid "munmap"
@@ -1970,7 +1970,7 @@ msgstr "mu"
 
 #: ../io/mmap.c:618
 msgid "unmaps the current memory mapping"
-msgstr "usuniêcie bie¿±cego odwzorowania pamiêci"
+msgstr "usuniÄ™cie bieÅ¼Ä…cego odwzorowania pamiÄ™ci"
 
 #: ../io/mmap.c:620
 msgid "mwrite"
@@ -1982,11 +1982,11 @@ msgstr "mw"
 
 #: ../io/mmap.c:626
 msgid "[-r] [-S seed] [off len]"
-msgstr "[-r] [-S warto¶æ] [offset d³ugo¶æ]"
+msgstr "[-r] [-S wartoÅ›Ä‡] [offset dÅ‚ugoÅ›Ä‡]"
 
 #: ../io/mmap.c:628
 msgid "writes data into a region in the current memory mapping"
-msgstr "zapis danych do regionu w bie¿±cym odwzorowaniu pamiêci"
+msgstr "zapis danych do regionu w bieÅ¼Ä…cym odwzorowaniu pamiÄ™ci"
 
 #: ../io/open.c:53
 msgid "socket"
@@ -1998,19 +1998,19 @@ msgstr "katalog"
 
 #: ../io/open.c:57
 msgid "char device"
-msgstr "urz±dzenie znakowe"
+msgstr "urzÄ…dzenie znakowe"
 
 #: ../io/open.c:59
 msgid "block device"
-msgstr "urz±dzenie blokowe"
+msgstr "urzÄ…dzenie blokowe"
 
 #: ../io/open.c:61
 msgid "regular file"
-msgstr "plik zwyk³y"
+msgstr "plik zwykÅ‚y"
 
 #: ../io/open.c:63
 msgid "symbolic link"
-msgstr "dowi±zanie symboliczne"
+msgstr "dowiÄ…zanie symboliczne"
 
 #: ../io/open.c:65
 msgid "fifo"
@@ -2129,29 +2129,29 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" otwarcie nowego pliku w ¿±danym trybie\n"
+" otwarcie nowego pliku w Å¼Ä…danym trybie\n"
 "\n"
-" Przyk³ad:\n"
+" PrzykÅ‚ad:\n"
 " 'open -cd /tmp/data' - utworzenie/otwarcie pliku danych do odczytu i zapisu\n"
-"                        z bezpo¶rednim we/wy\n"
+"                        z bezpoÅ›rednim we/wy\n"
 "\n"
-" open otwiera plik do pó¼niejszego wykorzystania przez wszystkie inne polecenia\n"
+" open otwiera plik do pÃ³Åºniejszego wykorzystania przez wszystkie inne polecenia\n"
 " xfs_io.\n"
-" Bez argumentów u¿ywa polecenia stat do pokazania bie¿±cego pliku.\n"
-" -F - plik na obcym systemie plików, zabronienie u¿ywania poleceñ dla XFS-a\n"
-" -a - otwarcie z flag± O_APPEND (w trybie tylko dopisywania)\n"
-" -d - otwarcie z flag± O_DIRECT (niebuforowane we/wy, ograniczenia wyrównania)\n"
-" -f - otwarcie z flag± O_CREAT (utworzenie pliku je¶li nie istnieje)\n"
-" -m - uprawnienia do u¿ycia w przypadku tworzenia pliku (domy¶lnie 0600)\n"
-" -n - otwarcie z flag± O_NONBLOCK\n"
-" -r - otwarcie z flag± O_RDONLY (domy¶lne jest O_RDWR)\n"
-" -s - otwarcie z flag± O_SYNC\n"
-" -t - otwarcie z flag± O_TRUNC (uciêcie do zerowej d³ugo¶ci je¶li istnieje)\n"
+" Bez argumentÃ³w uÅ¼ywa polecenia stat do pokazania bieÅ¼Ä…cego pliku.\n"
+" -F - plik na obcym systemie plikÃ³w, zabronienie uÅ¼ywania poleceÅ„ dla XFS-a\n"
+" -a - otwarcie z flagÄ… O_APPEND (w trybie tylko dopisywania)\n"
+" -d - otwarcie z flagÄ… O_DIRECT (niebuforowane we/wy, ograniczenia wyrÃ³wnania)\n"
+" -f - otwarcie z flagÄ… O_CREAT (utworzenie pliku jeÅ›li nie istnieje)\n"
+" -m - uprawnienia do uÅ¼ycia w przypadku tworzenia pliku (domyÅ›lnie 0600)\n"
+" -n - otwarcie z flagÄ… O_NONBLOCK\n"
+" -r - otwarcie z flagÄ… O_RDONLY (domyÅ›lne jest O_RDWR)\n"
+" -s - otwarcie z flagÄ… O_SYNC\n"
+" -t - otwarcie z flagÄ… O_TRUNC (uciÄ™cie do zerowej dÅ‚ugoÅ›ci jeÅ›li istnieje)\n"
 " -R - oznaczenie pliku jako realtime na XFS-ie zaraz po otwarciu\n"
-" Uwaga1: zwykle ¿±dania bezpo¶redniego we/wy musz± byæ wyrównane do rozmiaru\n"
-"         bloku; niektóre j±dra pozwalaj± na wyrównanie do rozmiaru sektora\n"
-" Uwaga2: bmap dla plików innych ni¿ zwyk³e mo¿na uzyskaæ pod warunkiem, ¿e\n"
-"         plik zostanie poprawnie otwarty (w szczególno¶ci tylko do odczytu).\n"
+" Uwaga1: zwykle Å¼Ä…dania bezpoÅ›redniego we/wy muszÄ… byÄ‡ wyrÃ³wnane do rozmiaru\n"
+"         bloku; niektÃ³re jÄ…dra pozwalajÄ… na wyrÃ³wnanie do rozmiaru sektora\n"
+" Uwaga2: bmap dla plikÃ³w innych niÅ¼ zwykÅ‚e moÅ¼na uzyskaÄ‡ pod warunkiem, Å¼e\n"
+"         plik zostanie poprawnie otwarty (w szczegÃ³lnoÅ›ci tylko do odczytu).\n"
 
 #: ../io/open.c:380
 #, c-format
@@ -2165,11 +2165,11 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" wy¶wietlenie identyfikatora projektu zwi±zanego z bie¿±c± ¶cie¿k±\n"
+" wyÅ›wietlenie identyfikatora projektu zwiÄ…zanego z bieÅ¼Ä…cÄ… Å›cieÅ¼kÄ…\n"
 "\n"
 " Opcje:\n"
-" -R - rekurencyjne zag³êbianie siê (przydatne kiedy bie¿±cy plik jest katalogiem)\n"
-" -D - rekurencyjne zag³êbianie siê, ale wypisywanie projektów tylko katalogów\n"
+" -R - rekurencyjne zagÅ‚Ä™bianie siÄ™ (przydatne kiedy bieÅ¼Ä…cy plik jest katalogiem)\n"
+" -D - rekurencyjne zagÅ‚Ä™bianie siÄ™, ale wypisywanie projektÃ³w tylko katalogÃ³w\n"
 "\n"
 
 #: ../io/open.c:446
@@ -2188,16 +2188,16 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" modyfikacja identyfikatora projektu zwi±zanego z bie¿±c± ¶cie¿k±\n"
+" modyfikacja identyfikatora projektu zwiÄ…zanego z bieÅ¼Ä…cÄ… Å›cieÅ¼kÄ…\n"
 "\n"
-" -R - rekurencyjne zag³êbianie siê (przydatne kiedy bie¿±cy plik jest katalogiem)\n"
-" -D - rekurencyjne zag³êbianie siê, ale zmiana projektów tylko katalogów\n"
+" -R - rekurencyjne zagÅ‚Ä™bianie siÄ™ (przydatne kiedy bieÅ¼Ä…cy plik jest katalogiem)\n"
+" -D - rekurencyjne zagÅ‚Ä™bianie siÄ™, ale zmiana projektÃ³w tylko katalogÃ³w\n"
 "\n"
 
 #: ../io/open.c:513
 #, c-format
 msgid "invalid project ID -- %s\n"
-msgstr "nieprawid³owy ID projektu - %s\n"
+msgstr "nieprawidÅ‚owy ID projektu - %s\n"
 
 #: ../io/open.c:529
 #, c-format
@@ -2210,17 +2210,17 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" odczyt lub zmiana preferowanego rozmiaru fragmentu (w bajtach) dla bie¿±cej\n"
-" ¶cie¿ki\n"
+" odczyt lub zmiana preferowanego rozmiaru fragmentu (w bajtach) dla bieÅ¼Ä…cej\n"
+" Å›cieÅ¼ki\n"
 "\n"
-" -R - rekurencyjne zag³êbianie siê (przydatne kiedy bie¿±cy plik jest katalogiem)\n"
-" -D - rekurencyjne zag³êbianie siê, ale zmiana extsize tylko katalogów\n"
+" -R - rekurencyjne zagÅ‚Ä™bianie siÄ™ (przydatne kiedy bieÅ¼Ä…cy plik jest katalogiem)\n"
+" -D - rekurencyjne zagÅ‚Ä™bianie siÄ™, ale zmiana extsize tylko katalogÃ³w\n"
 "\n"
 
 #: ../io/open.c:572
 #, c-format
 msgid "invalid target file type - file %s\n"
-msgstr "nieprawid³owy rodzaj bliku docelowego - plik %s\n"
+msgstr "nieprawidÅ‚owy rodzaj bliku docelowego - plik %s\n"
 
 #: ../io/open.c:658
 #, c-format
@@ -2230,7 +2230,7 @@ msgstr "nieliczbowy argument extsize - %s\n"
 #: ../io/open.c:705
 #, c-format
 msgid "invalid setfl argument -- '%c'\n"
-msgstr "nieprawid³owy argument setfl - '%c'\n"
+msgstr "nieprawidÅ‚owy argument setfl - '%c'\n"
 
 #: ../io/open.c:729
 #, c-format
@@ -2337,11 +2337,11 @@ msgstr "o"
 
 #: ../io/open.c:781
 msgid "[-acdrstx] [path]"
-msgstr "[-acdrstx] [¶cie¿ka]"
+msgstr "[-acdrstx] [Å›cieÅ¼ka]"
 
 #: ../io/open.c:782
 msgid "open the file specified by path"
-msgstr "otwarcie pliku okre¶lonego ¶cie¿k±"
+msgstr "otwarcie pliku okreÅ›lonego Å›cieÅ¼kÄ…"
 
 #: ../io/open.c:785
 msgid "stat"
@@ -2365,7 +2365,7 @@ msgstr "c"
 
 #: ../io/open.c:799
 msgid "close the current open file"
-msgstr "zamkniêcie bie¿±cego otwartego pliku"
+msgstr "zamkniÄ™cie bieÅ¼Ä…cego otwartego pliku"
 
 #: ../io/open.c:801
 msgid "setfl"
@@ -2377,7 +2377,7 @@ msgstr "[-adx]"
 
 #: ../io/open.c:806
 msgid "set/clear append/direct flags on the open file"
-msgstr "ustawienie/zdjêcie flag dopisywania/bezpo¶redniego we/wy dla otwartego pliku"
+msgstr "ustawienie/zdjÄ™cie flag dopisywania/bezpoÅ›redniego we/wy dla otwartego pliku"
 
 #: ../io/open.c:808
 msgid "statfs"
@@ -2385,7 +2385,7 @@ msgstr "statfs"
 
 #: ../io/open.c:812
 msgid "statistics on the filesystem of the currently open file"
-msgstr "statystyki dla systemu plików aktualnie otwartego pliku"
+msgstr "statystyki dla systemu plikÃ³w aktualnie otwartego pliku"
 
 #: ../io/open.c:814
 msgid "chproj"
@@ -2431,102 +2431,102 @@ msgstr "%s%s"
 #: ../io/parent.c:54
 #, c-format
 msgid "inode-path for inode: %llu is incorrect - path \"%s\" non-existent\n"
-msgstr "inode-path dla i-wêz³a: %llu jest niepoprawna - ¶cie¿ka \"%s\" nie istnieje\n"
+msgstr "inode-path dla i-wÄ™zÅ‚a: %llu jest niepoprawna - Å›cieÅ¼ka \"%s\" nie istnieje\n"
 
 #: ../io/parent.c:58
 #, c-format
 msgid "path \"%s\" does not stat for inode: %llu; err = %s\n"
-msgstr "¶cie¿ka \"%s\" nie pozwala na stat dla i-wêz³a: %llu; b³±d = %s\n"
+msgstr "Å›cieÅ¼ka \"%s\" nie pozwala na stat dla i-wÄ™zÅ‚a: %llu; bÅ‚Ä…d = %s\n"
 
 #: ../io/parent.c:67
 #, c-format
 msgid "path \"%s\" found\n"
-msgstr "¶cie¿ki \"%s\" nie znaleziono\n"
+msgstr "Å›cieÅ¼ki \"%s\" nie znaleziono\n"
 
 #: ../io/parent.c:73
 #, c-format
 msgid "inode-path for inode: %llu is incorrect - wrong inode#\n"
-msgstr "inode-path dla i-wêz³a: %llu jest niepoprawna - niew³a¶ciwy numer i-wêz³a\n"
+msgstr "inode-path dla i-wÄ™zÅ‚a: %llu jest niepoprawna - niewÅ‚aÅ›ciwy numer i-wÄ™zÅ‚a\n"
 
 #: ../io/parent.c:77 ../io/parent.c:107
 #, c-format
 msgid "ino mismatch for path \"%s\" %llu vs %llu\n"
-msgstr "niezgodno¶æ i-wêz³a dla ¶cie¿ki \"%s\" %llu vs %llu\n"
+msgstr "niezgodnoÅ›Ä‡ i-wÄ™zÅ‚a dla Å›cieÅ¼ki \"%s\" %llu vs %llu\n"
 
 #: ../io/parent.c:85
 #, c-format
 msgid "inode number match: %llu\n"
-msgstr "zgodno¶æ numeru i-wêz³a: %llu\n"
+msgstr "zgodnoÅ›Ä‡ numeru i-wÄ™zÅ‚a: %llu\n"
 
 #: ../io/parent.c:95
 #, c-format
 msgid "parent path \"%s\" does not stat: %s\n"
-msgstr "¶cie¿ka nadrzêdna \"%s\" nie pozwala na stat: %s\n"
+msgstr "Å›cieÅ¼ka nadrzÄ™dna \"%s\" nie pozwala na stat: %s\n"
 
 #: ../io/parent.c:103
 #, c-format
 msgid "inode-path for inode: %llu is incorrect - wrong parent inode#\n"
-msgstr "inode-path dla i-wêz³a: %llu jest niepoprawna - niew³a¶ciwy numer i-wêz³a nadrzêdnego\n"
+msgstr "inode-path dla i-wÄ™zÅ‚a: %llu jest niepoprawna - niewÅ‚aÅ›ciwy numer i-wÄ™zÅ‚a nadrzÄ™dnego\n"
 
 #: ../io/parent.c:116
 #, c-format
 msgid "parent ino match for %llu\n"
-msgstr "zgodno¶æ numeru i-wêz³a nadrzêdnego dla %llu\n"
+msgstr "zgodnoÅ›Ä‡ numeru i-wÄ™zÅ‚a nadrzÄ™dnego dla %llu\n"
 
 #: ../io/parent.c:137
 #, c-format
 msgid "parentpaths failed for ino %llu: %s\n"
-msgstr "parentpaths nie powiod³o siê dla i-wêz³a %llu: %s\n"
+msgstr "parentpaths nie powiodÅ‚o siÄ™ dla i-wÄ™zÅ‚a %llu: %s\n"
 
 #: ../io/parent.c:148
 #, c-format
 msgid "inode-path for inode: %llu is missing\n"
-msgstr "brak inode-path dla i-wêz³a: %llu\n"
+msgstr "brak inode-path dla i-wÄ™zÅ‚a: %llu\n"
 
 #: ../io/parent.c:171
 #, c-format
 msgid "can't stat mount point \"%s\": %s\n"
-msgstr "nie mo¿na wykonaæ stat na punkcie montowania \"%s\": %s\n"
+msgstr "nie moÅ¼na wykonaÄ‡ stat na punkcie montowania \"%s\": %s\n"
 
 #: ../io/parent.c:192
 #, c-format
 msgid "failed to get bulkstat information for inode %llu\n"
-msgstr "nie uda³o siê uzyskaæ informacji bulkstat dla i-wêz³a %llu\n"
+msgstr "nie udaÅ‚o siÄ™ uzyskaÄ‡ informacji bulkstat dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../io/parent.c:198
 #, c-format
 msgid "failed to get valid bulkstat information for inode %llu\n"
-msgstr "nie uda³o siê uzyskaæ prawid³owych informacji bulkstat dla i-wêz³a %llu\n"
+msgstr "nie udaÅ‚o siÄ™ uzyskaÄ‡ prawidÅ‚owych informacji bulkstat dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../io/parent.c:210
 #, c-format
 msgid "checking inode %llu\n"
-msgstr "sprawdzanie i-wêz³a %llu\n"
+msgstr "sprawdzanie i-wÄ™zÅ‚a %llu\n"
 
 #: ../io/parent.c:224
 #, c-format
 msgid "syssgi bulkstat failed: %s\n"
-msgstr "syssgi bulkstat nie powiod³o siê: %s\n"
+msgstr "syssgi bulkstat nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../io/parent.c:246
 #, c-format
 msgid "unable to open \"%s\" for jdm: %s\n"
-msgstr "nie uda³o siê otworzyæ \"%s\" dla jdm: %s\n"
+msgstr "nie udaÅ‚o siÄ™ otworzyÄ‡ \"%s\" dla jdm: %s\n"
 
 #: ../io/parent.c:256
 #, c-format
 msgid "unable to allocate buffers: %s\n"
-msgstr "nie uda³o siê przydzieliæ buforów: %s\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ buforÃ³w: %s\n"
 
 #: ../io/parent.c:265
 #, c-format
 msgid "num errors: %d\n"
-msgstr "liczba b³êdów: %d\n"
+msgstr "liczba bÅ‚Ä™dÃ³w: %d\n"
 
 #: ../io/parent.c:267
 #, c-format
 msgid "succeeded checking %llu inodes\n"
-msgstr "uda³o siê sprawdziæ %llu i-wêz³ów\n"
+msgstr "udaÅ‚o siÄ™ sprawdziÄ‡ %llu i-wÄ™zÅ‚Ã³w\n"
 
 #: ../io/parent.c:277
 #, c-format
@@ -2556,22 +2556,22 @@ msgstr "p_name   = \"%s\"\n"
 #: ../io/parent.c:305
 #, c-format
 msgid "%s: failed path_to_fshandle \"%s\": %s\n"
-msgstr "%s: path_to_fshandle nie powiod³o siê dla \"%s\": %s\n"
+msgstr "%s: path_to_fshandle nie powiodÅ‚o siÄ™ dla \"%s\": %s\n"
 
 #: ../io/parent.c:312
 #, c-format
 msgid "%s: path_to_handle failed for \"%s\"\n"
-msgstr "%s: path_to_handle nie powiod³o siê dla \"%s\"\n"
+msgstr "%s: path_to_handle nie powiodÅ‚o siÄ™ dla \"%s\"\n"
 
 #: ../io/parent.c:319
 #, c-format
 msgid "%s: unable to allocate parent buffer: %s\n"
-msgstr "%s: nie uda³o siê przydzieliæ bufora nadrzêdnego: %s\n"
+msgstr "%s: nie udaÅ‚o siÄ™ przydzieliÄ‡ bufora nadrzÄ™dnego: %s\n"
 
 #: ../io/parent.c:340
 #, c-format
 msgid "%s: %s call failed for \"%s\": %s\n"
-msgstr "%s: wywo³anie %s nie powiod³o siê dla \"%s\": %s\n"
+msgstr "%s: wywoÅ‚anie %s nie powiodÅ‚o siÄ™ dla \"%s\": %s\n"
 
 #: ../io/parent.c:349
 #, c-format
@@ -2581,7 +2581,7 @@ msgstr "%s: brak inode-path\n"
 #: ../io/parent.c:380
 #, c-format
 msgid "file argument, \"%s\", is not in a mounted XFS filesystem\n"
-msgstr "argument plikowy \"%s\" nie jest na podmontowanym systemie plików XFS\n"
+msgstr "argument plikowy \"%s\" nie jest na podmontowanym systemie plikÃ³w XFS\n"
 
 #: ../io/parent.c:420
 #, c-format
@@ -2595,11 +2595,11 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" wypisanie rodziców bie¿±cego pliku i ich nazw\n"
+" wypisanie rodzicÃ³w bieÅ¼Ä…cego pliku i ich nazw\n"
 "\n"
-" -c - sprawdzenie systemu plików pod k±tem spójno¶ci rodziców pliku\n"
-" -p - wypisanie rodziców bie¿±cego pliku i ich pe³nych ¶cie¿ek\n"
-" -v - tryb szczegó³owy\n"
+" -c - sprawdzenie systemu plikÃ³w pod kÄ…tem spÃ³jnoÅ›ci rodzicÃ³w pliku\n"
+" -p - wypisanie rodzicÃ³w bieÅ¼Ä…cego pliku i ich peÅ‚nych Å›cieÅ¼ek\n"
+" -v - tryb szczegÃ³Å‚owy\n"
 "\n"
 
 #: ../io/parent.c:432
@@ -2612,7 +2612,7 @@ msgstr "[-cpv]"
 
 #: ../io/parent.c:438
 msgid "print or check parent inodes"
-msgstr "wypisanie lub sprawdzenie i-wêz³ów nadrzêdnych"
+msgstr "wypisanie lub sprawdzenie i-wÄ™zÅ‚Ã³w nadrzÄ™dnych"
 
 #: ../io/pread.c:32
 #, c-format
@@ -2641,26 +2641,26 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" odczytanie przedzia³u bajtów w podanym rozmiarze bloku od podanego offsetu\n"
+" odczytanie przedziaÅ‚u bajtÃ³w w podanym rozmiarze bloku od podanego offsetu\n"
 "\n"
-" Przyk³ad:\n"
-" 'pread -v 512 20' - wyrzucenie 20 bajtów odczytanych od 512 bajtu w pliku\n"
+" PrzykÅ‚ad:\n"
+" 'pread -v 512 20' - wyrzucenie 20 bajtÃ³w odczytanych od 512 bajtu w pliku\n"
 "\n"
-" pread odczytuje segment aktualnie otwartego pliku, opcjonalnie wyrzucaj±c\n"
-" zawarto¶æ na strumieñ standardowego wyj¶cia (z opcj± -v) dla dalszych badañ.\n"
-" Odczyty s± wykonywane sekwencyjnie blokami pocz±wszy od offsetu z rozmiarem\n"
-" bloku ustawianym przy u¿yciu opcji -b (domy¶lny rozmiar bloku to 4096 bajtów),\n"
-" chyba ¿e za¿±dano innego schematu.\n"
-" -B   - odczyt przedzia³u od ty³u pocz±wszy od offsetu (N bajtów do ty³u)\n"
-" -F   - odczyt przedzia³u od przodu pocz±wszy od offsetu (domy¶lny)\n"
-" -v   - tryb szczegó³owy, wyrzucenie bufora (przy odczycie od przodu)\n"
-" -R   - odczyt losowych offsetów z przedzia³u bajtów\n"
+" pread odczytuje segment aktualnie otwartego pliku, opcjonalnie wyrzucajÄ…c\n"
+" zawartoÅ›Ä‡ na strumieÅ„ standardowego wyjÅ›cia (z opcjÄ… -v) dla dalszych badaÅ„.\n"
+" Odczyty sÄ… wykonywane sekwencyjnie blokami poczÄ…wszy od offsetu z rozmiarem\n"
+" bloku ustawianym przy uÅ¼yciu opcji -b (domyÅ›lny rozmiar bloku to 4096 bajtÃ³w),\n"
+" chyba Å¼e zaÅ¼Ä…dano innego schematu.\n"
+" -B   - odczyt przedziaÅ‚u od tyÅ‚u poczÄ…wszy od offsetu (N bajtÃ³w do tyÅ‚u)\n"
+" -F   - odczyt przedziaÅ‚u od przodu poczÄ…wszy od offsetu (domyÅ›lny)\n"
+" -v   - tryb szczegÃ³Å‚owy, wyrzucenie bufora (przy odczycie od przodu)\n"
+" -R   - odczyt losowych offsetÃ³w z przedziaÅ‚u bajtÃ³w\n"
 " -Z N - (\"zeed\") nakarmienie generatora liczb losowych (przy odczycie losowym)\n"
-"        (nieztety opcje -s/-S pasuj±ce do \"seed\" by³y ju¿ zajête w pwrite)\n"
-" W przypadku trybu losowego liczba operacji odczytu bêdzie równa liczbie\n"
-" potrzebnej do pe³nego przeskanowania od przodu lub od ty³u ca³ego przedzia³u.\n"
-" Nale¿y zauwa¿yæ, ¿e offset w przedziale jest wybierany za ka¿dym razem losowo\n"
-" (dowolny offset mo¿e byæ w tym trybie czytany wiêcej ni¿ raz).\n"
+"        (nieztety opcje -s/-S pasujÄ…ce do \"seed\" byÅ‚y juÅ¼ zajÄ™te w pwrite)\n"
+" W przypadku trybu losowego liczba operacji odczytu bÄ™dzie rÃ³wna liczbie\n"
+" potrzebnej do peÅ‚nego przeskanowania od przodu lub od tyÅ‚u caÅ‚ego przedziaÅ‚u.\n"
+" NaleÅ¼y zauwaÅ¼yÄ‡, Å¼e offset w przedziale jest wybierany za kaÅ¼dym razem losowo\n"
+" (dowolny offset moÅ¼e byÄ‡ w tym trybie czytany wiÄ™cej niÅ¼ raz).\n"
 "\n"
 
 #: ../io/pread.c:286 ../io/pwrite.c:215
@@ -2671,7 +2671,7 @@ msgstr "nieliczbowy rozmiar bloku - %s\n"
 #: ../io/pread.c:375
 #, c-format
 msgid "read %lld/%lld bytes at offset %lld\n"
-msgstr "odczytano %lld/%lld bajtów od offsetu %lld\n"
+msgstr "odczytano %lld/%lld bajtÃ³w od offsetu %lld\n"
 
 #: ../io/pread.c:377 ../io/pwrite.c:334 ../io/sendfile.c:163
 #, c-format
@@ -2688,11 +2688,11 @@ msgstr "r"
 
 #: ../io/pread.c:396
 msgid "[-b bs] [-v] off len"
-msgstr "[-b rozm_bloku] [-v] offset d³ugo¶æ"
+msgstr "[-b rozm_bloku] [-v] offset dÅ‚ugoÅ›Ä‡"
 
 #: ../io/pread.c:397
 msgid "reads a number of bytes at a specified offset"
-msgstr "odczyt podanej liczby bajtów od podanego offsetu"
+msgstr "odczyt podanej liczby bajtÃ³w od podanego offsetu"
 
 #: ../io/prealloc.c:125
 msgid "allocsp"
@@ -2701,11 +2701,11 @@ msgstr "allocsp"
 #: ../io/prealloc.c:130 ../io/prealloc.c:138 ../io/prealloc.c:146
 #: ../io/prealloc.c:154
 msgid "off len"
-msgstr "offset d³ugo¶æ"
+msgstr "offset dÅ‚ugoÅ›Ä‡"
 
 #: ../io/prealloc.c:131
 msgid "allocates zeroed space for part of a file"
-msgstr "przydzielenie wyzerowanej przestrzeni dla czê¶ci pliku"
+msgstr "przydzielenie wyzerowanej przestrzeni dla czÄ™Å›ci pliku"
 
 #: ../io/prealloc.c:133
 msgid "freesp"
@@ -2713,7 +2713,7 @@ msgstr "freesp"
 
 #: ../io/prealloc.c:139
 msgid "frees space associated with part of a file"
-msgstr "zwolnienie miejsca zwi±zanego z czê¶ci± pliku"
+msgstr "zwolnienie miejsca zwiÄ…zanego z czÄ™Å›ciÄ… pliku"
 
 #: ../io/prealloc.c:141
 msgid "resvsp"
@@ -2721,7 +2721,7 @@ msgstr "resvsp"
 
 #: ../io/prealloc.c:148
 msgid "reserves space associated with part of a file"
-msgstr "zarezerwowanie miejsca zwi±zanego z czê¶ci± pliku"
+msgstr "zarezerwowanie miejsca zwiÄ…zanego z czÄ™Å›ciÄ… pliku"
 
 #: ../io/prealloc.c:150
 msgid "unresvsp"
@@ -2729,7 +2729,7 @@ msgstr "unresvsp"
 
 #: ../io/prealloc.c:157
 msgid "frees reserved space associated with part of a file"
-msgstr "zwolnienie zarezerwowanego miejsca zwi±zanego z czê¶ci± pliku"
+msgstr "zwolnienie zarezerwowanego miejsca zwiÄ…zanego z czÄ™Å›ciÄ… pliku"
 
 #: ../io/pwrite.c:31
 #, c-format
@@ -2759,38 +2759,38 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" zapisanie przedzia³u bajtów w podanym rozmiarze bloku od podanego offsetu\n"
-"\n"
-" Przyk³ad:\n"
-" 'pwrite 512 20' - zapisanie 20 bajtów odczytanych od 512 bajtu w pliku\n"
-"\n"
-" pwrite zapisuje segment aktualnie otwartego pliku, u¿ywaj±c bufora wype³nionego\n"
-" ustawionym wzorcem (0xcdcdcdcd) lub danymi odczytanymi z pliku wej¶ciowego.\n"
-" Zapisy s± wykonywane sekwencyjnie blokami pocz±wszy od offsetu z rozmiarem\n"
-" bloku ustawianym przy u¿yciu opcji -b (domy¶lny rozmiar bloku to 4096 bajtów),\n"
-" chyba ¿e za¿±dano innego schematu.\n"
-" -S   - u¿ycie innej liczby do wype³nienia bufora zapisu\n"
-" -i   - plik wej¶ciowy, ¼ród³o danych do zapisania (przy pisaniu od przodu)\n"
-" -d   - otwarcie pliku wej¶ciowego dla bezpo¶redniego we/wy\n"
-" -s   - pominiêcie podanej liczby bajtów od pocz±tku pliku wej¶ciowego\n"
-" -w   - wywo³anie fdatasync(2) na koñcu (wliczane w wyniki czasowe)\n"
-" -W   - wywo³anie fsync(2) na koñcu (wliczane w wyniki czasowe)\n"
-" -B   - zapis przedzia³u od ty³u pocz±wszy od offsetu (N bajtów do ty³u)\n"
-" -F   - zapis przedzia³u od przodu pocz±wszy od offsetu (domy¶lny)\n"
-" -R   - zapis losowych offsetów z przedzia³u bajtów\n"
+" zapisanie przedziaÅ‚u bajtÃ³w w podanym rozmiarze bloku od podanego offsetu\n"
+"\n"
+" PrzykÅ‚ad:\n"
+" 'pwrite 512 20' - zapisanie 20 bajtÃ³w odczytanych od 512 bajtu w pliku\n"
+"\n"
+" pwrite zapisuje segment aktualnie otwartego pliku, uÅ¼ywajÄ…c bufora wypeÅ‚nionego\n"
+" ustawionym wzorcem (0xcdcdcdcd) lub danymi odczytanymi z pliku wejÅ›ciowego.\n"
+" Zapisy sÄ… wykonywane sekwencyjnie blokami poczÄ…wszy od offsetu z rozmiarem\n"
+" bloku ustawianym przy uÅ¼yciu opcji -b (domyÅ›lny rozmiar bloku to 4096 bajtÃ³w),\n"
+" chyba Å¼e zaÅ¼Ä…dano innego schematu.\n"
+" -S   - uÅ¼ycie innej liczby do wypeÅ‚nienia bufora zapisu\n"
+" -i   - plik wejÅ›ciowy, ÅºrÃ³dÅ‚o danych do zapisania (przy pisaniu od przodu)\n"
+" -d   - otwarcie pliku wejÅ›ciowego dla bezpoÅ›redniego we/wy\n"
+" -s   - pominiÄ™cie podanej liczby bajtÃ³w od poczÄ…tku pliku wejÅ›ciowego\n"
+" -w   - wywoÅ‚anie fdatasync(2) na koÅ„cu (wliczane w wyniki czasowe)\n"
+" -W   - wywoÅ‚anie fsync(2) na koÅ„cu (wliczane w wyniki czasowe)\n"
+" -B   - zapis przedziaÅ‚u od tyÅ‚u poczÄ…wszy od offsetu (N bajtÃ³w do tyÅ‚u)\n"
+" -F   - zapis przedziaÅ‚u od przodu poczÄ…wszy od offsetu (domyÅ›lny)\n"
+" -R   - zapis losowych offsetÃ³w z przedziaÅ‚u bajtÃ³w\n"
 " -Z N - (\"zeed\") nakarmienie generatora liczb losowych (przy zapisie losowym)\n"
-"        (nieztety opcje -s/-S pasuj±ce do \"seed\" by³y ju¿ zajête w pwrite)\n"
+"        (nieztety opcje -s/-S pasujÄ…ce do \"seed\" byÅ‚y juÅ¼ zajÄ™te w pwrite)\n"
 "\n"
 
 #: ../io/pwrite.c:242
 #, c-format
 msgid "non-numeric skip -- %s\n"
-msgstr "nieliczbowy liczba bajtów do pominiêcia - %s\n"
+msgstr "nieliczbowy liczba bajtÃ³w do pominiÄ™cia - %s\n"
 
 #: ../io/pwrite.c:332
 #, c-format
 msgid "wrote %lld/%lld bytes at offset %lld\n"
-msgstr "zapisano %lld/%lld bajtów od offsetu %lld\n"
+msgstr "zapisano %lld/%lld bajtÃ³w od offsetu %lld\n"
 
 #: ../io/pwrite.c:350
 msgid "pwrite"
@@ -2802,11 +2802,11 @@ msgstr "w"
 
 #: ../io/pwrite.c:357
 msgid "[-i infile [-d] [-s skip]] [-b bs] [-S seed] [-wW] off len"
-msgstr "[-i plik_wej [-d] [-s do_pominiêcia]] [-b rozm_bloku] [-S zarodek] [-wW] offset d³ugo¶æ"
+msgstr "[-i plik_wej [-d] [-s do_pominiÄ™cia]] [-b rozm_bloku] [-S zarodek] [-wW] offset dÅ‚ugoÅ›Ä‡"
 
 #: ../io/pwrite.c:359
 msgid "writes a number of bytes at a specified offset"
-msgstr "zapis podanej liczby bajtów od podanego offsetu"
+msgstr "zapis podanej liczby bajtÃ³w od podanego offsetu"
 
 #: ../io/resblks.c:39
 #, c-format
@@ -2821,7 +2821,7 @@ msgstr "zarezerwowane bloki = %llu\n"
 #: ../io/resblks.c:53
 #, c-format
 msgid "available reserved blocks = %llu\n"
-msgstr "dostêpne zarezerwowane bloki = %llu\n"
+msgstr "dostÄ™pne zarezerwowane bloki = %llu\n"
 
 #: ../io/resblks.c:61
 msgid "resblks"
@@ -2833,7 +2833,7 @@ msgstr "[bloki]"
 
 #: ../io/resblks.c:68
 msgid "get and/or set count of reserved filesystem blocks"
-msgstr "pobranie i/lub ustawienie liczby zarezerwowanych bloków w systemie plików"
+msgstr "pobranie i/lub ustawienie liczby zarezerwowanych blokÃ³w w systemie plikÃ³w"
 
 #: ../io/sendfile.c:32
 #, c-format
@@ -2853,23 +2853,23 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" przes³anie miêdzy plikami przedzia³u bajtów od podanego offsetu\n"
+" przesÅ‚anie miÄ™dzy plikami przedziaÅ‚u bajtÃ³w od podanego offsetu\n"
 "\n"
-" Przyk³ad:\n"
-" 'send -f 2 512 20' - zapisanie 20 bajtów od 512 bajtu do otwartego pliku\n"
+" PrzykÅ‚ad:\n"
+" 'send -f 2 512 20' - zapisanie 20 bajtÃ³w od 512 bajtu do otwartego pliku\n"
 "\n"
-" sendfile kopiuje dane miêdzy jednym deskryptorem pliku a innym. Poniewa¿ to\n"
-" kopiowanie jest wykonywane przez j±dro, sendfile nie potrzebuje przesy³aæ\n"
-" danych do i z przestrzeni u¿ytkownika.\n"
-" -f - podanie plików wej¶ciowego z którego dane maj± byæ czytane\n"
-" -i - podanie nazwy pliku wej¶ciowego z którego dane maj± byæ czytane\n"
-" Opcjonalnie mo¿na podaæ offset i d³ugo¶æ danych w pliku ¼ród³owym.\n"
+" sendfile kopiuje dane miÄ™dzy jednym deskryptorem pliku a innym. PoniewaÅ¼ to\n"
+" kopiowanie jest wykonywane przez jÄ…dro, sendfile nie potrzebuje przesyÅ‚aÄ‡\n"
+" danych do i z przestrzeni uÅ¼ytkownika.\n"
+" -f - podanie plikÃ³w wejÅ›ciowego z ktÃ³rego dane majÄ… byÄ‡ czytane\n"
+" -i - podanie nazwy pliku wejÅ›ciowego z ktÃ³rego dane majÄ… byÄ‡ czytane\n"
+" Opcjonalnie moÅ¼na podaÄ‡ offset i dÅ‚ugoÅ›Ä‡ danych w pliku ÅºrÃ³dÅ‚owym.\n"
 "\n"
 
 #: ../io/sendfile.c:161
 #, c-format
 msgid "sent %lld/%lld bytes from offset %lld\n"
-msgstr "przes³ano %lld/%lld bajtów od offsetu %lld\n"
+msgstr "przesÅ‚ano %lld/%lld bajtÃ³w od offsetu %lld\n"
 
 #: ../io/sendfile.c:179
 msgid "sendfile"
@@ -2881,11 +2881,11 @@ msgstr "send"
 
 #: ../io/sendfile.c:186
 msgid "-i infile | -f N [off len]"
-msgstr "-i plik_wej | -f N [offset d³ugo¶æ]"
+msgstr "-i plik_wej | -f N [offset dÅ‚ugoÅ›Ä‡]"
 
 #: ../io/sendfile.c:188
 msgid "Transfer data directly between file descriptors"
-msgstr "Przes³anie danych bezpo¶rednio miêdzy deskryptorami plików"
+msgstr "PrzesÅ‚anie danych bezpoÅ›rednio miÄ™dzy deskryptorami plikÃ³w"
 
 #: ../io/shutdown.c:54
 msgid "shutdown"
@@ -2897,7 +2897,7 @@ msgstr "[-f]"
 
 #: ../io/shutdown.c:61
 msgid "shuts down the filesystem where the current file resides"
-msgstr "wy³±czenie systemu plików na którym znajduje siê bie¿±cy plik"
+msgstr "wyÅ‚Ä…czenie systemu plikÃ³w na ktÃ³rym znajduje siÄ™ bieÅ¼Ä…cy plik"
 
 #: ../io/truncate.c:38
 #, c-format
@@ -2918,82 +2918,82 @@ msgstr "offset"
 
 #: ../io/truncate.c:60
 msgid "truncates the current file at the given offset"
-msgstr "uciêcie bie¿±cego pliku na podanym offsecie"
+msgstr "uciÄ™cie bieÅ¼Ä…cego pliku na podanym offsecie"
 
 #: ../libdisk/dm.c:56
 #, c-format
 msgid "Warning - device mapper device, but no dmsetup(8) found\n"
-msgstr "Uwaga - urz±dzenie device mappera, ale nie znaleziono dmsetup(8)\n"
+msgstr "Uwaga - urzÄ…dzenie device mappera, ale nie znaleziono dmsetup(8)\n"
 
 #: ../libdisk/dm.c:62
 #, c-format
 msgid "Warning - device mapper device, but cannot resolve path %s: %s\n"
-msgstr "Uwaga - urz±dzenie device mappera, ale nie mo¿na rozwi±zaæ ¶cie¿ki %s: %s\n"
+msgstr "Uwaga - urzÄ…dzenie device mappera, ale nie moÅ¼na rozwiÄ…zaÄ‡ Å›cieÅ¼ki %s: %s\n"
 
 #: ../libdisk/dm.c:73 ../libdisk/lvm.c:70
 #, c-format
 msgid "Could not open pipe\n"
-msgstr "Nie uda³o siê otworzyæ potoku\n"
+msgstr "Nie udaÅ‚o siÄ™ otworzyÄ‡ potoku\n"
 
 #: ../libdisk/dm.c:88 ../libdisk/lvm.c:85
 #, c-format
 msgid "Failed to execute %s\n"
-msgstr "Nie uda³o siê wywo³aæ %s\n"
+msgstr "Nie udaÅ‚o siÄ™ wywoÅ‚aÄ‡ %s\n"
 
 #: ../libdisk/dm.c:92
 #, c-format
 msgid "Failed forking dmsetup process\n"
-msgstr "Nie uda³o siê odga³êziæ procesu dmsetup\n"
+msgstr "Nie udaÅ‚o siÄ™ odgaÅ‚Ä™ziÄ‡ procesu dmsetup\n"
 
 #: ../libdisk/drivers.c:35
 #, c-format
 msgid "Cannot stat %s: %s\n"
-msgstr "Nie mo¿na wykonaæ stat na %s: %s\n"
+msgstr "Nie moÅ¼na wykonaÄ‡ stat na %s: %s\n"
 
 #: ../libdisk/lvm.c:60
 #, c-format
 msgid "Warning - LVM device, but no lvdisplay(8) found\n"
-msgstr "Uwaga - urz±dzenie LVM, ale nie znaleziono lvdisplay(8)\n"
+msgstr "Uwaga - urzÄ…dzenie LVM, ale nie znaleziono lvdisplay(8)\n"
 
 #: ../libdisk/lvm.c:89
 #, c-format
 msgid "Failed forking lvdisplay process\n"
-msgstr "Nie uda³o siê odga³êziæ procesu lvdisplay\n"
+msgstr "Nie udaÅ‚o siÄ™ odgaÅ‚Ä™ziÄ‡ procesu lvdisplay\n"
 
 #: ../libdisk/md.c:61
 #, c-format
 msgid "Error getting MD array device from %s\n"
-msgstr "B³±d podczas pobierania urz±dzenia macierzy MD z %s\n"
+msgstr "BÅ‚Ä…d podczas pobierania urzÄ…dzenia macierzy MD z %s\n"
 
 #: ../libdisk/md.c:68
 #, c-format
 msgid "Couldn't malloc device string\n"
-msgstr "Nie mo¿na przydzieliæ ³añcucha nazwy urz±dzenia\n"
+msgstr "Nie moÅ¼na przydzieliÄ‡ Å‚aÅ„cucha nazwy urzÄ…dzenia\n"
 
 #: ../libdisk/md.c:84
 #, c-format
 msgid "Error getting MD array info from %s\n"
-msgstr "B³±d podczas pobierania informacji o macierzy MD z %s\n"
+msgstr "BÅ‚Ä…d podczas pobierania informacji o macierzy MD z %s\n"
 
 #: ../libxcmd/command.c:85
 #, c-format
 msgid "bad argument count %d to %s, expected at least %d arguments\n"
-msgstr "b³êdna liczba argumentów %d dla %s, oczekiwano co najmniej %d argumentów\n"
+msgstr "bÅ‚Ä™dna liczba argumentÃ³w %d dla %s, oczekiwano co najmniej %d argumentÃ³w\n"
 
 #: ../libxcmd/command.c:89
 #, c-format
 msgid "bad argument count %d to %s, expected %d arguments\n"
-msgstr "b³êdna liczba argumentów %d dla %s, oczekiwano %d argumentów\n"
+msgstr "bÅ‚Ä™dna liczba argumentÃ³w %d dla %s, oczekiwano %d argumentÃ³w\n"
 
 #: ../libxcmd/command.c:93
 #, c-format
 msgid "bad argument count %d to %s, expected between %d and %d arguments\n"
-msgstr "b³êdna liczba argumentów %d dla %s, oczekiwano od %d do %d argumentów\n"
+msgstr "bÅ‚Ä™dna liczba argumentÃ³w %d dla %s, oczekiwano od %d do %d argumentÃ³w\n"
 
 #: ../libxcmd/command.c:155
 #, c-format
 msgid "cannot strdup command '%s': %s\n"
-msgstr "nie mo¿na wykonaæ strdup na poleceniu '%s': %s\n"
+msgstr "nie moÅ¼na wykonaÄ‡ strdup na poleceniu '%s': %s\n"
 
 #: ../libxcmd/command.c:171 ../libxcmd/command.c:189
 #, c-format
@@ -3007,7 +3007,7 @@ msgid ""
 "Use 'help commandname' for extended help.\n"
 msgstr ""
 "\n"
-"Rozszerzony opis mo¿na uzyskaæ przez 'help nazwa_polecenia'.\n"
+"Rozszerzony opis moÅ¼na uzyskaÄ‡ przez 'help nazwa_polecenia'.\n"
 
 #: ../libxcmd/help.c:49
 #, c-format
@@ -3028,37 +3028,37 @@ msgstr "[polecenie]"
 
 #: ../libxcmd/help.c:93
 msgid "help for one or all commands"
-msgstr "opis dla jednego lub wszystkich poleceñ"
+msgstr "opis dla jednego lub wszystkich poleceÅ„"
 
 #: ../libxcmd/paths.c:77
 #, c-format
 msgid "%s: warning - out of memory\n"
-msgstr "%s: uwaga - brak pamiêci\n"
+msgstr "%s: uwaga - brak pamiÄ™ci\n"
 
 #: ../libxcmd/paths.c:85
 #, c-format
 msgid "%s: warning - cannot find %s: %s\n"
-msgstr "%s: uwaga - nie mo¿na odnale¼æ %s: %s\n"
+msgstr "%s: uwaga - nie moÅ¼na odnaleÅºÄ‡ %s: %s\n"
 
 #: ../libxcmd/paths.c:364
 #, c-format
 msgid "%s: cannot initialise path table: %s\n"
-msgstr "%s: nie mo¿na zainicjowaæ tabeli ¶cie¿ek: %s\n"
+msgstr "%s: nie moÅ¼na zainicjowaÄ‡ tabeli Å›cieÅ¼ek: %s\n"
 
 #: ../libxcmd/paths.c:379
 #, c-format
 msgid "%s: cannot setup path for mount %s: %s\n"
-msgstr "%s: nie mo¿na ustawiæ ¶cie¿ki dla montowania %s: %s\n"
+msgstr "%s: nie moÅ¼na ustawiÄ‡ Å›cieÅ¼ki dla montowania %s: %s\n"
 
 #: ../libxcmd/paths.c:392
 #, c-format
 msgid "%s: no mount table yet, so no projects\n"
-msgstr "%s: nie ma jeszcze tabeli montowañ, wiêc nie ma projektów\n"
+msgstr "%s: nie ma jeszcze tabeli montowaÅ„, wiÄ™c nie ma projektÃ³w\n"
 
 #: ../libxcmd/paths.c:399
 #, c-format
 msgid "%s: cannot setup path for project %s: %s\n"
-msgstr "%s: nie mo¿na ustawiæ ¶cie¿ki dla projektu %s: %s\n"
+msgstr "%s: nie moÅ¼na ustawiÄ‡ Å›cieÅ¼ki dla projektu %s: %s\n"
 
 #: ../libxcmd/quit.c:36
 msgid "quit"
@@ -3070,130 +3070,130 @@ msgstr "q"
 
 #: ../libxcmd/quit.c:42
 msgid "exit the program"
-msgstr "wyj¶cie z programu"
+msgstr "wyjÅ›cie z programu"
 
 #: ../libxfs/darwin.c:41
 #, c-format
 msgid "%s: error opening the device special file \"%s\": %s\n"
-msgstr "%s: b³±d podczas otwierania pliku specjalnego urz±dzenia \"%s\": %s\n"
+msgstr "%s: bÅ‚Ä…d podczas otwierania pliku specjalnego urzÄ…dzenia \"%s\": %s\n"
 
 #: ../libxfs/darwin.c:48
 #, c-format
 msgid "%s: can't tell if \"%s\" is writable: %s\n"
-msgstr "%s: nie mo¿na stwierdziæ czy \"%s\" jest zapisywalny: %s\n"
+msgstr "%s: nie moÅ¼na stwierdziÄ‡ czy \"%s\" jest zapisywalny: %s\n"
 
 #: ../libxfs/darwin.c:76 ../libxfs/freebsd.c:116 ../libxfs/irix.c:58
 #: ../libxfs/linux.c:138
 #, c-format
 msgid "%s: cannot stat the device file \"%s\": %s\n"
-msgstr "%s: nie mo¿na wykonaæ stat na pliku urz±dzenia \"%s\": %s\n"
+msgstr "%s: nie moÅ¼na wykonaÄ‡ stat na pliku urzÄ…dzenia \"%s\": %s\n"
 
 #: ../libxfs/darwin.c:86
 #, c-format
 msgid "%s: can't determine device size: %s\n"
-msgstr "%s: nie mo¿na okre¶liæ rozmiaru urz±dzenia: %s\n"
+msgstr "%s: nie moÅ¼na okreÅ›liÄ‡ rozmiaru urzÄ…dzenia: %s\n"
 
 #: ../libxfs/darwin.c:139 ../libxfs/freebsd.c:198 ../libxfs/irix.c:106
 #: ../libxfs/linux.c:216
 #, c-format
 msgid "%s: can't determine memory size\n"
-msgstr "%s: nie mo¿na okre¶liæ rozmiaru pamiêci\n"
+msgstr "%s: nie moÅ¼na okreÅ›liÄ‡ rozmiaru pamiÄ™ci\n"
 
 #: ../libxfs/freebsd.c:49
 #, c-format
 msgid "%s: %s possibly contains a mounted filesystem\n"
-msgstr "%s: %s mo¿e zawieraæ podmontowany system plików\n"
+msgstr "%s: %s moÅ¼e zawieraÄ‡ podmontowany system plikÃ³w\n"
 
 #: ../libxfs/freebsd.c:60 ../libxfs/linux.c:67
 #, c-format
 msgid "%s: %s contains a mounted filesystem\n"
-msgstr "%s: %s zawiera podmontowany system plików\n"
+msgstr "%s: %s zawiera podmontowany system plikÃ³w\n"
 
 #: ../libxfs/freebsd.c:75 ../libxfs/linux.c:85
 #, c-format
 msgid "%s: %s contains a possibly writable, mounted filesystem\n"
-msgstr "%s: %s zawiera podmontowany, byæ mo¿e zapisywalny system plików\n"
+msgstr "%s: %s zawiera podmontowany, byÄ‡ moÅ¼e zapisywalny system plikÃ³w\n"
 
 #: ../libxfs/freebsd.c:89 ../libxfs/linux.c:99
 #, c-format
 msgid "%s: %s contains a mounted and writable filesystem\n"
-msgstr "%s: %s zawiera podmontowany, zapisywalny system plików\n"
+msgstr "%s: %s zawiera podmontowany, zapisywalny system plikÃ³w\n"
 
 # XXX: msgid bug
 #: ../libxfs/freebsd.c:129
 #, c-format
 msgid "%s: Not a device or file: \"%s\"n"
-msgstr "%s: Nie jest urz±dzeniem ani plikiem: \"%s\"n"
+msgstr "%s: Nie jest urzÄ…dzeniem ani plikiem: \"%s\"n"
 
 #: ../libxfs/freebsd.c:136
 #, c-format
 msgid "%s: DIOCGMEDIASIZE failed on \"%s\": %s\n"
-msgstr "%s: DIOCGMEDIASIE nie powiod³o siê dla \"%s\": %s\n"
+msgstr "%s: DIOCGMEDIASIE nie powiodÅ‚o siÄ™ dla \"%s\": %s\n"
 
 #: ../libxfs/freebsd.c:143
 #, c-format
 msgid "%s: DIOCGSECTORSIZE failed on \"%s\": %s\n"
-msgstr "%s: DIOCGSECTORSIZE nie powiod³o siê dla \"%s\": %s\n"
+msgstr "%s: DIOCGSECTORSIZE nie powiodÅ‚o siÄ™ dla \"%s\": %s\n"
 
 #: ../libxfs/init.c:80 ../libxfs/init.c:179
 #, c-format
 msgid "%s: %s: device %lld is not open\n"
-msgstr "%s: %s: urz±dzenie %lld nie jest otwarte\n"
+msgstr "%s: %s: urzÄ…dzenie %lld nie jest otwarte\n"
 
 #: ../libxfs/init.c:116
 #, c-format
 msgid "%s: cannot stat %s: %s\n"
-msgstr "%s: nie mo¿na wykonaæ stat na %s: %s\n"
+msgstr "%s: nie moÅ¼na wykonaÄ‡ stat na %s: %s\n"
 
 #: ../libxfs/init.c:141
 #, c-format
 msgid "%s: device %lld is already open\n"
-msgstr "%s: urz±dzenie %lld jest ju¿ otwarte\n"
+msgstr "%s: urzÄ…dzenie %lld jest juÅ¼ otwarte\n"
 
 #: ../libxfs/init.c:154
 #, c-format
 msgid "%s: %s: too many open devices\n"
-msgstr "%s: %s: zbyt du¿o otwartych urz±dzeñ\n"
+msgstr "%s: %s: zbyt duÅ¼o otwartych urzÄ…dzeÅ„\n"
 
 #: ../libxfs/init.c:197
 #, c-format
 msgid "%s: can't find a character device matching %s\n"
-msgstr "%s: nie mo¿na odnale¼æ urz±dzenia znakowego odpowiadaj±cego %s\n"
+msgstr "%s: nie moÅ¼na odnaleÅºÄ‡ urzÄ…dzenia znakowego odpowiadajÄ…cego %s\n"
 
 #: ../libxfs/init.c:203
 #, c-format
 msgid "%s: can't find a block device matching %s\n"
-msgstr "%s: nie mo¿na odnale¼æ urz±dzenia blokowego odpowiadaj±cego %s\n"
+msgstr "%s: nie moÅ¼na odnaleÅºÄ‡ urzÄ…dzenia blokowego odpowiadajÄ…cego %s\n"
 
 #: ../libxfs/init.c:318
 #, c-format
 msgid "%s: can't get size for data subvolume\n"
-msgstr "%s: nie mo¿na pobraæ rozmiaru podwolumenu danych\n"
+msgstr "%s: nie moÅ¼na pobraÄ‡ rozmiaru podwolumenu danych\n"
 
 #: ../libxfs/init.c:323
 #, c-format
 msgid "%s: can't get size for log subvolume\n"
-msgstr "%s: nie mo¿na pobraæ rozmiaru podwolumenu logu\n"
+msgstr "%s: nie moÅ¼na pobraÄ‡ rozmiaru podwolumenu logu\n"
 
 #: ../libxfs/init.c:328
 #, c-format
 msgid "%s: can't get size for realtime subvolume\n"
-msgstr "%s: nie mo¿na pobraæ rozmiaru podwolumenu realtime\n"
+msgstr "%s: nie moÅ¼na pobraÄ‡ rozmiaru podwolumenu realtime\n"
 
 #: ../libxfs/init.c:424
 #, c-format
 msgid "%s: cannot read realtime bitmap inode (%d)\n"
-msgstr "%s: nie mo¿na odczytaæ i-wêz³a bitmapy realtime (%d)\n"
+msgstr "%s: nie moÅ¼na odczytaÄ‡ i-wÄ™zÅ‚a bitmapy realtime (%d)\n"
 
 #: ../libxfs/init.c:434
 #, c-format
 msgid "%s: cannot read realtime summary inode (%d)\n"
-msgstr "%s: nie mo¿na odczytaæ i-wêz³a opisu realtime (%d)\n"
+msgstr "%s: nie moÅ¼na odczytaÄ‡ i-wÄ™zÅ‚a opisu realtime (%d)\n"
 
 #: ../libxfs/init.c:458
 #, c-format
 msgid "%s: filesystem has a realtime subvolume\n"
-msgstr "%s: system plików ma podwolumen realtime\n"
+msgstr "%s: system plikÃ³w ma podwolumen realtime\n"
 
 #: ../libxfs/init.c:480
 #, c-format
@@ -3203,117 +3203,117 @@ msgstr "%s: inicjalizacja realtime - %llu != %llu\n"
 #: ../libxfs/init.c:488
 #, c-format
 msgid "%s: realtime size check failed\n"
-msgstr "%s: sprawdzenie rozmiaru realtime nie powiod³o siê\n"
+msgstr "%s: sprawdzenie rozmiaru realtime nie powiodÅ‚o siÄ™\n"
 
 #: ../libxfs/init.c:590
 #, c-format
 msgid "%s: size check failed\n"
-msgstr "%s: sprawdzenie rozmiaru nie powiod³o siê\n"
+msgstr "%s: sprawdzenie rozmiaru nie powiodÅ‚o siÄ™\n"
 
 #: ../libxfs/init.c:599
 #, c-format
 msgid "%s: WARNING - filesystem uses v1 dirs,limited functionality provided.\n"
-msgstr "%s: UWAGA - system plików u¿ywa katalogów v1, funkcjonalno¶æ jest ograniczona.\n"
+msgstr "%s: UWAGA - system plikÃ³w uÅ¼ywa katalogÃ³w v1, funkcjonalnoÅ›Ä‡ jest ograniczona.\n"
 
 #: ../libxfs/init.c:619
 #, c-format
 msgid "%s: data size check failed\n"
-msgstr "%s: sprawdzenie rozmiaru danych nie powiod³o siê\n"
+msgstr "%s: sprawdzenie rozmiaru danych nie powiodÅ‚o siÄ™\n"
 
 #: ../libxfs/init.c:632
 #, c-format
 msgid "%s: log size checks failed\n"
-msgstr "%s: sprawdzenie rozmiaru logu nie powiod³o siê\n"
+msgstr "%s: sprawdzenie rozmiaru logu nie powiodÅ‚o siÄ™\n"
 
 #: ../libxfs/init.c:643
 #, c-format
 msgid "%s: realtime device init failed\n"
-msgstr "%s: inicjalizacja urz±dzenia realtime nie powiod³a siê\n"
+msgstr "%s: inicjalizacja urzÄ…dzenia realtime nie powiodÅ‚a siÄ™\n"
 
 #: ../libxfs/init.c:651
 #, c-format
 msgid "%s: failed to alloc %ld bytes: %s\n"
-msgstr "%s: nie uda³o siê przydzieliæ %ld bajtów: %s\n"
+msgstr "%s: nie udaÅ‚o siÄ™ przydzieliÄ‡ %ld bajtÃ³w: %s\n"
 
 #: ../libxfs/init.c:665
 #, c-format
 msgid "%s: cannot read root inode (%d)\n"
-msgstr "%s: nie mo¿na odczytaæ i-wêz³a g³ównego (%d)\n"
+msgstr "%s: nie moÅ¼na odczytaÄ‡ i-wÄ™zÅ‚a gÅ‚Ã³wnego (%d)\n"
 
 #: ../libxfs/init.c:685
 #, c-format
 msgid "%s: cannot init perag data (%d)\n"
-msgstr "%s: nie mo¿na zainicjowaæ tabeli perag (%d)\n"
+msgstr "%s: nie moÅ¼na zainicjowaÄ‡ tabeli perag (%d)\n"
 
 #: ../libxfs/linux.c:114
 #, c-format
 msgid "%s: %s - cannot set blocksize on block device %s: %s\n"
-msgstr "%s: %s - nie mo¿na ustawiæ rozmiaru bloku urz±dzenia blokowego %s: %s\n"
+msgstr "%s: %s - nie moÅ¼na ustawiÄ‡ rozmiaru bloku urzÄ…dzenia blokowego %s: %s\n"
 
 #: ../libxfs/linux.c:161
 #, c-format
 msgid "%s: can't determine device size\n"
-msgstr "%s: nie mo¿na okre¶liæ rozmiaru urz±dzenia\n"
+msgstr "%s: nie moÅ¼na okreÅ›liÄ‡ rozmiaru urzÄ…dzenia\n"
 
 #: ../libxfs/linux.c:169
 #, c-format
 msgid "%s: warning - cannot get sector size from block device %s: %s\n"
-msgstr "%s: uwaga - nie mo¿na pobraæ rozmiaru sektora urz±dzenia blokowego %s: %s\n"
+msgstr "%s: uwaga - nie moÅ¼na pobraÄ‡ rozmiaru sektora urzÄ…dzenia blokowego %s: %s\n"
 
 #: ../libxfs/rdwr.c:40
 #, c-format
 msgid "%s: %s can't memalign %d bytes: %s\n"
-msgstr "%s: %s nie mo¿na wykonaæ memalign dla %d bajtów: %s\n"
+msgstr "%s: %s nie moÅ¼na wykonaÄ‡ memalign dla %d bajtÃ³w: %s\n"
 
 #: ../libxfs/rdwr.c:50
 #, c-format
 msgid "%s: %s seek to offset %llu failed: %s\n"
-msgstr "%s: %s zmiana offsetu na %llu nie powiod³a siê: %s\n"
+msgstr "%s: %s zmiana offsetu na %llu nie powiodÅ‚a siÄ™: %s\n"
 
 #: ../libxfs/rdwr.c:60
 #, c-format
 msgid "%s: %s write failed: %s\n"
-msgstr "%s: %s zapis nie powiód³ siê: %s\n"
+msgstr "%s: %s zapis nie powiÃ³dÅ‚ siÄ™: %s\n"
 
 #: ../libxfs/rdwr.c:64
 #, c-format
 msgid "%s: %s not progressing?\n"
-msgstr "%s: %s nie postêpuje?\n"
+msgstr "%s: %s nie postÄ™puje?\n"
 
 #: ../libxfs/rdwr.c:319
 #, c-format
 msgid "%s: %s can't memalign %u bytes: %s\n"
-msgstr "%s: %s nie mo¿na wykonaæ memalign dla %u bajtów: %s\n"
+msgstr "%s: %s nie moÅ¼na wykonaÄ‡ memalign dla %u bajtÃ³w: %s\n"
 
 #: ../libxfs/rdwr.c:459
 #, c-format
 msgid "%s: read failed: %s\n"
-msgstr "%s: odczyt nie powiód³ siê: %s\n"
+msgstr "%s: odczyt nie powiÃ³dÅ‚ siÄ™: %s\n"
 
 #: ../libxfs/rdwr.c:502
 #, c-format
 msgid "%s: pwrite64 failed: %s\n"
-msgstr "%s: pwrite64 nie powiod³o siê: %s\n"
+msgstr "%s: pwrite64 nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../libxfs/rdwr.c:509
 #, c-format
 msgid "%s: error - wrote only %d of %d bytes\n"
-msgstr "%s: b³±d - zapisano tylko %d z %d bajtów\n"
+msgstr "%s: bÅ‚Ä…d - zapisano tylko %d z %d bajtÃ³w\n"
 
 #: ../libxfs/trans.c:33
 #, c-format
 msgid "%s: xact calloc failed (%d bytes): %s\n"
-msgstr "%s: xact calloc nie powiod³o siê (%d bajtów): %s\n"
+msgstr "%s: xact calloc nie powiodÅ‚o siÄ™ (%d bajtÃ³w): %s\n"
 
 #: ../libxfs/trans.c:597
 #, c-format
 msgid "%s: warning - itobp failed (%d)\n"
-msgstr "%s: uwaga - itobp nie powiod³o siê (%d)\n"
+msgstr "%s: uwaga - itobp nie powiodÅ‚o siÄ™ (%d)\n"
 
 #: ../libxfs/trans.c:605
 #, c-format
 msgid "%s: warning - iflush_int failed (%d)\n"
-msgstr "%s: uwaga - iflush_int nie powiod³o siê (%d)\n"
+msgstr "%s: uwaga - iflush_int nie powiodÅ‚o siÄ™ (%d)\n"
 
 #: ../libxfs/trans.c:684 ../libxfs/trans.c:790
 #, c-format
@@ -3323,7 +3323,7 @@ msgstr "%s: nierozpoznany typ elementu logu\n"
 #: ../libxfs/util.c:697
 #, c-format
 msgid "%s: cannot reserve space: %s\n"
-msgstr "%s: nie mo¿na zarezerwowaæ przestrzeni: %s\n"
+msgstr "%s: nie moÅ¼na zarezerwowaÄ‡ przestrzeni: %s\n"
 
 #: ../libxlog/util.c:37
 #, c-format
@@ -3332,7 +3332,7 @@ msgid ""
 "*            SB : %s\n"
 "*            log: %s\n"
 msgstr ""
-"* B£¡D: niepasuj±cy uuid w logu\n"
+"* BÅÄ„D: niepasujÄ…cy uuid w logu\n"
 "             SB : %s\n"
 "             log: %s\n"
 
@@ -3348,35 +3348,35 @@ msgstr ""
 #: ../libxlog/util.c:58
 #, c-format
 msgid "* ERROR: bad magic number in log header: 0x%x\n"
-msgstr "* B£¡D: b³êdna liczba magiczna w nag³ówku logu: 0x%x\n"
+msgstr "* BÅÄ„D: bÅ‚Ä™dna liczba magiczna w nagÅ‚Ã³wku logu: 0x%x\n"
 
 #: ../libxlog/util.c:67
 #, c-format
 msgid "* ERROR: log format incompatible (log=%d, ours=%d)\n"
-msgstr "* B£¡D: niekompatybilny format logu (log=%d, nasz=%d)\n"
+msgstr "* BÅÄ„D: niekompatybilny format logu (log=%d, nasz=%d)\n"
 
 #: ../libxlog/util.c:77 ../libxlog/util.c:89
 msgid "Bad log"
-msgstr "B³êdny log"
+msgstr "BÅ‚Ä™dny log"
 
 #: ../mkfs/proto.c:60
 #, c-format
 msgid "%s: failed to open %s: %s\n"
-msgstr "%s: nie uda³o siê otworzyæ %s: %s\n"
+msgstr "%s: nie udaÅ‚o siÄ™ otworzyÄ‡ %s: %s\n"
 
 #: ../mkfs/proto.c:66 ../mkfs/proto.c:291
 #, c-format
 msgid "%s: read failed on %s: %s\n"
-msgstr "%s: odczyt nie powiód³ siê dla %s: %s\n"
+msgstr "%s: odczyt nie powiÃ³dÅ‚ siÄ™ dla %s: %s\n"
 
 #: ../mkfs/proto.c:71
 #, c-format
 msgid "%s: proto file %s premature EOF\n"
-msgstr "%s: plik prototypu %s skoñczy³ siê przedwcze¶nie\n"
+msgstr "%s: plik prototypu %s skoÅ„czyÅ‚ siÄ™ przedwczeÅ›nie\n"
 
 #: ../mkfs/proto.c:108
 msgid "cannot reserve space"
-msgstr "nie mo¿na zarezerwowaæ miejsca"
+msgstr "nie moÅ¼na zarezerwowaÄ‡ miejsca"
 
 #: ../mkfs/proto.c:161
 #, c-format
@@ -3385,193 +3385,193 @@ msgstr "%s: przedwczesny EOF w pliku prototypu\n"
 
 #: ../mkfs/proto.c:180
 msgid "error reserving space for a file"
-msgstr "b³±d podczas rezerwowania miejsca na plik"
+msgstr "bÅ‚Ä…d podczas rezerwowania miejsca na plik"
 
 #: ../mkfs/proto.c:249
 msgid "error allocating space for a file"
-msgstr "b³±d podczas przydzielania miejsca na plik"
+msgstr "bÅ‚Ä…d podczas przydzielania miejsca na plik"
 
 #: ../mkfs/proto.c:253
 #, c-format
 msgid "%s: cannot allocate space for file\n"
-msgstr "%s: nie mo¿na przydzieliæ miejsca na plik\n"
+msgstr "%s: nie moÅ¼na przydzieliÄ‡ miejsca na plik\n"
 
 #: ../mkfs/proto.c:316
 msgid "directory createname error"
-msgstr "b³±d tworzenia nazwy katalogu"
+msgstr "bÅ‚Ä…d tworzenia nazwy katalogu"
 
 #: ../mkfs/proto.c:330
 msgid "directory create error"
-msgstr "b³±d tworzenia katalogu"
+msgstr "bÅ‚Ä…d tworzenia katalogu"
 
 #: ../mkfs/proto.c:396 ../mkfs/proto.c:408 ../mkfs/proto.c:419
 #: ../mkfs/proto.c:426
 #, c-format
 msgid "%s: bad format string %s\n"
-msgstr "%s: b³êdny ³añcuch formatuj±cy %s\n"
+msgstr "%s: bÅ‚Ä™dny Å‚aÅ„cuch formatujÄ…cy %s\n"
 
 #: ../mkfs/proto.c:447 ../mkfs/proto.c:486 ../mkfs/proto.c:501
 #: ../mkfs/proto.c:513 ../mkfs/proto.c:525 ../mkfs/proto.c:536
 msgid "Inode allocation failed"
-msgstr "Przydzielanie i-wêz³a nie powiod³o siê"
+msgstr "Przydzielanie i-wÄ™zÅ‚a nie powiodÅ‚o siÄ™"
 
 #: ../mkfs/proto.c:464
 msgid "Inode pre-allocation failed"
-msgstr "Wczesne przydzielanie i-wêz³a nie powiod³o siê"
+msgstr "Wczesne przydzielanie i-wÄ™zÅ‚a nie powiodÅ‚o siÄ™"
 
 #: ../mkfs/proto.c:474
 msgid "Pre-allocated file creation failed"
-msgstr "Tworzenie wcze¶nie przydzielonego pliku nie powiod³o siê"
+msgstr "Tworzenie wczeÅ›nie przydzielonego pliku nie powiodÅ‚o siÄ™"
 
 #: ../mkfs/proto.c:556
 msgid "Directory creation failed"
-msgstr "Tworzenie katalogu nie powiod³o siê"
+msgstr "Tworzenie katalogu nie powiodÅ‚o siÄ™"
 
 #: ../mkfs/proto.c:580
 msgid "Error encountered creating file from prototype file"
-msgstr "Wyst±pi³ b³±d podczas tworzenia pliku z pliku prototypu"
+msgstr "WystÄ…piÅ‚ bÅ‚Ä…d podczas tworzenia pliku z pliku prototypu"
 
 #: ../mkfs/proto.c:630
 msgid "Realtime bitmap inode allocation failed"
-msgstr "Przydzielanie i-wêz³a bitmapy realtime nie powiod³o siê"
+msgstr "Przydzielanie i-wÄ™zÅ‚a bitmapy realtime nie powiodÅ‚o siÄ™"
 
 #: ../mkfs/proto.c:648
 msgid "Realtime summary inode allocation failed"
-msgstr "Tworzenie i-wêz³a opisu realtime nie powiod³o siê"
+msgstr "Tworzenie i-wÄ™zÅ‚a opisu realtime nie powiodÅ‚o siÄ™"
 
 #: ../mkfs/proto.c:675
 msgid "Allocation of the realtime bitmap failed"
-msgstr "Przydzielenie bitmapy realtime nie powiod³o siê"
+msgstr "Przydzielenie bitmapy realtime nie powiodÅ‚o siÄ™"
 
 #: ../mkfs/proto.c:688
 msgid "Completion of the realtime bitmap failed"
-msgstr "Uzupe³nienie bitmapy realtime nie powiod³o siê"
+msgstr "UzupeÅ‚nienie bitmapy realtime nie powiodÅ‚o siÄ™"
 
 #: ../mkfs/proto.c:712
 msgid "Allocation of the realtime summary failed"
-msgstr "Przydzielenie opisu realtime nie powiod³o siê"
+msgstr "Przydzielenie opisu realtime nie powiodÅ‚o siÄ™"
 
 #: ../mkfs/proto.c:724
 msgid "Completion of the realtime summary failed"
-msgstr "Uzupe³nienie opisu realtime nie powiod³o siê"
+msgstr "UzupeÅ‚nienie opisu realtime nie powiodÅ‚o siÄ™"
 
 #: ../mkfs/proto.c:741
 msgid "Error initializing the realtime space"
-msgstr "B³±d podczas inicjalizacji przestrzeni realtime"
+msgstr "BÅ‚Ä…d podczas inicjalizacji przestrzeni realtime"
 
 #: ../mkfs/proto.c:746
 msgid "Error completing the realtime space"
-msgstr "B³±d podczas uzupe³niania przestrzeni realtime"
+msgstr "BÅ‚Ä…d podczas uzupeÅ‚niania przestrzeni realtime"
 
 #: ../mkfs/xfs_mkfs.c:201
 #, c-format
 msgid "data su/sw must not be used in conjunction with data sunit/swidth\n"
-msgstr "su/sw danych nie mo¿na u¿yæ w po³±czeniu z sunit/swidth danych\n"
+msgstr "su/sw danych nie moÅ¼na uÅ¼yÄ‡ w poÅ‚Ä…czeniu z sunit/swidth danych\n"
 
 #: ../mkfs/xfs_mkfs.c:208
 #, c-format
 msgid "both data sunit and data swidth options must be specified\n"
-msgstr "trzeba podaæ obie opcje sunit i swidth dla danych\n"
+msgstr "trzeba podaÄ‡ obie opcje sunit i swidth dla danych\n"
 
 #: ../mkfs/xfs_mkfs.c:217
 #, c-format
 msgid "data sunit/swidth must not be used in conjunction with data su/sw\n"
-msgstr "sunit/swidth danych nie mo¿na u¿yæ w po³±czeniu z su/sw danych\n"
+msgstr "sunit/swidth danych nie moÅ¼na uÅ¼yÄ‡ w poÅ‚Ä…czeniu z su/sw danych\n"
 
 #: ../mkfs/xfs_mkfs.c:224
 #, c-format
 msgid "both data su and data sw options must be specified\n"
-msgstr "trzeba podaæ obie opcje su i sw dla danych\n"
+msgstr "trzeba podaÄ‡ obie opcje su i sw dla danych\n"
 
 #: ../mkfs/xfs_mkfs.c:231
 #, c-format
 msgid "data su must be a multiple of the sector size (%d)\n"
-msgstr "su danych musi byæ wielokrotno¶ci± rozmiaru sektora (%d)\n"
+msgstr "su danych musi byÄ‡ wielokrotnoÅ›ciÄ… rozmiaru sektora (%d)\n"
 
 #: ../mkfs/xfs_mkfs.c:242
 #, c-format
 msgid "data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"
-msgstr "szeroko¶æ pasa danych (%d) musi byæ wielokrotno¶ci± jednostki pasa danych (%d)\n"
+msgstr "szerokoÅ›Ä‡ pasa danych (%d) musi byÄ‡ wielokrotnoÅ›ciÄ… jednostki pasa danych (%d)\n"
 
 #: ../mkfs/xfs_mkfs.c:252
 #, c-format
 msgid "log su should not be used in conjunction with log sunit\n"
-msgstr "su logu nie powinno byæ u¿ywane w po³±czeniu z sunit logu\n"
+msgstr "su logu nie powinno byÄ‡ uÅ¼ywane w poÅ‚Ä…czeniu z sunit logu\n"
 
 #: ../mkfs/xfs_mkfs.c:261
 #, c-format
 msgid "log sunit should not be used in conjunction with log su\n"
-msgstr "sunit logu nie powinno byæ u¿ywane w po³±czeniu z su logu\n"
+msgstr "sunit logu nie powinno byÄ‡ uÅ¼ywane w poÅ‚Ä…czeniu z su logu\n"
 
 #: ../mkfs/xfs_mkfs.c:278
 #, c-format
 msgid "%s: %s appears to contain an existing filesystem (%s).\n"
-msgstr "%s: %s zdaje siê zawieraæ istniej±cy system plików (%s).\n"
+msgstr "%s: %s zdaje siÄ™ zawieraÄ‡ istniejÄ…cy system plikÃ³w (%s).\n"
 
 #: ../mkfs/xfs_mkfs.c:284
 #, c-format
 msgid "%s: %s appears to contain a partition table (%s).\n"
-msgstr "%s: %s zdaje siê zawieraæ tablicê partycji (%s).\n"
+msgstr "%s: %s zdaje siÄ™ zawieraÄ‡ tablicÄ™ partycji (%s).\n"
 
 #: ../mkfs/xfs_mkfs.c:318
 #, c-format
 msgid "log size %lld is not a multiple of the log stripe unit %d\n"
-msgstr "rozmiar logu %lld nie jest wielokrotno¶ci± jednostki pasa logu %d\n"
+msgstr "rozmiar logu %lld nie jest wielokrotnoÅ›ciÄ… jednostki pasa logu %d\n"
 
 #: ../mkfs/xfs_mkfs.c:346
 #, c-format
 msgid "Due to stripe alignment, the internal log size (%lld) is too large.\n"
-msgstr "Ze wzglêdu na wyrównanie do rozmiaru pasa rozmiar wewnêtrznego logu (%lld) jest zbyt du¿y.\n"
+msgstr "Ze wzglÄ™du na wyrÃ³wnanie do rozmiaru pasa rozmiar wewnÄ™trznego logu (%lld) jest zbyt duÅ¼y.\n"
 
 #: ../mkfs/xfs_mkfs.c:348
 #, c-format
 msgid "Must fit within an allocation group.\n"
-msgstr "Musi zmie¶ciæ siê wewn±trz grupy alokacji.\n"
+msgstr "Musi zmieÅ›ciÄ‡ siÄ™ wewnÄ…trz grupy alokacji.\n"
 
 #: ../mkfs/xfs_mkfs.c:359
 #, c-format
 msgid "log size %lld blocks too small, minimum size is %d blocks\n"
-msgstr "rozmiar logu %lld bloków jest zbyt ma³y, minimalny rozmiar to %d bloków\n"
+msgstr "rozmiar logu %lld blokÃ³w jest zbyt maÅ‚y, minimalny rozmiar to %d blokÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:365
 #, c-format
 msgid "log size %lld blocks too large, maximum size is %d blocks\n"
-msgstr "rozmiar logu %lld bloków jest zbyt du¿y, maksymalny rozmiar to %d bloków\n"
+msgstr "rozmiar logu %lld blokÃ³w jest zbyt duÅ¼y, maksymalny rozmiar to %d blokÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:371
 #, c-format
 msgid "log size %lld bytes too large, maximum size is %d bytes\n"
-msgstr "rozmiar logu %lld bajtów jest zbyt du¿y, maksymalny rozmiar to %d bajtów\n"
+msgstr "rozmiar logu %lld bajtÃ³w jest zbyt duÅ¼y, maksymalny rozmiar to %d bajtÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:476
 #, c-format
 msgid "agsize (%lldb) too small, need at least %lld blocks\n"
-msgstr "agsize (%lldb) zbyt ma³e, potrzeba co najmniej %lld bloków\n"
+msgstr "agsize (%lldb) zbyt maÅ‚e, potrzeba co najmniej %lld blokÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:484
 #, c-format
 msgid "agsize (%lldb) too big, maximum is %lld blocks\n"
-msgstr "agsize (%lldb) zbyt du¿e, maksimum to %lld bloków\n"
+msgstr "agsize (%lldb) zbyt duÅ¼e, maksimum to %lld blokÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:492
 #, c-format
 msgid "agsize (%lldb) too big, data area is %lld blocks\n"
-msgstr "agsize (%lldb) zbyt du¿e, obszar danych to %lld bloków\n"
+msgstr "agsize (%lldb) zbyt duÅ¼e, obszar danych to %lld blokÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:499
 #, c-format
 msgid "too many allocation groups for size = %lld\n"
-msgstr "zbyt du¿o grup alokacji dla rozmiaru = %lld\n"
+msgstr "zbyt duÅ¼o grup alokacji dla rozmiaru = %lld\n"
 
 #: ../mkfs/xfs_mkfs.c:501
 #, c-format
 msgid "need at most %lld allocation groups\n"
-msgstr "potrzeba najwy¿ej %lld grup alokacji\n"
+msgstr "potrzeba najwyÅ¼ej %lld grup alokacji\n"
 
 #: ../mkfs/xfs_mkfs.c:509
 #, c-format
 msgid "too few allocation groups for size = %lld\n"
-msgstr "zbyt ma³o grup alokacji dla rozmiaru = %lld\n"
+msgstr "zbyt maÅ‚o grup alokacji dla rozmiaru = %lld\n"
 
 #: ../mkfs/xfs_mkfs.c:511
 #, c-format
@@ -3581,42 +3581,42 @@ msgstr "potrzeba co najmniej %lld grup alokacji\n"
 #: ../mkfs/xfs_mkfs.c:524
 #, c-format
 msgid "last AG size %lld blocks too small, minimum size is %lld blocks\n"
-msgstr "rozmiar ostatniej AG %lld bloków zbyt ma³y, minimalny rozmiar to %lld bloków\n"
+msgstr "rozmiar ostatniej AG %lld blokÃ³w zbyt maÅ‚y, minimalny rozmiar to %lld blokÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:535
 #, c-format
 msgid "%lld allocation groups is too many, maximum is %lld\n"
-msgstr "%lld grup alokacji to zbyt du¿o, maksimum to %lld\n"
+msgstr "%lld grup alokacji to zbyt duÅ¼o, maksimum to %lld\n"
 
 #: ../mkfs/xfs_mkfs.c:559
 #, c-format
 msgid "error reading existing superblock -- failed to memalign buffer\n"
-msgstr "b³±d podczas odczytu istniej±cego superbloku - nie uda³o siê wykonaæ memalign dla bufora\n"
+msgstr "bÅ‚Ä…d podczas odczytu istniejÄ…cego superbloku - nie udaÅ‚o siÄ™ wykonaÄ‡ memalign dla bufora\n"
 
 #: ../mkfs/xfs_mkfs.c:565
 #, c-format
 msgid "existing superblock read failed: %s\n"
-msgstr "odczyt istniej±cego superbloku nie powiód³ siê: %s\n"
+msgstr "odczyt istniejÄ…cego superbloku nie powiÃ³dÅ‚ siÄ™: %s\n"
 
 #: ../mkfs/xfs_mkfs.c:849
 #, c-format
 msgid "%s: Specify data sunit in 512-byte blocks, no unit suffix\n"
-msgstr "%s: sunit danych nale¿y podaæ w 512-bajtowych blokach, bez jednostki\n"
+msgstr "%s: sunit danych naleÅ¼y podaÄ‡ w 512-bajtowych blokach, bez jednostki\n"
 
 #: ../mkfs/xfs_mkfs.c:865
 #, c-format
 msgid "%s: Specify data swidth in 512-byte blocks, no unit suffix\n"
-msgstr "%s: swidth danych nale¿y podaæ w 512-bajtowych blokach, bez jednostki\n"
+msgstr "%s: swidth danych naleÅ¼y podaÄ‡ w 512-bajtowych blokach, bez jednostki\n"
 
 #: ../mkfs/xfs_mkfs.c:892
 #, c-format
 msgid "%s: Specify data sw as multiple of su, no unit suffix\n"
-msgstr "%s: sw danych nale¿y podaæ jako wielokrotno¶æ su, bez jednostki\n"
+msgstr "%s: sw danych naleÅ¼y podaÄ‡ jako wielokrotnoÅ›Ä‡ su, bez jednostki\n"
 
 #: ../mkfs/xfs_mkfs.c:1111
 #, c-format
 msgid "Specify log sunit in 512-byte blocks, no size suffix\n"
-msgstr "sunit nale¿y podaæ w 512-bajtowych blokach, bez jednostki\n"
+msgstr "sunit naleÅ¼y podaÄ‡ w 512-bajtowych blokach, bez jednostki\n"
 
 #: ../mkfs/xfs_mkfs.c:1368
 #, c-format
@@ -3626,7 +3626,7 @@ msgstr "nadmiarowe argumenty\n"
 #: ../mkfs/xfs_mkfs.c:1374
 #, c-format
 msgid "cannot specify both %s and -d name=%s\n"
-msgstr "nie mo¿na podaæ jednocze¶nie %s i -d name=%s\n"
+msgstr "nie moÅ¼na podaÄ‡ jednoczeÅ›nie %s i -d name=%s\n"
 
 #: ../mkfs/xfs_mkfs.c:1391
 #, c-format
@@ -3651,101 +3651,101 @@ msgstr "niedozwolony rozmiar bloku katalogu %d\n"
 #: ../mkfs/xfs_mkfs.c:1439
 #, c-format
 msgid "both -d agcount= and agsize= specified, use one or the other\n"
-msgstr "podano jednocze¶nie -d agcount= i agsize=, mo¿na u¿yæ tylko jednej z tych opcji\n"
+msgstr "podano jednoczeÅ›nie -d agcount= i agsize=, moÅ¼na uÅ¼yÄ‡ tylko jednej z tych opcji\n"
 
 #: ../mkfs/xfs_mkfs.c:1445
 #, c-format
 msgid "if -d file then -d name and -d size are required\n"
-msgstr "je¶li podano -d file, to -d name i -d size s± wymagane\n"
+msgstr "jeÅ›li podano -d file, to -d name i -d size sÄ… wymagane\n"
 
 #: ../mkfs/xfs_mkfs.c:1454
 #, c-format
 msgid "illegal data length %lld, not a multiple of %d\n"
-msgstr "niedozwolona d³ugo¶æ danych %lld, nie jest wielokrotno¶ci± %d\n"
+msgstr "niedozwolona dÅ‚ugoÅ›Ä‡ danych %lld, nie jest wielokrotnoÅ›ciÄ… %d\n"
 
 #: ../mkfs/xfs_mkfs.c:1460
 #, c-format
 msgid "warning: data length %lld not a multiple of %d, truncated to %lld\n"
-msgstr "uwaga: d³ugo¶æ danych %lld nie jest wielokrotno¶ci± %d, uciêto do %lld\n"
+msgstr "uwaga: dÅ‚ugoÅ›Ä‡ danych %lld nie jest wielokrotnoÅ›ciÄ… %d, uciÄ™to do %lld\n"
 
 #: ../mkfs/xfs_mkfs.c:1474
 #, c-format
 msgid "if -l file then -l name and -l size are required\n"
-msgstr "je¶li podano -l file to -l name i -l size s± wymagane\n"
+msgstr "jeÅ›li podano -l file to -l name i -l size sÄ… wymagane\n"
 
 #: ../mkfs/xfs_mkfs.c:1483
 #, c-format
 msgid "illegal log length %lld, not a multiple of %d\n"
-msgstr "niedozwolona d³ugo¶æ logu %lld, nie jest wielokrotno¶ci± %d\n"
+msgstr "niedozwolona dÅ‚ugoÅ›Ä‡ logu %lld, nie jest wielokrotnoÅ›ciÄ… %d\n"
 
 #: ../mkfs/xfs_mkfs.c:1490
 #, c-format
 msgid "warning: log length %lld not a multiple of %d, truncated to %lld\n"
-msgstr "uwaga: d³ugo¶æ logu %lld nie jest wielokrotno¶ci± %d, uciêto do %lld\n"
+msgstr "uwaga: dÅ‚ugoÅ›Ä‡ logu %lld nie jest wielokrotnoÅ›ciÄ… %d, uciÄ™to do %lld\n"
 
 #: ../mkfs/xfs_mkfs.c:1496
 #, c-format
 msgid "if -r file then -r name and -r size are required\n"
-msgstr "je¶li podano -r file, to -r name i -r size s± wymagane\n"
+msgstr "jeÅ›li podano -r file, to -r name i -r size sÄ… wymagane\n"
 
 #: ../mkfs/xfs_mkfs.c:1505
 #, c-format
 msgid "illegal rt length %lld, not a multiple of %d\n"
-msgstr "niedozwolona d³ugo¶æ rt %lld, nie jest wielokrotno¶ci± %d\n"
+msgstr "niedozwolona dÅ‚ugoÅ›Ä‡ rt %lld, nie jest wielokrotnoÅ›ciÄ… %d\n"
 
 #: ../mkfs/xfs_mkfs.c:1512
 #, c-format
 msgid "warning: rt length %lld not a multiple of %d, truncated to %lld\n"
-msgstr "uwaga: d³ugo¶æ rt %lld nie jest wielokrotno¶ci± %d, uciêto do %lld\n"
+msgstr "uwaga: dÅ‚ugoÅ›Ä‡ rt %lld nie jest wielokrotnoÅ›ciÄ… %d, uciÄ™to do %lld\n"
 
 #: ../mkfs/xfs_mkfs.c:1525
 #, c-format
 msgid "illegal rt extent size %lld, not a multiple of %d\n"
-msgstr "niedozwolony rozmiar fragmentu rt %lld, nie jest wielokrotno¶ci± %d\n"
+msgstr "niedozwolony rozmiar fragmentu rt %lld, nie jest wielokrotnoÅ›ciÄ… %d\n"
 
 #: ../mkfs/xfs_mkfs.c:1531
 #, c-format
 msgid "rt extent size %s too large, maximum %d\n"
-msgstr "rozmiar fragmentu rt %s zbyt du¿y, maksimum to %d\n"
+msgstr "rozmiar fragmentu rt %s zbyt duÅ¼y, maksimum to %d\n"
 
 #: ../mkfs/xfs_mkfs.c:1537
 #, c-format
 msgid "rt extent size %s too small, minimum %d\n"
-msgstr "rozmiar fragmentu rt %s zbyt ma³y, minimum to %d\n"
+msgstr "rozmiar fragmentu rt %s zbyt maÅ‚y, minimum to %d\n"
 
 #: ../mkfs/xfs_mkfs.c:1581
 #, c-format
 msgid "illegal inode size %d\n"
-msgstr "niedozwolony rozmiar i-wêz³a %d\n"
+msgstr "niedozwolony rozmiar i-wÄ™zÅ‚a %d\n"
 
 #: ../mkfs/xfs_mkfs.c:1586
 #, c-format
 msgid "allowable inode size with %d byte blocks is %d\n"
-msgstr "dozwolony rozmiar i-wêz³a przy blokach %d-bajtowych to %d\n"
+msgstr "dozwolony rozmiar i-wÄ™zÅ‚a przy blokach %d-bajtowych to %d\n"
 
 #: ../mkfs/xfs_mkfs.c:1590
 #, c-format
 msgid "allowable inode size with %d byte blocks is between %d and %d\n"
-msgstr "dozwolone rozmiary i-wêz³a przy blokach %d-bajtowych s± od %d do %d\n"
+msgstr "dozwolone rozmiary i-wÄ™zÅ‚a przy blokach %d-bajtowych sÄ… od %d do %d\n"
 
 #: ../mkfs/xfs_mkfs.c:1598
 #, c-format
 msgid "log stripe unit specified, using v2 logs\n"
-msgstr "podano jednostkê pasa logu, u¿yto logów v2\n"
+msgstr "podano jednostkÄ™ pasa logu, uÅ¼yto logÃ³w v2\n"
 
 #: ../mkfs/xfs_mkfs.c:1616
 #, c-format
 msgid "no device name given in argument list\n"
-msgstr "nie podano nazwy urz±dzenia w li¶cie argumentów\n"
+msgstr "nie podano nazwy urzÄ…dzenia w liÅ›cie argumentÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:1641
 #, c-format
 msgid "%s: Use the -f option to force overwrite.\n"
-msgstr "%s: Mo¿na u¿yæ opcji -f do wymuszenia nadpisania.\n"
+msgstr "%s: MoÅ¼na uÅ¼yÄ‡ opcji -f do wymuszenia nadpisania.\n"
 
 #: ../mkfs/xfs_mkfs.c:1652
 msgid "internal log"
-msgstr "log wewnêtrzny"
+msgstr "log wewnÄ™trzny"
 
 #: ../mkfs/xfs_mkfs.c:1654
 msgid "volume log"
@@ -3754,7 +3754,7 @@ msgstr "log na wolumenie"
 #: ../mkfs/xfs_mkfs.c:1656
 #, c-format
 msgid "no log subvolume or internal log\n"
-msgstr "brak podwolumenu logu ani logu wewnêtrznego\n"
+msgstr "brak podwolumenu logu ani logu wewnÄ™trznego\n"
 
 #: ../mkfs/xfs_mkfs.c:1663
 msgid "volume rt"
@@ -3763,27 +3763,27 @@ msgstr "wolumen rt"
 #: ../mkfs/xfs_mkfs.c:1668
 #, c-format
 msgid "size %s specified for data subvolume is too large, maximum is %lld blocks\n"
-msgstr "rozmiar %s podany dla podwolumenu danych jest zbyt du¿y, maksimum to %lld bloków\n"
+msgstr "rozmiar %s podany dla podwolumenu danych jest zbyt duÅ¼y, maksimum to %lld blokÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:1675
 #, c-format
 msgid "can't get size of data subvolume\n"
-msgstr "nie mo¿na pobraæ rozmiaru podwolumenu danych\n"
+msgstr "nie moÅ¼na pobraÄ‡ rozmiaru podwolumenu danych\n"
 
 #: ../mkfs/xfs_mkfs.c:1680
 #, c-format
 msgid "size %lld of data subvolume is too small, minimum %d blocks\n"
-msgstr "rozmiar %lld dla podwolumenu danych jest zbyt ma³y, minimum to %d bloków\n"
+msgstr "rozmiar %lld dla podwolumenu danych jest zbyt maÅ‚y, minimum to %d blokÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:1687
 #, c-format
 msgid "can't have both external and internal logs\n"
-msgstr "nie mo¿na mieæ jednocze¶nie zewnêtrznego i wewnêtrznego logu\n"
+msgstr "nie moÅ¼na mieÄ‡ jednoczeÅ›nie zewnÄ™trznego i wewnÄ™trznego logu\n"
 
 #: ../mkfs/xfs_mkfs.c:1691
 #, c-format
 msgid "data and log sector sizes must be equal for internal logs\n"
-msgstr "rozmiary sektora danych i logu musz± byæ równe dla logów wewnêtrznych\n"
+msgstr "rozmiary sektora danych i logu muszÄ… byÄ‡ rÃ³wne dla logÃ³w wewnÄ™trznych\n"
 
 #: ../mkfs/xfs_mkfs.c:1697
 #, c-format
@@ -3792,7 +3792,7 @@ msgid ""
 "reported by the device (%u).\n"
 msgstr ""
 "Uwaga: rozmiar sektora podwolumenu danych %u jest mniejszy od rozmiaru\n"
-"sektora zg³aszanego przez urz±dzenie (%u).\n"
+"sektora zgÅ‚aszanego przez urzÄ…dzenie (%u).\n"
 
 #: ../mkfs/xfs_mkfs.c:1703
 #, c-format
@@ -3801,7 +3801,7 @@ msgid ""
 "reported by the device (%u).\n"
 msgstr ""
 "Uwaga: rozmiar sektora podwolumenu logu %u jest mniejszy od rozmiaru\n"
-"sektora zg³aszanego przez urz±dzenie (%u).\n"
+"sektora zgÅ‚aszanego przez urzÄ…dzenie (%u).\n"
 
 #: ../mkfs/xfs_mkfs.c:1709
 #, c-format
@@ -3810,37 +3810,37 @@ msgid ""
 "reported by the device (%u).\n"
 msgstr ""
 "Uwaga: rozmiar sektora podwolumenu realtime %u jest mniejszy od rozmiaru\n"
-"sektora zg³aszanego przez urz±dzenie (%u).\n"
+"sektora zgÅ‚aszanego przez urzÄ…dzenie (%u).\n"
 
 #: ../mkfs/xfs_mkfs.c:1723
 #, c-format
 msgid "size %s specified for log subvolume is too large, maximum is %lld blocks\n"
-msgstr "rozmiar %s podany dla podwolumenu logu jest zbyt du¿y, maksimum to %lld bloków\n"
+msgstr "rozmiar %s podany dla podwolumenu logu jest zbyt duÅ¼y, maksimum to %lld blokÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:1730
 #, c-format
 msgid "size specified for non-existent log subvolume\n"
-msgstr "podano rozmiar dla nie istniej±cego podwolumenu logu\n"
+msgstr "podano rozmiar dla nie istniejÄ…cego podwolumenu logu\n"
 
 #: ../mkfs/xfs_mkfs.c:1733
 #, c-format
 msgid "size %lld too large for internal log\n"
-msgstr "rozmiar %lld jest zbyt du¿y dla logu wewnêtrznego\n"
+msgstr "rozmiar %lld jest zbyt duÅ¼y dla logu wewnÄ™trznego\n"
 
 #: ../mkfs/xfs_mkfs.c:1760
 #, c-format
 msgid "size %s specified for rt subvolume is too large, maximum is %lld blocks\n"
-msgstr "rozmiar %s podany dla podwolumenu rt jest zbyt du¿y, maksimum to %lld bloków\n"
+msgstr "rozmiar %s podany dla podwolumenu rt jest zbyt duÅ¼y, maksimum to %lld blokÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:1768
 #, c-format
 msgid "size specified for non-existent rt subvolume\n"
-msgstr "podano rozmiar dla nie istniej±cego podwolumenu rt\n"
+msgstr "podano rozmiar dla nie istniejÄ…cego podwolumenu rt\n"
 
 #: ../mkfs/xfs_mkfs.c:1785
 #, c-format
 msgid "agsize (%lld) not a multiple of fs blk size (%d)\n"
-msgstr "agsize (%lld) nie jest wielokrotno¶ci± rozmiaru bloku systemu plików (%d)\n"
+msgstr "agsize (%lld) nie jest wielokrotnoÅ›ciÄ… rozmiaru bloku systemu plikÃ³w (%d)\n"
 
 #: ../mkfs/xfs_mkfs.c:1802
 #, c-format
@@ -3850,17 +3850,17 @@ msgstr "%s: Podana jednostka pasa danych %d nie jest taka sama jak jednostka pas
 #: ../mkfs/xfs_mkfs.c:1809
 #, c-format
 msgid "%s: Specified data stripe width %d is not the same as the volume stripe width %d\n"
-msgstr "%s: Podana szeroko¶æ pasa danych %d nie jest taka sama jak szeroko¶æ pasa wolumenu %d\n"
+msgstr "%s: Podana szerokoÅ›Ä‡ pasa danych %d nie jest taka sama jak szerokoÅ›Ä‡ pasa wolumenu %d\n"
 
 #: ../mkfs/xfs_mkfs.c:1857
 #, c-format
 msgid "agsize rounded to %lld, swidth = %d\n"
-msgstr "agsize zaokr±glone do %lld, swidth = %d\n"
+msgstr "agsize zaokrÄ…glone do %lld, swidth = %d\n"
 
 #: ../mkfs/xfs_mkfs.c:1864
 #, c-format
 msgid "Allocation group size (%lld) is not a multiple of the stripe unit (%d)\n"
-msgstr "Rozmiar grupy alokacji (%lld) nie jest wielokrotno¶ci± jednostki pasa (%d)\n"
+msgstr "Rozmiar grupy alokacji (%lld) nie jest wielokrotnoÅ›ciÄ… jednostki pasa (%d)\n"
 
 #: ../mkfs/xfs_mkfs.c:1886
 #, c-format
@@ -3869,25 +3869,25 @@ msgid ""
 "problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n"
 "an AG size that is one stripe unit smaller, for example %llu.\n"
 msgstr ""
-"Uwaga: rozmiar AG jest wielokrotno¶ci± szeroko¶ci pasa. Mo¿e to spowodowaæ\n"
-"problemy z wydajno¶ci± poprzez wyrównanie wszystkich AG na tym samym dysku.\n"
-"Aby temu zapobiec, nale¿y uruchomiæ mkfs z rozmiarem AG o jedn± jednostkê\n"
-"pasa mniejszym, na przyk³ad %llu.\n"
+"Uwaga: rozmiar AG jest wielokrotnoÅ›ciÄ… szerokoÅ›ci pasa. MoÅ¼e to spowodowaÄ‡\n"
+"problemy z wydajnoÅ›ciÄ… poprzez wyrÃ³wnanie wszystkich AG na tym samym dysku.\n"
+"Aby temu zapobiec, naleÅ¼y uruchomiÄ‡ mkfs z rozmiarem AG o jednÄ… jednostkÄ™\n"
+"pasa mniejszym, na przykÅ‚ad %llu.\n"
 
 #: ../mkfs/xfs_mkfs.c:1911
 #, c-format
 msgid "%s: Stripe unit(%d) or stripe width(%d) is not a multiple of the block size(%d)\n"
-msgstr "%s: Jednostka pasa (%d) lub szeroko¶æ pasa (%d) nie jest wielokrotno¶ci± rozmiaru bloku (%d)\n"
+msgstr "%s: Jednostka pasa (%d) lub szerokoÅ›Ä‡ pasa (%d) nie jest wielokrotnoÅ›ciÄ… rozmiaru bloku (%d)\n"
 
 #: ../mkfs/xfs_mkfs.c:1943
 #, c-format
 msgid "log stripe unit (%d) must be a multiple of the block size (%d)\n"
-msgstr "jednostka pasa logu (%d) musi byæ wielokrotno¶ci± rozmiaru bloku (%d)\n"
+msgstr "jednostka pasa logu (%d) musi byÄ‡ wielokrotnoÅ›ciÄ… rozmiaru bloku (%d)\n"
 
 #: ../mkfs/xfs_mkfs.c:1956
 #, c-format
 msgid "log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
-msgstr "jednostka pasa logu (%d bajtów) jest zbyt du¿a (maksimum to 256KiB)\n"
+msgstr "jednostka pasa logu (%d bajtÃ³w) jest zbyt duÅ¼a (maksimum to 256KiB)\n"
 
 #: ../mkfs/xfs_mkfs.c:1959
 #, c-format
@@ -3897,12 +3897,12 @@ msgstr "jednostka pasa logu zmodyfikowana na 32KiB\n"
 #: ../mkfs/xfs_mkfs.c:1984
 #, c-format
 msgid "internal log size %lld too large, must fit in allocation group\n"
-msgstr "rozmiar wewnêtrznego logu %lld zbyt du¿y, musi siê zmie¶ciæ w grupie alokacji\n"
+msgstr "rozmiar wewnÄ™trznego logu %lld zbyt duÅ¼y, musi siÄ™ zmieÅ›ciÄ‡ w grupie alokacji\n"
 
 #: ../mkfs/xfs_mkfs.c:1991
 #, c-format
 msgid "log ag number %d too large, must be less than %lld\n"
-msgstr "liczba ag logu %d zbyt du¿a, musi byæ mniejsza ni¿ %lld\n"
+msgstr "liczba ag logu %d zbyt duÅ¼a, musi byÄ‡ mniejsza niÅ¼ %lld\n"
 
 #: ../mkfs/xfs_mkfs.c:2021
 #, c-format
@@ -3916,44 +3916,44 @@ msgid ""
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
 msgstr ""
-"metadane=%-22s isize=%-6d agcount=%lld, agsize=%lld bloków\n"
+"metadane=%-22s isize=%-6d agcount=%lld, agsize=%lld blokÃ³w\n"
 "        =%-22s sectsz=%-5u attr=%u\n"
 "dane    =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
-"        =%-22s sunit=%-6u swidth=%u bloków\n"
+"        =%-22s sunit=%-6u swidth=%u blokÃ³w\n"
 "nazwy   =wersja %-14u bsize=%-6u ascii-ci=%d\n"
 "log     =%-22s bsize=%-6d blocks=%lld, wersja=%d\n"
-"        =%-22s sectsz=%-5u sunit=%d bloków, lazy-count=%d\n"
+"        =%-22s sectsz=%-5u sunit=%d blokÃ³w, lazy-count=%d\n"
 "realtime=%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
 
 #: ../mkfs/xfs_mkfs.c:2137
 #, c-format
 msgid "%s: Growing the data section failed\n"
-msgstr "%s: Powiêkszenie sekcji danych nie powiod³o siê\n"
+msgstr "%s: PowiÄ™kszenie sekcji danych nie powiodÅ‚o siÄ™\n"
 
 #: ../mkfs/xfs_mkfs.c:2167
 #, c-format
 msgid "%s: filesystem failed to initialize\n"
-msgstr "%s: nie uda³o siê zainicjowaæ systemu plików\n"
+msgstr "%s: nie udaÅ‚o siÄ™ zainicjowaÄ‡ systemu plikÃ³w\n"
 
 #: ../mkfs/xfs_mkfs.c:2378
 #, c-format
 msgid "%s: root inode created in AG %u, not AG 0\n"
-msgstr "%s: g³ówny i-wêze³ utworzony w AG %u, nie AG 0\n"
+msgstr "%s: gÅ‚Ã³wny i-wÄ™zeÅ‚ utworzony w AG %u, nie AG 0\n"
 
 #: ../mkfs/xfs_mkfs.c:2445
 #, c-format
 msgid "Cannot specify both -%c %s and -%c %s\n"
-msgstr "Nie mo¿na podaæ jednocze¶nie -%c %s i %c %s\n"
+msgstr "Nie moÅ¼na podaÄ‡ jednoczeÅ›nie -%c %s i %c %s\n"
 
 #: ../mkfs/xfs_mkfs.c:2456
 #, c-format
 msgid "Illegal value %s for -%s option\n"
-msgstr "Niedozwolona warto¶æ %s dla opcji -%s\n"
+msgstr "Niedozwolona wartoÅ›Ä‡ %s dla opcji -%s\n"
 
 #: ../mkfs/xfs_mkfs.c:2473
 #, c-format
 msgid "-%c %s option requires a value\n"
-msgstr "Opcja -%c %s wymaga warto¶ci\n"
+msgstr "Opcja -%c %s wymaga wartoÅ›ci\n"
 
 #: ../mkfs/xfs_mkfs.c:2486 ../repair/xfs_repair.c:170
 #, c-format
@@ -3968,7 +3968,7 @@ msgstr "nieznana opcja -%c %s\n"
 #: ../mkfs/xfs_mkfs.c:2534
 #, c-format
 msgid "blocksize not available yet.\n"
-msgstr "rozmiar bloku jeszcze nie dostêpny.\n"
+msgstr "rozmiar bloku jeszcze nie dostÄ™pny.\n"
 
 #: ../mkfs/xfs_mkfs.c:2560
 #, c-format
@@ -3995,28 +3995,28 @@ msgid ""
 "      xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).\n"
 "<value> is xxx (512 byte blocks).\n"
 msgstr ""
-"Sk³adnia: %s\n"
+"SkÅ‚adnia: %s\n"
 "/* rozmiar bloku */     [-b log=n|size=liczba]\n"
 "/* podwolumen danych */ [-d agcount=n,agsize=n,file,name=xxx,size=liczba,\n"
-"                           (sunit=warto¶æ,swidth=warto¶æ|su=liczba,sw=liczba),\n"
+"                           (sunit=wartoÅ›Ä‡,swidth=wartoÅ›Ä‡|su=liczba,sw=liczba),\n"
 "                           sectlog=n|sectsize=liczba]\n"
-"/* rozmiar i-wêz³a */   [-i log=n|perblock=n|size=liczba,maxpct=n,attr=0|1|2]\n"
+"/* rozmiar i-wÄ™zÅ‚a */   [-i log=n|perblock=n|size=liczba,maxpct=n,attr=0|1|2]\n"
 "/* podwolumen logu */   [-i agnum=n,internal,size=liczba,logdev=xxx,version=n\n"
-"                           sunit=warto¶æ|su=liczba,sectlog=n|sectsize=liczba,\n"
+"                           sunit=wartoÅ›Ä‡|su=liczba,sectlog=n|sectsize=liczba,\n"
 "                           lazy-count=0|1]\n"
-"/* etykieta */          [-L etykieta (maksymalnie 12 znaków)]\n"
+"/* etykieta */          [-L etykieta (maksymalnie 12 znakÃ³w)]\n"
 "/* nazwy */             [-n log=n|size=liczba,wersja=2|ci]\n"
 "/* plik prototypu */    [-p nazwa_pliku]\n"
 "/* cisza */             [-q]\n"
 "/* podwolumen rt */     [-r extsize=liczba,size=liczba,rtdev=xxx]\n"
 "/* rozmiar sektora */   [-s log=n|size=liczba]\n"
 "/* wersja */            [-V]\n"
-"                        nazwa_urz±dzenia\n"
-"<nazwa_urz±dzenia> jest wymagana, chyba ¿e podano -d name=xxx.\n"
-"<liczba> to xxx (bajtów), xxxs (sektorów), xxxb (bloków systemu plików),\n"
+"                        nazwa_urzÄ…dzenia\n"
+"<nazwa_urzÄ…dzenia> jest wymagana, chyba Å¼e podano -d name=xxx.\n"
+"<liczba> to xxx (bajtÃ³w), xxxs (sektorÃ³w), xxxb (blokÃ³w systemu plikÃ³w),\n"
 "         xxxk (xxx KiB), xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB),\n"
 "         xxxp (xxx PiB).\n"
-"<warto¶æ> to xxx (512-bajtowych bloków).\n"
+"<wartoÅ›Ä‡> to xxx (512-bajtowych blokÃ³w).\n"
 
 #: ../quota/edit.c:36
 #, c-format
@@ -4040,21 +4040,21 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" zmiana limitów quot dla podanego u¿ytkownika\n"
+" zmiana limitÃ³w quot dla podanego uÅ¼ytkownika\n"
 "\n"
-"Przyk³ad:\n"
+"PrzykÅ‚ad:\n"
 " 'limit bsoft=100m bhard=110m tanya'\n"
 "\n"
-" limit zmienia miêkki i/lub twardy limit bloków, limity i-wêz³ów i/lub limity\n"
-" bloków realtime aktualnie u¿ywane dla podanego u¿ytkownika, grupy lub projektu.\n"
-" System plików okre¶lony bie¿±c± ¶cie¿k± jest modyfikowany.\n"
-" -d - ustawienie warto¶ci domy¶lnych, u¿ytych pierwszy raz przy tworzeniu pliku\n"
-" -g - zmiana limitów quot grupy\n"
-" -p - zmiana limitów quot projektu\n"
-" -u - zmiana limitów quot u¿ytkownika\n"
-" Warto¶ci limitów bloków mog± byæ podane z koñcówk± jednostki - przyjmowane\n"
+" limit zmienia miÄ™kki i/lub twardy limit blokÃ³w, limity i-wÄ™zÅ‚Ã³w i/lub limity\n"
+" blokÃ³w realtime aktualnie uÅ¼ywane dla podanego uÅ¼ytkownika, grupy lub projektu.\n"
+" System plikÃ³w okreÅ›lony bieÅ¼Ä…cÄ… Å›cieÅ¼kÄ… jest modyfikowany.\n"
+" -d - ustawienie wartoÅ›ci domyÅ›lnych, uÅ¼ytych pierwszy raz przy tworzeniu pliku\n"
+" -g - zmiana limitÃ³w quot grupy\n"
+" -p - zmiana limitÃ³w quot projektu\n"
+" -u - zmiana limitÃ³w quot uÅ¼ytkownika\n"
+" WartoÅ›ci limitÃ³w blokÃ³w mogÄ… byÄ‡ podane z koÅ„cÃ³wkÄ… jednostki - przyjmowane\n"
 " jednostki to: k (kilobajty), m (megabajty), g (gigabajty) i t (terabajty).\n"
-" U¿ytkownik/grupa/projekt mo¿e byæ podany za pomoc± nazwy lub numeru.\n"
+" UÅ¼ytkownik/grupa/projekt moÅ¼e byÄ‡ podany za pomocÄ… nazwy lub numeru.\n"
 "\n"
 
 #: ../quota/edit.c:59
@@ -4088,29 +4088,29 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" zmiana czasu wymuszenia limitów dla bie¿±cego systemu plików\n"
+" zmiana czasu wymuszenia limitÃ³w dla bieÅ¼Ä…cego systemu plikÃ³w\n"
 "\n"
-" Przyk³ad:\n"
+" PrzykÅ‚ad:\n"
 " 'timer -i 3days'\n"
-" (zmiana czasu wymuszenia miêkkiego limitu i-wêz³ów na 3 dni)\n"
-"\n"
-" timer zmienia warto¶æ ograniczenia czasu zwi±zanego z limitami bloków,\n"
-" limitami i-wêz³ów i/lub limitami bloków realtime dla wszystkich u¿ytkowników,\n"
-" grup lub projektów na bie¿±cym systemie plików.\n"
-" Po tym jak u¿ytkownik wykorzysta ilo¶æ miejsca lub liczbê i-wêz³ów ustawion±\n"
-" jako miêkki limit, zaczyna dzia³aæ zegar. Kiedy czas minie, a u¿ytkownik nadal\n"
-" przekracza miêkki limit, miêkki limit staje siê twardym.\n"
-" Domy¶lne ograniczenie czasowe to 7 dni.\n"
-" -d - ustawienie warto¶ci domy¶lnych, u¿ytych pierwszy raz przy tworzeniu pliku\n"
-" -g - zmiana czasu dla limitów quot grup\n"
-" -p - zmiana czasu dla limitów quot projektów\n"
-" -u - zmiana czasu dla limitów quot u¿ytkowników\n"
-" -b - zmiana czasu dla u¿ytych bloków\n"
-" -i - zmiana czasu dla u¿ytych i-wêz³ów\n"
-" -r - zmiana czasu dla u¿ytych bloków na (opcjonalnym) podwolumenie realtime\n"
-" Warto¶æ ograniczenia czasu jest podawana domy¶lnie jako liczba sekund.\n"
-" Jednak mo¿na dodaæ koñcówkê, aby podaæ czas w minutach (m), godzinach (h),\n"
-" dniach (d) lub tygodniach (w) - mo¿na u¿yæ pe³nego s³owa lub pierwsze litery.\n"
+" (zmiana czasu wymuszenia miÄ™kkiego limitu i-wÄ™zÅ‚Ã³w na 3 dni)\n"
+"\n"
+" timer zmienia wartoÅ›Ä‡ ograniczenia czasu zwiÄ…zanego z limitami blokÃ³w,\n"
+" limitami i-wÄ™zÅ‚Ã³w i/lub limitami blokÃ³w realtime dla wszystkich uÅ¼ytkownikÃ³w,\n"
+" grup lub projektÃ³w na bieÅ¼Ä…cym systemie plikÃ³w.\n"
+" Po tym jak uÅ¼ytkownik wykorzysta iloÅ›Ä‡ miejsca lub liczbÄ™ i-wÄ™zÅ‚Ã³w ustawionÄ…\n"
+" jako miÄ™kki limit, zaczyna dziaÅ‚aÄ‡ zegar. Kiedy czas minie, a uÅ¼ytkownik nadal\n"
+" przekracza miÄ™kki limit, miÄ™kki limit staje siÄ™ twardym.\n"
+" DomyÅ›lne ograniczenie czasowe to 7 dni.\n"
+" -d - ustawienie wartoÅ›ci domyÅ›lnych, uÅ¼ytych pierwszy raz przy tworzeniu pliku\n"
+" -g - zmiana czasu dla limitÃ³w quot grup\n"
+" -p - zmiana czasu dla limitÃ³w quot projektÃ³w\n"
+" -u - zmiana czasu dla limitÃ³w quot uÅ¼ytkownikÃ³w\n"
+" -b - zmiana czasu dla uÅ¼ytych blokÃ³w\n"
+" -i - zmiana czasu dla uÅ¼ytych i-wÄ™zÅ‚Ã³w\n"
+" -r - zmiana czasu dla uÅ¼ytych blokÃ³w na (opcjonalnym) podwolumenie realtime\n"
+" WartoÅ›Ä‡ ograniczenia czasu jest podawana domyÅ›lnie jako liczba sekund.\n"
+" Jednak moÅ¼na dodaÄ‡ koÅ„cÃ³wkÄ™, aby podaÄ‡ czas w minutach (m), godzinach (h),\n"
+" dniach (d) lub tygodniach (w) - moÅ¼na uÅ¼yÄ‡ peÅ‚nego sÅ‚owa lub pierwsze litery.\n"
 "\n"
 
 #: ../quota/edit.c:91
@@ -4141,52 +4141,52 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" zmiana liczby ostrze¿eñ quot wysy³anych do podanego u¿ytkownika\n"
+" zmiana liczby ostrzeÅ¼eÅ„ quot wysyÅ‚anych do podanego uÅ¼ytkownika\n"
 "\n"
-" Przyk³ad:\n"
+" PrzykÅ‚ad:\n"
 " 'warn 2 jimmy'\n"
-" (przekazanie systemowi quota, ¿e wys³ano 2 ostrze¿enia do u¿ytkownika jimmy)\n"
-"\n"
-" warn zmienia liczbê ostrze¿eñ zwi±zanych z limitami bloków, limitami i-wêz³ów\n"
-" i/lub limitami bloków realtime dla podanego u¿ytkownika, grupy lub projektu.\n"
-" Kiedy u¿ytkownik zosta³ ostrze¿ony maksymaln± dozwolon± liczbê razy, miêkki\n"
-" limit staje siê twardym. Jest to pomy¶lane jako alternatywa dla systemu\n"
-" ograniczeñ czasowych, gdzie administrator uaktualnia licznik ostrze¿eñ\n"
-" wys³anych do ludzi i karze u¿ytkowników ignoruj±cych ostrze¿enia.\n"
-" -d - ustawienie maksymalnej liczby ostrze¿eñ, po której wymuszane s± limity\n"
-" -g - ustawienie liczby ostrze¿eñ dla grupy\n"
-" -p - ustawienie liczby ostrze¿eñ dla projektu\n"
-" -u - ustawienie liczby ostrze¿eñ dla grupy\n"
-" -b - ustawienie liczby ostrze¿eñ dla u¿ytych bloków\n"
-" -i - ustawienie liczby ostrze¿eñ dla u¿ytych i-wêz³ów\n"
-" -r - ustawienie liczby ostrze¿eñ dla u¿ytych bloków na podwolumenie realtime\n"
-" U¿ytkownik/grupa/projekt mo¿e byæ podany za pomoc± nazwy lub numeru.\n"
+" (przekazanie systemowi quota, Å¼e wysÅ‚ano 2 ostrzeÅ¼enia do uÅ¼ytkownika jimmy)\n"
+"\n"
+" warn zmienia liczbÄ™ ostrzeÅ¼eÅ„ zwiÄ…zanych z limitami blokÃ³w, limitami i-wÄ™zÅ‚Ã³w\n"
+" i/lub limitami blokÃ³w realtime dla podanego uÅ¼ytkownika, grupy lub projektu.\n"
+" Kiedy uÅ¼ytkownik zostaÅ‚ ostrzeÅ¼ony maksymalnÄ… dozwolonÄ… liczbÄ™ razy, miÄ™kki\n"
+" limit staje siÄ™ twardym. Jest to pomyÅ›lane jako alternatywa dla systemu\n"
+" ograniczeÅ„ czasowych, gdzie administrator uaktualnia licznik ostrzeÅ¼eÅ„\n"
+" wysÅ‚anych do ludzi i karze uÅ¼ytkownikÃ³w ignorujÄ…cych ostrzeÅ¼enia.\n"
+" -d - ustawienie maksymalnej liczby ostrzeÅ¼eÅ„, po ktÃ³rej wymuszane sÄ… limity\n"
+" -g - ustawienie liczby ostrzeÅ¼eÅ„ dla grupy\n"
+" -p - ustawienie liczby ostrzeÅ¼eÅ„ dla projektu\n"
+" -u - ustawienie liczby ostrzeÅ¼eÅ„ dla grupy\n"
+" -b - ustawienie liczby ostrzeÅ¼eÅ„ dla uÅ¼ytych blokÃ³w\n"
+" -i - ustawienie liczby ostrzeÅ¼eÅ„ dla uÅ¼ytych i-wÄ™zÅ‚Ã³w\n"
+" -r - ustawienie liczby ostrzeÅ¼eÅ„ dla uÅ¼ytych blokÃ³w na podwolumenie realtime\n"
+" UÅ¼ytkownik/grupa/projekt moÅ¼e byÄ‡ podany za pomocÄ… nazwy lub numeru.\n"
 "\n"
 
 #: ../quota/edit.c:145
 #, c-format
 msgid "%s: cannot set limits: %s\n"
-msgstr "%s: nie mo¿na ustawiæ limitów: %s\n"
+msgstr "%s: nie moÅ¼na ustawiÄ‡ limitÃ³w: %s\n"
 
 #: ../quota/edit.c:166 ../quota/edit.c:563
 #, c-format
 msgid "%s: invalid user name: %s\n"
-msgstr "%s: nieprawid³owa nazwa u¿ytkownika: %s\n"
+msgstr "%s: nieprawidÅ‚owa nazwa uÅ¼ytkownika: %s\n"
 
 #: ../quota/edit.c:189 ../quota/edit.c:580
 #, c-format
 msgid "%s: invalid group name: %s\n"
-msgstr "%s: nieprawid³owa nazwa grupy: %s\n"
+msgstr "%s: nieprawidÅ‚owa nazwa grupy: %s\n"
 
 #: ../quota/edit.c:212 ../quota/edit.c:597
 #, c-format
 msgid "%s: invalid project name: %s\n"
-msgstr "%s: nieprawid³owa nazwa projektu: %s\n"
+msgstr "%s: nieprawidÅ‚owa nazwa projektu: %s\n"
 
 #: ../quota/edit.c:237
 #, c-format
 msgid "%s: Warning: `%s' in quota blocks is 0 (unlimited).\n"
-msgstr "%s: Uwaga: `%s' w blokach limitów wynosi 0 (bez ograniczeñ).\n"
+msgstr "%s: Uwaga: `%s' w blokach limitÃ³w wynosi 0 (bez ograniczeÅ„).\n"
 
 #: ../quota/edit.c:326
 #, c-format
@@ -4196,22 +4196,22 @@ msgstr "%s: nierozpoznany argument %s\n"
 #: ../quota/edit.c:333
 #, c-format
 msgid "%s: cannot find any valid arguments\n"
-msgstr "%s: nie mo¿na znale¼æ ¿adnych poprawnych argumentów\n"
+msgstr "%s: nie moÅ¼na znaleÅºÄ‡ Å¼adnych poprawnych argumentÃ³w\n"
 
 #: ../quota/edit.c:441
 #, c-format
 msgid "%s: fopen on %s failed: %s\n"
-msgstr "%s: fopen na %s nie powiod³o siê: %s\n"
+msgstr "%s: fopen na %s nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../quota/edit.c:473
 #, c-format
 msgid "%s: cannot set timer: %s\n"
-msgstr "%s: nie mo¿na ustawiæ czasu: %s\n"
+msgstr "%s: nie moÅ¼na ustawiÄ‡ czasu: %s\n"
 
 #: ../quota/edit.c:547
 #, c-format
 msgid "%s: cannot set warnings: %s\n"
-msgstr "%s: nie mo¿na ustawiæ ostrze¿eñ: %s\n"
+msgstr "%s: nie moÅ¼na ustawiÄ‡ ostrzeÅ¼eÅ„: %s\n"
 
 #: ../quota/edit.c:678
 msgid "limit"
@@ -4223,7 +4223,7 @@ msgstr "[-gpu] bsoft|bhard|isoft|ihard|rtbsoft|rtbhard=N -d|id|nazwa"
 
 #: ../quota/edit.c:684
 msgid "modify quota limits"
-msgstr "zmiana limitów quot"
+msgstr "zmiana limitÃ³w quot"
 
 #: ../quota/edit.c:687
 msgid "restore"
@@ -4235,7 +4235,7 @@ msgstr "[-gpu] [-f plik]"
 
 #: ../quota/edit.c:692
 msgid "restore quota limits from a backup file"
-msgstr "odtworzenie limitów quot z pliku kopii zapasowej"
+msgstr "odtworzenie limitÃ³w quot z pliku kopii zapasowej"
 
 #: ../quota/edit.c:694
 msgid "timer"
@@ -4243,7 +4243,7 @@ msgstr "timer"
 
 #: ../quota/edit.c:698 ../quota/edit.c:706
 msgid "[-bir] [-gpu] value -d|id|name"
-msgstr "[-bir] [-gpu] warto¶æ -d|id|nazwa"
+msgstr "[-bir] [-gpu] wartoÅ›Ä‡ -d|id|nazwa"
 
 #: ../quota/edit.c:699
 msgid "get/set quota enforcement timeouts"
@@ -4255,7 +4255,7 @@ msgstr "warn"
 
 #: ../quota/edit.c:707
 msgid "get/set enforcement warning counter"
-msgstr "pobranie/ustawienie licznika ostrze¿eñ"
+msgstr "pobranie/ustawienie licznika ostrzeÅ¼eÅ„"
 
 #: ../quota/free.c:29
 #, c-format
@@ -4275,17 +4275,17 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" informacje o liczbie wolnych bloków i i-wêz³ów dysku\n"
+" informacje o liczbie wolnych blokÃ³w i i-wÄ™zÅ‚Ã³w dysku\n"
 "\n"
-" To polecenie informuje o liczbie wszystkich, u¿ywanych i dostêpnych bloków\n"
-" dysku. Opcjonalnie informuje o tym samym zestawie liczb dla i-wêz³ów i bloków\n"
-" realtime oraz domy¶lnie zg³asza wszystkie znane punkty montowania systemu\n"
-" plików XFS i ¶cie¿ki quot projektów (patrz lista w poleceniu 'print').\n"
-" -b - informacje o liczbach bloków\n"
-" -i - informacje o liczbach i-wêz³ów\n"
-" -r - informacje o liczbach bloków realtime\n"
-" -h - informacje w postaci czytelnej dla cz³owieka\n"
-" -N - pominiêcie nag³ówka z wyj¶cia\n"
+" To polecenie informuje o liczbie wszystkich, uÅ¼ywanych i dostÄ™pnych blokÃ³w\n"
+" dysku. Opcjonalnie informuje o tym samym zestawie liczb dla i-wÄ™zÅ‚Ã³w i blokÃ³w\n"
+" realtime oraz domyÅ›lnie zgÅ‚asza wszystkie znane punkty montowania systemu\n"
+" plikÃ³w XFS i Å›cieÅ¼ki quot projektÃ³w (patrz lista w poleceniu 'print').\n"
+" -b - informacje o liczbach blokÃ³w\n"
+" -i - informacje o liczbach i-wÄ™zÅ‚Ã³w\n"
+" -r - informacje o liczbach blokÃ³w realtime\n"
+" -h - informacje w postaci czytelnej dla czÅ‚owieka\n"
+" -N - pominiÄ™cie nagÅ‚Ã³wka z wyjÅ›cia\n"
 "\n"
 
 #: ../quota/free.c:146
@@ -4296,42 +4296,42 @@ msgstr "%s: flaga quot projektu nie ustawiona dla %s\n"
 #: ../quota/free.c:155
 #, c-format
 msgid "%s: project ID %u (%s) doesn't match ID %u (%s)\n"
-msgstr "%s: ID projektu %u (%s) nie zgadza siê z ID %u (%s)\n"
+msgstr "%s: ID projektu %u (%s) nie zgadza siÄ™ z ID %u (%s)\n"
 
 #: ../quota/free.c:220
 #, c-format
 msgid "Filesystem  "
-msgstr "System plików "
+msgstr "System plikÃ³w "
 
 #: ../quota/free.c:220
 #, c-format
 msgid "Filesystem          "
-msgstr "System plików       "
+msgstr "System plikÃ³w       "
 
 #: ../quota/free.c:223
 #, c-format
 msgid "   Size   Used  Avail Use%%"
-msgstr " Rozmiar  U¿yto Dost. %%u¿."
+msgstr " Rozmiar  UÅ¼yto Dost. %%uÅ¼."
 
 #: ../quota/free.c:224
 #, c-format
 msgid " 1K-blocks       Used  Available  Use%%"
-msgstr " Bloki 1K        U¿yto Dostêpnych %%u¿."
+msgstr " Bloki 1K        UÅ¼yto DostÄ™pnych %%uÅ¼."
 
 #: ../quota/free.c:227
 #, c-format
 msgid " Inodes   Used   Free Use%%"
-msgstr " I-wêz³y  U¿yto Wolne %%u¿."
+msgstr " I-wÄ™zÅ‚y  UÅ¼yto Wolne %%uÅ¼."
 
 #: ../quota/free.c:228
 #, c-format
 msgid "    Inodes      IUsed      IFree IUse%%"
-msgstr "   I-wêz³y      U¿ytoI     WolneI %%u¿I"
+msgstr "   I-wÄ™zÅ‚y      UÅ¼ytoI     WolneI %%uÅ¼I"
 
 #: ../quota/free.c:229
 #, c-format
 msgid " Pathname\n"
-msgstr " ¦cie¿ka\n"
+msgstr " ÅšcieÅ¼ka\n"
 
 #: ../quota/free.c:360
 msgid "df"
@@ -4347,17 +4347,17 @@ msgstr "[-bir] [hn] [-f plik]"
 
 #: ../quota/free.c:366
 msgid "show free and used counts for blocks and inodes"
-msgstr "pokazanie liczby wolnych i zajêtych bloków i i-wêz³ów"
+msgstr "pokazanie liczby wolnych i zajÄ™tych blokÃ³w i i-wÄ™zÅ‚Ã³w"
 
 #: ../quota/init.c:48
 #, c-format
 msgid "Usage: %s [-p prog] [-c cmd]... [-d project]... [path]\n"
-msgstr "Sk³adnia: %s [-p program] [-c polecenie]... [-d projekt]... [¶cie¿ka]\n"
+msgstr "SkÅ‚adnia: %s [-p program] [-c polecenie]... [-d projekt]... [Å›cieÅ¼ka]\n"
 
 #: ../quota/path.c:39
 #, c-format
 msgid "%sFilesystem          Pathname\n"
-msgstr "%sSystem plików       ¦cie¿ka\n"
+msgstr "%sSystem plikÃ³w       ÅšcieÅ¼ka\n"
 
 #: ../quota/path.c:40
 msgid "      "
@@ -4386,7 +4386,7 @@ msgstr ", %s"
 #: ../quota/path.c:103
 #, c-format
 msgid "No paths are available\n"
-msgstr "Brak ¶cie¿ek\n"
+msgstr "Brak Å›cieÅ¼ek\n"
 
 #: ../quota/path.c:124
 msgid "path"
@@ -4398,11 +4398,11 @@ msgstr "paths"
 
 #: ../quota/path.c:131
 msgid "set current path, or show the list of paths"
-msgstr "ustawienie bie¿±cej ¶cie¿ki lub pokazanie listy ¶cie¿ek"
+msgstr "ustawienie bieÅ¼Ä…cej Å›cieÅ¼ki lub pokazanie listy Å›cieÅ¼ek"
 
 #: ../quota/path.c:139
 msgid "list known mount points and projects"
-msgstr "wypisanie znanych punktów montowañ i projektów"
+msgstr "wypisanie znanych punktÃ³w montowaÅ„ i projektÃ³w"
 
 #: ../quota/project.c:44
 #, c-format
@@ -4446,58 +4446,58 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" wypisanie projektów lub ustanowienie drzewa projektu do zarz±dzania limitami\n"
+" wypisanie projektÃ³w lub ustanowienie drzewa projektu do zarzÄ…dzania limitami\n"
 "\n"
-" Przyk³ad:\n"
+" PrzykÅ‚ad:\n"
 " 'project -c logfiles'\n"
-" (dopasowanie projektu 'logfiles' do katalogu i ustanowienie drzewa katalogów)\n"
+" (dopasowanie projektu 'logfiles' do katalogu i ustanowienie drzewa katalogÃ³w)\n"
 "\n"
-" Bez argumentów project wypisuje wszystkie projekty znalezione w pliku\n"
-" /etc/projects. Mechanizm quota dla projektów w XFS-ie mo¿e byæ u¿ywany do\n"
-" zaimplementowania formy limitów dla drzewa katalogów, gdzie podany katalog\n"
-" i wszystkie pliki i podkatalogi poni¿ej niego (czyli drzewo) mog± byæ\n"
-" ograniczone do u¿ywania podzbioru miejsca dostêpnego w systemie plików.\n"
+" Bez argumentÃ³w project wypisuje wszystkie projekty znalezione w pliku\n"
+" /etc/projects. Mechanizm quota dla projektÃ³w w XFS-ie moÅ¼e byÄ‡ uÅ¼ywany do\n"
+" zaimplementowania formy limitÃ³w dla drzewa katalogÃ³w, gdzie podany katalog\n"
+" i wszystkie pliki i podkatalogi poniÅ¼ej niego (czyli drzewo) mogÄ… byÄ‡\n"
+" ograniczone do uÅ¼ywania podzbioru miejsca dostÄ™pnego w systemie plikÃ³w.\n"
 "\n"
-" Zarz±dzane drzewo musi byæ ustanowione pocz±tkowo przy u¿yciu opcji project -c.\n"
+" ZarzÄ…dzane drzewo musi byÄ‡ ustanowione poczÄ…tkowo przy uÅ¼yciu opcji project -c.\n"
 " Podana nazwa lub identyfikator projektu jest dopasowywany do jednego lub\n"
-" wiêkszej liczby drzew zdefiniowanych w /etc/projects, a nastêpnie te drzewa s±\n"
-" rekurencyjnie przechodzone w celu oznaczenia i-wêz³ów jako bêd±cych czê¶ci±\n"
-" tego drzewa - co ustawia flagi i-wêz³ów i identyfikator projektu dla ka¿dego\n"
+" wiÄ™kszej liczby drzew zdefiniowanych w /etc/projects, a nastÄ™pnie te drzewa sÄ…\n"
+" rekurencyjnie przechodzone w celu oznaczenia i-wÄ™zÅ‚Ã³w jako bÄ™dÄ…cych czÄ™Å›ciÄ…\n"
+" tego drzewa - co ustawia flagi i-wÄ™zÅ‚Ã³w i identyfikator projektu dla kaÅ¼dego\n"
 " pliku.\n"
-" Po zrobieniu tego nowe pliki tworzone w drzewie bêd± automatycznie liczone jako\n"
-" czê¶æ drzewa o ich identyfikatorze projektu. Próba utworzenia dowi±zania\n"
-" zwyk³ego do pliku w drzewie powiedzie siê tylko je¶li identyfikator projektu\n"
-" pasuje do identyfikatora projektu drzewa. Mo¿na u¿yæ narzêdzia xfs_io do\n"
-" ustawienia ID projektu dla dowolnego pliku, ale mo¿e tego dokonaæ tylko\n"
-" uprzywilejowany u¿ytkownik.\n"
-"\n"
-" Poprzednio ustanowione drzewa mo¿na usun±æ z kontroli limitów projektu poprzez\n"
-" u¿ycie opcji -C, która rekurencyjnie przejdzie drzewo, usuwaj±c i-wêz³y spod\n"
-" kontroli limitów projektu.\n"
-"\n"
-" Opcji -c mo¿na u¿yæ do sprawdzenia czy drzewo zosta³o ustanowione - nie\n"
-" informuje o niczym je¶li drzewo jest poprawne, a w przeciwnym wypadku zg³asza\n"
-" ¶cie¿ki i-wêz³ów nie maj±ce ID projektu takiego jak reszta drzewa lub nie\n"
-" maj±ce ustawionej flagi.\n"
-"\n"
-" Format plików /etc/projid i /etc/projects jest prosty i opisany na stronie\n"
+" Po zrobieniu tego nowe pliki tworzone w drzewie bÄ™dÄ… automatycznie liczone jako\n"
+" czÄ™Å›Ä‡ drzewa o ich identyfikatorze projektu. PrÃ³ba utworzenia dowiÄ…zania\n"
+" zwykÅ‚ego do pliku w drzewie powiedzie siÄ™ tylko jeÅ›li identyfikator projektu\n"
+" pasuje do identyfikatora projektu drzewa. MoÅ¼na uÅ¼yÄ‡ narzÄ™dzia xfs_io do\n"
+" ustawienia ID projektu dla dowolnego pliku, ale moÅ¼e tego dokonaÄ‡ tylko\n"
+" uprzywilejowany uÅ¼ytkownik.\n"
+"\n"
+" Poprzednio ustanowione drzewa moÅ¼na usunÄ…Ä‡ z kontroli limitÃ³w projektu poprzez\n"
+" uÅ¼ycie opcji -C, ktÃ³ra rekurencyjnie przejdzie drzewo, usuwajÄ…c i-wÄ™zÅ‚y spod\n"
+" kontroli limitÃ³w projektu.\n"
+"\n"
+" Opcji -c moÅ¼na uÅ¼yÄ‡ do sprawdzenia czy drzewo zostaÅ‚o ustanowione - nie\n"
+" informuje o niczym jeÅ›li drzewo jest poprawne, a w przeciwnym wypadku zgÅ‚asza\n"
+" Å›cieÅ¼ki i-wÄ™zÅ‚Ã³w nie majÄ…ce ID projektu takiego jak reszta drzewa lub nie\n"
+" majÄ…ce ustawionej flagi.\n"
+"\n"
+" Format plikÃ³w /etc/projid i /etc/projects jest prosty i opisany na stronie\n"
 " manuala xfs_quota.\n"
 "\n"
 
 #: ../quota/project.c:95 ../quota/project.c:137 ../quota/project.c:181
 #, c-format
 msgid "%s: cannot stat file %s\n"
-msgstr "%s: nie mo¿na wykonaæ stat na pliku %s\n"
+msgstr "%s: nie moÅ¼na wykonaÄ‡ stat na pliku %s\n"
 
 #: ../quota/project.c:99 ../quota/project.c:141 ../quota/project.c:185
 #, c-format
 msgid "%s: skipping special file %s\n"
-msgstr "%s: pominiêto plik specjalny %s\n"
+msgstr "%s: pominiÄ™to plik specjalny %s\n"
 
 #: ../quota/project.c:113
 #, c-format
 msgid "%s - project identifier is not set (inode=%u, tree=%u)\n"
-msgstr "%s - identyfikator projektu nie ustawiony (i-wêze³=%u, drzewo=%u)\n"
+msgstr "%s - identyfikator projektu nie ustawiony (i-wÄ™zeÅ‚=%u, drzewo=%u)\n"
 
 #: ../quota/project.c:117
 #, c-format
@@ -4507,37 +4507,37 @@ msgstr "%s - flaga dziedziczenia projektu nie ustawiona\n"
 #: ../quota/project.c:162
 #, c-format
 msgid "%s: cannot clear project on %s: %s\n"
-msgstr "%s: nie mo¿na usun±æ projektu z %s: %s\n"
+msgstr "%s: nie moÅ¼na usunÄ…Ä‡ projektu z %s: %s\n"
 
 #: ../quota/project.c:206
 #, c-format
 msgid "%s: cannot set project on %s: %s\n"
-msgstr "%s: nie mo¿na ustawiæ projektu na %s: %s\n"
+msgstr "%s: nie moÅ¼na ustawiÄ‡ projektu na %s: %s\n"
 
 #: ../quota/project.c:221
 #, c-format
 msgid "Checking project %s (path %s)...\n"
-msgstr "Sprawdzanie projektu %s (¶cie¿ka %s)...\n"
+msgstr "Sprawdzanie projektu %s (Å›cieÅ¼ka %s)...\n"
 
 #: ../quota/project.c:225
 #, c-format
 msgid "Setting up project %s (path %s)...\n"
-msgstr "Ustanawianie projektu %s (¶cie¿ka %s)...\n"
+msgstr "Ustanawianie projektu %s (Å›cieÅ¼ka %s)...\n"
 
 #: ../quota/project.c:229
 #, c-format
 msgid "Clearing project %s (path %s)...\n"
-msgstr "Usuwanie projektu %s (¶cie¿ka %s)...\n"
+msgstr "Usuwanie projektu %s (Å›cieÅ¼ka %s)...\n"
 
 #: ../quota/project.c:252
 #, c-format
 msgid "Processed %d %s paths for project %s\n"
-msgstr "Przetworzono %d ¶cie¿ek %s dla projektu %s\n"
+msgstr "Przetworzono %d Å›cieÅ¼ek %s dla projektu %s\n"
 
 #: ../quota/project.c:289
 #, c-format
 msgid "projects file \"%s\" doesn't exist\n"
-msgstr "plik projektów \"%s\" nie istnieje\n"
+msgstr "plik projektÃ³w \"%s\" nie istnieje\n"
 
 #: ../quota/project.c:298
 #, c-format
@@ -4558,7 +4558,7 @@ msgstr "[-c|-s|-C] projekt ..."
 
 #: ../quota/project.c:317
 msgid "check, setup or clear project quota trees"
-msgstr "sprawdzenie, ustanowienie lub usuniêcie drzew projektów"
+msgstr "sprawdzenie, ustanowienie lub usuniÄ™cie drzew projektÃ³w"
 
 #: ../quota/quot.c:55
 #, c-format
@@ -4587,24 +4587,24 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" wy¶wietlenie podsumowania w³asno¶ci systemu plików\n"
-"\n"
-" -a - podsumowanie dla wszystkich punktów montowania systemów plików XFS\n"
-" -c - wy¶wietlenie trzech kolumn z rozmiarem plików w kilobajtach, liczb±\n"
-"      plików tego rozmiaru i sum± kilobajtów w plikach o tym lub mniejszym\n"
-"      rozmiarze. Ostatni wiersz podsumowuje pliki wiêksze ni¿ 500 kilobajtów.\n"
-" -v - wy¶wietlenie trzech kolumn zawieraj±cych liczbê kilobajtów, do których\n"
-"      nie by³o odwo³añ przez ostatnie 30, 60 i 90 dni.\n"
-" -g - wy¶wietlenie podsumowania dla grup\n"
-" -p - wy¶wietlenie podsumowania dla projektów\n"
-" -u - wy¶wietlenie podsumowania dla u¿ytkowników\n"
-" -b - wy¶wietlenie liczby wykorzystanych bloków\n"
-" -i - wy¶wietlenie liczby wykorzystanych i-wêz³ów\n"
-" -r - wy¶wietlenie liczby wykorzystanych blików realtime\n"
-" -n - pominiêcie t³umaczenia identyfikatorów na nazwy, wypisywanie ID\n"
-" -N - pominiêcie pocz±tkowego nag³ówka\n"
-" -f - zapisanie wyj¶cia do pliku\n"
-" (opcjonalny) u¿ytkownik/grupa/projekt mo¿e byæ podany za pomoc± nazwy lub\n"
+" wyÅ›wietlenie podsumowania wÅ‚asnoÅ›ci systemu plikÃ³w\n"
+"\n"
+" -a - podsumowanie dla wszystkich punktÃ³w montowania systemÃ³w plikÃ³w XFS\n"
+" -c - wyÅ›wietlenie trzech kolumn z rozmiarem plikÃ³w w kilobajtach, liczbÄ…\n"
+"      plikÃ³w tego rozmiaru i sumÄ… kilobajtÃ³w w plikach o tym lub mniejszym\n"
+"      rozmiarze. Ostatni wiersz podsumowuje pliki wiÄ™ksze niÅ¼ 500 kilobajtÃ³w.\n"
+" -v - wyÅ›wietlenie trzech kolumn zawierajÄ…cych liczbÄ™ kilobajtÃ³w, do ktÃ³rych\n"
+"      nie byÅ‚o odwoÅ‚aÅ„ przez ostatnie 30, 60 i 90 dni.\n"
+" -g - wyÅ›wietlenie podsumowania dla grup\n"
+" -p - wyÅ›wietlenie podsumowania dla projektÃ³w\n"
+" -u - wyÅ›wietlenie podsumowania dla uÅ¼ytkownikÃ³w\n"
+" -b - wyÅ›wietlenie liczby wykorzystanych blokÃ³w\n"
+" -i - wyÅ›wietlenie liczby wykorzystanych i-wÄ™zÅ‚Ã³w\n"
+" -r - wyÅ›wietlenie liczby wykorzystanych blikÃ³w realtime\n"
+" -n - pominiÄ™cie tÅ‚umaczenia identyfikatorÃ³w na nazwy, wypisywanie ID\n"
+" -N - pominiÄ™cie poczÄ…tkowego nagÅ‚Ã³wka\n"
+" -f - zapisanie wyjÅ›cia do pliku\n"
+" (opcjonalny) uÅ¼ytkownik/grupa/projekt moÅ¼e byÄ‡ podany za pomocÄ… nazwy lub\n"
 " numeru (tzn. uid/gid/projid).\n"
 
 #: ../quota/quot.c:219
@@ -4632,7 +4632,7 @@ msgstr "[-bir] [-gpu] [-acv] [-f plik]"
 
 #: ../quota/quot.c:419
 msgid "summarize filesystem ownership"
-msgstr "podsumowanie w³asno¶ci systemu plików"
+msgstr "podsumowanie wÅ‚asnoÅ›ci systemu plikÃ³w"
 
 #: ../quota/quota.c:32
 #, c-format
@@ -4656,20 +4656,20 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" wy¶wietlenie informacji o wykorzystaniu miejsca i limitach\n"
-"\n"
-" -g - wy¶wietlenie informacji o limitach grup\n"
-" -p - wy¶wietlenie informacji o limitach projektów\n"
-" -u - wy¶wietlenie informacji o limitach u¿ytkowników\n"
-" -b - wy¶wietlenie liczby wykorzystanych bloków\n"
-" -i - wy¶wietlenie liczby wykorzystanych i-wêz³ów\n"
-" -r - wy¶wietlenie liczby wykorzystanych bloków realtime\n"
-" -h - u¿ycie formatu czytelnego dla cz³owieka\n"
-" -n - pominiêcie t³umaczenia identyfikatorów na nazwy, wypisywanie ID\n"
-" -N - pominiêcie pocz±tkowego nag³ówka\n"
-" -v - zwiêkszenie szczegó³owo¶ci (wypisywanie tak¿e warto¶ci zerowych)\n"
-" -f - zapisanie wyj¶cia do pliku\n"
-" (opcjonalny) u¿ytkownik/grupa/projekt mo¿e byæ podany za pomoc± nazwy lub\n"
+" wyÅ›wietlenie informacji o wykorzystaniu miejsca i limitach\n"
+"\n"
+" -g - wyÅ›wietlenie informacji o limitach grup\n"
+" -p - wyÅ›wietlenie informacji o limitach projektÃ³w\n"
+" -u - wyÅ›wietlenie informacji o limitach uÅ¼ytkownikÃ³w\n"
+" -b - wyÅ›wietlenie liczby wykorzystanych blokÃ³w\n"
+" -i - wyÅ›wietlenie liczby wykorzystanych i-wÄ™zÅ‚Ã³w\n"
+" -r - wyÅ›wietlenie liczby wykorzystanych blokÃ³w realtime\n"
+" -h - uÅ¼ycie formatu czytelnego dla czÅ‚owieka\n"
+" -n - pominiÄ™cie tÅ‚umaczenia identyfikatorÃ³w na nazwy, wypisywanie ID\n"
+" -N - pominiÄ™cie poczÄ…tkowego nagÅ‚Ã³wka\n"
+" -v - zwiÄ™kszenie szczegÃ³Å‚owoÅ›ci (wypisywanie takÅ¼e wartoÅ›ci zerowych)\n"
+" -f - zapisanie wyjÅ›cia do pliku\n"
+" (opcjonalny) uÅ¼ytkownik/grupa/projekt moÅ¼e byÄ‡ podany za pomocÄ… nazwy lub\n"
 " numeru (tzn. uid/gid/projid).\n"
 
 #: ../quota/quota.c:85
@@ -4679,7 +4679,7 @@ msgid ""
 "Filesystem%s"
 msgstr ""
 "Limity dyskowe (quota) dla %s %s (%u)\n"
-"System plików%s"
+"System plikÃ³w%s"
 
 #: ../quota/quota.c:90
 #, c-format
@@ -4714,22 +4714,22 @@ msgstr "   Realtime      Quota      Limit  Czas ostrz.    "
 #: ../quota/quota.c:235
 #, c-format
 msgid "%s: cannot find user %s\n"
-msgstr "%s: nie mo¿na odnale¼æ u¿ytkownika %s\n"
+msgstr "%s: nie moÅ¼na odnaleÅºÄ‡ uÅ¼ytkownika %s\n"
 
 #: ../quota/quota.c:285
 #, c-format
 msgid "%s: cannot find group %s\n"
-msgstr "%s: nie mo¿na odnale¼æ grupy %s\n"
+msgstr "%s: nie moÅ¼na odnaleÅºÄ‡ grupy %s\n"
 
 #: ../quota/quota.c:342
 #, c-format
 msgid "%s: must specify a project name/ID\n"
-msgstr "%s: nale¿y podaæ nazwê/ID projektu\n"
+msgstr "%s: naleÅ¼y podaÄ‡ nazwÄ™/ID projektu\n"
 
 #: ../quota/quota.c:355
 #, c-format
 msgid "%s: cannot find project %s\n"
-msgstr "%s: nie mo¿na odnale¼æ projektu %s\n"
+msgstr "%s: nie moÅ¼na odnaleÅºÄ‡ projektu %s\n"
 
 #: ../quota/quota.c:455
 msgid "quota"
@@ -4745,11 +4745,11 @@ msgstr "[-bir] [-gpu] [-hnNv] [-f plik] [id|nazwa]..."
 
 #: ../quota/quota.c:461
 msgid "show usage and limits"
-msgstr "pokazanie wykorzystania i limitów"
+msgstr "pokazanie wykorzystania i limitÃ³w"
 
 #: ../quota/report.c:34 ../quota/report.c:648
 msgid "dump quota information for backup utilities"
-msgstr "zrzucenie informacji o limitach (quota) dla narzêdzi backupowych"
+msgstr "zrzucenie informacji o limitach (quota) dla narzÄ™dzi backupowych"
 
 #: ../quota/report.c:36
 #, c-format
@@ -4763,10 +4763,10 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" utworzenie pliku kopii zapasowej zawieraj±cego informacje o limitach (quota)\n"
-" -g - zrzucenie limitów dla grup\n"
-" -p - zrzucenie limitów dla projektów\n"
-" -u - zrzucenie limitów dla u¿ytkowników (domy¶lne)\n"
+" utworzenie pliku kopii zapasowej zawierajÄ…cego informacje o limitach (quota)\n"
+" -g - zrzucenie limitÃ³w dla grup\n"
+" -p - zrzucenie limitÃ³w dla projektÃ³w\n"
+" -u - zrzucenie limitÃ³w dla uÅ¼ytkownikÃ³w (domyÅ›lne)\n"
 " -f - zapisanie zrzutu do podanego pliku\n"
 "\n"
 
@@ -4776,7 +4776,7 @@ msgstr "[-bir] [-gpu] [-ahntLNU] [-f plik]"
 
 #: ../quota/report.c:49 ../quota/report.c:657
 msgid "report filesystem quota information"
-msgstr "raportowanie informacji o limitach (quota) w systemie plików"
+msgstr "raportowanie informacji o limitach (quota) w systemie plikÃ³w"
 
 #: ../quota/report.c:51
 #, c-format
@@ -4805,28 +4805,28 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" informacje o wykorzystanym miejscu i i-wêz³ach, i limitach quota dla systemu\n"
-" plików\n"
+" informacje o wykorzystanym miejscu i i-wÄ™zÅ‚ach, i limitach quota dla systemu\n"
+" plikÃ³w\n"
 "\n"
-" Przyk³ad:\n"
+" PrzykÅ‚ad:\n"
 " 'report -igh'\n"
-" (raport o wykorzystaniu i-wêz³ów dla wszystkich grup w czytelnym formacie)\n"
-"\n"
-" To polecenie jest odpowiednikiem tradycyjnego polecenia repquota, wypisuj±cego\n"
-" podsumowanie wykorzystania dysku i limitów dla bie¿±cego systemu plików lub\n"
-" wszystkich systemów plików.\n"
-" -a - informacje o wszystkich podmontowanych systemach plików z limitami\n"
-" -h - informacje w formacie czytelnym dla cz³owieka\n"
-" -n - pominiêcie t³umaczenia identyfikatorów na nazwy, wypisywanie ID\n"
-" -N - pominiêcie pocz±tkowego nag³ówka\n"
-" -t - zwiêz³y format, ukrycie wierszy zerowych\n"
+" (raport o wykorzystaniu i-wÄ™zÅ‚Ã³w dla wszystkich grup w czytelnym formacie)\n"
+"\n"
+" To polecenie jest odpowiednikiem tradycyjnego polecenia repquota, wypisujÄ…cego\n"
+" podsumowanie wykorzystania dysku i limitÃ³w dla bieÅ¼Ä…cego systemu plikÃ³w lub\n"
+" wszystkich systemÃ³w plikÃ³w.\n"
+" -a - informacje o wszystkich podmontowanych systemach plikÃ³w z limitami\n"
+" -h - informacje w formacie czytelnym dla czÅ‚owieka\n"
+" -n - pominiÄ™cie tÅ‚umaczenia identyfikatorÃ³w na nazwy, wypisywanie ID\n"
+" -N - pominiÄ™cie poczÄ…tkowego nagÅ‚Ã³wka\n"
+" -t - zwiÄ™zÅ‚y format, ukrycie wierszy zerowych\n"
 " -L - dolna granica dla wypisywanych informacji\n"
-" -U - górna granica dla wypisywanych informacji\n"
+" -U - gÃ³rna granica dla wypisywanych informacji\n"
 " -g - informacje o wykorzystanym miejscu i limitach dla grup\n"
-" -p - informacje o wykorzystanym miejscu i limitach dla projektów\n"
-" -u - informacje o wykorzystanym miejscu i limitach dla u¿ytkowników\n"
+" -p - informacje o wykorzystanym miejscu i limitach dla projektÃ³w\n"
+" -u - informacje o wykorzystanym miejscu i limitach dla uÅ¼ytkownikÃ³w\n"
 " -b - tylko informacje o wykorzystanych blokach\n"
-" -i - tylko informacje o wykorzystanych i-wêz³ach\n"
+" -i - tylko informacje o wykorzystanych i-wÄ™zÅ‚ach\n"
 " -r - tylko informacje o wykorzystanych blokach realtime\n"
 "\n"
 
@@ -4838,22 +4838,22 @@ msgstr "limit %s na %s (%s)\n"
 #: ../quota/report.c:253 ../quota/report.c:261
 #, c-format
 msgid "  Used   Soft   Hard Warn/Grace   "
-msgstr " U¿yto  Miêkki Twardy Ostrze¿enie "
+msgstr " UÅ¼yto  MiÄ™kki Twardy OstrzeÅ¼enie "
 
 #: ../quota/report.c:254 ../quota/report.c:262
 #, c-format
 msgid "      Used       Soft       Hard    Warn/Grace     "
-msgstr "     U¿yto      Miêkki     Twardy   Ostrze¿enie    "
+msgstr "     UÅ¼yto      MiÄ™kki     Twardy   OstrzeÅ¼enie    "
 
 #: ../quota/report.c:257
 #, c-format
 msgid "  Used   Soft   Hard Warn/Grace  "
-msgstr " U¿yto  Miêkki Twardy Ostrze¿enie"
+msgstr " UÅ¼yto  MiÄ™kki Twardy OstrzeÅ¼enie"
 
 #: ../quota/report.c:258
 #, c-format
 msgid "      Used       Soft       Hard    Warn/ Grace     "
-msgstr "     U¿yto      Miêkki     Twardy   Ostrze¿enie     "
+msgstr "     UÅ¼yto      MiÄ™kki     Twardy   OstrzeÅ¼enie     "
 
 #: ../quota/report.c:643
 msgid "dump"
@@ -4893,24 +4893,24 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" wy³±czenie podsystemu quota (zarówno rozliczania jak i wymuszania)\n"
+" wyÅ‚Ä…czenie podsystemu quota (zarÃ³wno rozliczania jak i wymuszania)\n"
 "\n"
-" Przyk³ad:\n"
-" 'off -uv'  (wy³±czenie limitów u¿ytkownika w bie¿±cym systemie plików)\n"
+" PrzykÅ‚ad:\n"
+" 'off -uv'  (wyÅ‚Ä…czenie limitÃ³w uÅ¼ytkownika w bieÅ¼Ä…cym systemie plikÃ³w)\n"
 "\n"
 " To polecenie jest odpowiednikiem tradycyjnego polecenia quotaoff,\n"
-" wy³±czaj±cego ca³kowicie limity na podmontowanym systemie plików.\n"
-" Nale¿y zauwa¿yæ, ¿e nie ma polecenia 'on' - dla systemów plików XFS\n"
-" (z wyj±tkiem g³ównego systemu plików pod systemem IRIX) limity mo¿na\n"
-" w³±czyæ wy³±cznie na etapie montowania, poprzez u¿ycie jednej z opcji\n"
+" wyÅ‚Ä…czajÄ…cego caÅ‚kowicie limity na podmontowanym systemie plikÃ³w.\n"
+" NaleÅ¼y zauwaÅ¼yÄ‡, Å¼e nie ma polecenia 'on' - dla systemÃ³w plikÃ³w XFS\n"
+" (z wyjÄ…tkiem gÅ‚Ã³wnego systemu plikÃ³w pod systemem IRIX) limity moÅ¼na\n"
+" wÅ‚Ä…czyÄ‡ wyÅ‚Ä…cznie na etapie montowania, poprzez uÅ¼ycie jednej z opcji\n"
 " quota programu mount.\n"
 "\n"
-" Polecenie state jest przydatne do wy¶wietlania aktualnego stanu. U¿ycie\n"
-" opcji -v (szczegó³owo¶æ) dla polecenia 'off' wy¶wietli stan quoty dla\n"
-" danego systemu plików po zakoñczeniu operacji.\n"
-" Rodzaj limitu którego dotyczy polecenie mo¿na wybraæ opcj± -g (grupy),\n"
-" -p (projekty) lub -u (u¿ytkownicy); domy¶lnie polecenie dotyczy limitów\n"
-" u¿ytkowników (mo¿na podaæ wiele rodzajów).\n"
+" Polecenie state jest przydatne do wyÅ›wietlania aktualnego stanu. UÅ¼ycie\n"
+" opcji -v (szczegÃ³Å‚owoÅ›Ä‡) dla polecenia 'off' wyÅ›wietli stan quoty dla\n"
+" danego systemu plikÃ³w po zakoÅ„czeniu operacji.\n"
+" Rodzaj limitu ktÃ³rego dotyczy polecenie moÅ¼na wybraÄ‡ opcjÄ… -g (grupy),\n"
+" -p (projekty) lub -u (uÅ¼ytkownicy); domyÅ›lnie polecenie dotyczy limitÃ³w\n"
+" uÅ¼ytkownikÃ³w (moÅ¼na podaÄ‡ wiele rodzajÃ³w).\n"
 "\n"
 
 #: ../quota/state.c:56
@@ -4928,14 +4928,14 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" odczytanie stanu podsystemu quota w bie¿±cym systemie plików\n"
+" odczytanie stanu podsystemu quota w bieÅ¼Ä…cym systemie plikÃ³w\n"
 "\n"
-" Jest to polecenie szczegó³owo informuj±ce o stanie, opisuj±ce czy w³±czone\n"
-" jest rozliczanie i/lub wymuszanie limitów w systemie plików, które i-wêz³y\n"
-" s± wykorzystywane jako i-wêz³y stanu quot oraz ile fragmentów i bloków jest\n"
-" aktualnie u¿ywana do przechowywania tych informacji.\n"
-" Rodzaj limitów podaje siê opcj± -g (grupy), -p (projekty) lub -u (u¿ytkownicy);\n"
-" domy¶lnie polecenie dotyczy limitów u¿ytkowników (mo¿na podaæ wiele rodzajów).\n"
+" Jest to polecenie szczegÃ³Å‚owo informujÄ…ce o stanie, opisujÄ…ce czy wÅ‚Ä…czone\n"
+" jest rozliczanie i/lub wymuszanie limitÃ³w w systemie plikÃ³w, ktÃ³re i-wÄ™zÅ‚y\n"
+" sÄ… wykorzystywane jako i-wÄ™zÅ‚y stanu quot oraz ile fragmentÃ³w i blokÃ³w jest\n"
+" aktualnie uÅ¼ywana do przechowywania tych informacji.\n"
+" Rodzaj limitÃ³w podaje siÄ™ opcjÄ… -g (grupy), -p (projekty) lub -u (uÅ¼ytkownicy);\n"
+" domyÅ›lnie polecenie dotyczy limitÃ³w uÅ¼ytkownikÃ³w (moÅ¼na podaÄ‡ wiele rodzajÃ³w).\n"
 "\n"
 
 #: ../quota/state.c:72
@@ -4953,14 +4953,14 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" w³±czenie wymuszania limitów w systemie plików\n"
+" wÅ‚Ä…czenie wymuszania limitÃ³w w systemie plikÃ³w\n"
 "\n"
-" Je¶li system plików jest podmontowany i ma w³±czone rozliczanie limitów,\n"
-" ale nie ma wymuszania limitów, mo¿na w³±czyæ wymuszanie tym poleceniem.\n"
-" Z opcj± -v (szczegó³owo¶æ) po zakoñczeniu operacji zostanie zraportowany\n"
-" stan systemu plików.\n"
-" Rodzaj limitów podaje siê opcj± -g (grupy), -p (projekty) lub -u (u¿ytkownicy);\n"
-" domy¶lnie polecenie dotyczy limitów u¿ytkowników (mo¿na podaæ wiele rodzajów).\n"
+" JeÅ›li system plikÃ³w jest podmontowany i ma wÅ‚Ä…czone rozliczanie limitÃ³w,\n"
+" ale nie ma wymuszania limitÃ³w, moÅ¼na wÅ‚Ä…czyÄ‡ wymuszanie tym poleceniem.\n"
+" Z opcjÄ… -v (szczegÃ³Å‚owoÅ›Ä‡) po zakoÅ„czeniu operacji zostanie zraportowany\n"
+" stan systemu plikÃ³w.\n"
+" Rodzaj limitÃ³w podaje siÄ™ opcjÄ… -g (grupy), -p (projekty) lub -u (uÅ¼ytkownicy);\n"
+" domyÅ›lnie polecenie dotyczy limitÃ³w uÅ¼ytkownikÃ³w (moÅ¼na podaÄ‡ wiele rodzajÃ³w).\n"
 "\n"
 
 #: ../quota/state.c:88
@@ -4976,12 +4976,12 @@ msgid ""
 "\n"
 msgstr ""
 "\n"
-" wy³±czenie wymuszania limitów w systemie plików\n"
+" wyÅ‚Ä…czenie wymuszania limitÃ³w w systemie plikÃ³w\n"
 "\n"
-" Je¶li system plików jest podmontowany i aktualnie wymusza przestrzeganie\n"
-" limitów, tym poleceniem mo¿na wy³±czyæ wymuszanie, ale nadal pozostawiæ\n"
-" rozliczanie wykorzystanego miejsca (oraz i-wêz³ów).\n"
-" Rodzaj limitów podaje siê opcj± -g (grupy), -p (projekty) lub -u (u¿ytkownicy).\n"
+" JeÅ›li system plikÃ³w jest podmontowany i aktualnie wymusza przestrzeganie\n"
+" limitÃ³w, tym poleceniem moÅ¼na wyÅ‚Ä…czyÄ‡ wymuszanie, ale nadal pozostawiÄ‡\n"
+" rozliczanie wykorzystanego miejsca (oraz i-wÄ™zÅ‚Ã³w).\n"
+" Rodzaj limitÃ³w podaje siÄ™ opcjÄ… -g (grupy), -p (projekty) lub -u (uÅ¼ytkownicy).\n"
 "\n"
 
 #: ../quota/state.c:102
@@ -4999,16 +4999,16 @@ msgstr ""
 "\n"
 " zwolnienie miejsca zajmowanego przez podsystem quota\n"
 "\n"
-" Po wy³±czeniu limitów dla systemu plików mo¿na tym poleceniem zwolniæ miejsce\n"
+" Po wyÅ‚Ä…czeniu limitÃ³w dla systemu plikÃ³w moÅ¼na tym poleceniem zwolniÄ‡ miejsce\n"
 " przydzielone na przechowywanie metadanych quot.\n"
-" Rodzaj limitów podaje siê opcj± -g (grupy), -p (projekty) lub -u (u¿ytkownicy);\n"
-" domy¶lnie polecenie dotyczy limitów u¿ytkowników (mo¿na podaæ wiele rodzajów).\n"
+" Rodzaj limitÃ³w podaje siÄ™ opcjÄ… -g (grupy), -p (projekty) lub -u (uÅ¼ytkownicy);\n"
+" domyÅ›lnie polecenie dotyczy limitÃ³w uÅ¼ytkownikÃ³w (moÅ¼na podaÄ‡ wiele rodzajÃ³w).\n"
 "\n"
 
 #: ../quota/state.c:121
 #, c-format
 msgid "%s quota state on %s (%s)\n"
-msgstr "stan limitów %s na %s (%s)\n"
+msgstr "stan limitÃ³w %s na %s (%s)\n"
 
 #: ../quota/state.c:123
 #, c-format
@@ -5017,11 +5017,11 @@ msgstr "  Rozliczanie: %s\n"
 
 #: ../quota/state.c:123 ../quota/state.c:124
 msgid "ON"
-msgstr "W£¡CZONE"
+msgstr "WÅÄ„CZONE"
 
 #: ../quota/state.c:123 ../quota/state.c:124
 msgid "OFF"
-msgstr "WY£¡CZONE"
+msgstr "WYÅÄ„CZONE"
 
 #: ../quota/state.c:124
 #, c-format
@@ -5031,17 +5031,17 @@ msgstr "  Wymuszanie: %s\n"
 #: ../quota/state.c:125
 #, c-format
 msgid "  Inode: #%llu (%llu blocks, %lu extents)\n"
-msgstr "  I-wêze³: #%llu (%llu bloków, %lu fragmentów)\n"
+msgstr "  I-wÄ™zeÅ‚: #%llu (%llu blokÃ³w, %lu fragmentÃ³w)\n"
 
 #: ../quota/state.c:137
 #, c-format
 msgid "%s grace time: %s\n"
-msgstr "czas pob³a¿liwo¶ci %s: %s\n"
+msgstr "czas pobÅ‚aÅ¼liwoÅ›ci %s: %s\n"
 
 #: ../quota/state.c:154
 #, c-format
 msgid "%s quota are not enabled on %s\n"
-msgstr "Limity %s nie s± w³±czone na %s\n"
+msgstr "Limity %s nie sÄ… wÅ‚Ä…czone na %s\n"
 
 #: ../quota/state.c:524 ../quota/state.c:540 ../quota/state.c:548
 #: ../quota/state.c:556
@@ -5050,7 +5050,7 @@ msgstr "[-gpu] [-v]"
 
 #: ../quota/state.c:525
 msgid "permanently switch quota off for a path"
-msgstr "wy³±czenie limitów na sta³e dla ¶cie¿ki"
+msgstr "wyÅ‚Ä…czenie limitÃ³w na staÅ‚e dla Å›cieÅ¼ki"
 
 #: ../quota/state.c:528
 msgid "state"
@@ -5062,7 +5062,7 @@ msgstr "[-gpu] [-a] [-v] [-f plik]"
 
 #: ../quota/state.c:533
 msgid "get overall quota state information"
-msgstr "uzyskanie ogólnych informacji o stanie quot"
+msgstr "uzyskanie ogÃ³lnych informacji o stanie quot"
 
 #: ../quota/state.c:536
 msgid "enable"
@@ -5070,7 +5070,7 @@ msgstr "enable"
 
 #: ../quota/state.c:541
 msgid "enable quota enforcement"
-msgstr "w³±czenie wymuszania limitów"
+msgstr "wÅ‚Ä…czenie wymuszania limitÃ³w"
 
 #: ../quota/state.c:544
 msgid "disable"
@@ -5078,7 +5078,7 @@ msgstr "disable"
 
 #: ../quota/state.c:549
 msgid "disable quota enforcement"
-msgstr "wy³±czenie wymuszania limitów"
+msgstr "wyÅ‚Ä…czenie wymuszania limitÃ³w"
 
 #: ../quota/state.c:552
 msgid "remove"
@@ -5086,7 +5086,7 @@ msgstr "remove"
 
 #: ../quota/state.c:557
 msgid "remove quota extents from a filesystem"
-msgstr "usuniêcie fragmentów zwi±zanych z limitami z systemu plików"
+msgstr "usuniÄ™cie fragmentÃ³w zwiÄ…zanych z limitami z systemu plikÃ³w"
 
 #: ../quota/util.c:59
 #, c-format
@@ -5111,7 +5111,7 @@ msgstr "[--------]"
 # XXX: ngettext()
 #: ../quota/util.c:66 ../quota/util.c:69
 msgid "day"
-msgstr "dzieñ"
+msgstr "dzieÅ„"
 
 #: ../quota/util.c:66 ../quota/util.c:69
 msgid "days"
@@ -5123,7 +5123,7 @@ msgstr "Bloki"
 
 #: ../quota/util.c:194
 msgid "Inodes"
-msgstr "I-wêz³y"
+msgstr "I-wÄ™zÅ‚y"
 
 #: ../quota/util.c:194
 msgid "Realtime Blocks"
@@ -5131,7 +5131,7 @@ msgstr "Bloki realtime"
 
 #: ../quota/util.c:209
 msgid "User"
-msgstr "u¿ytkowników"
+msgstr "uÅ¼ytkownikÃ³w"
 
 #: ../quota/util.c:209
 msgid "Group"
@@ -5139,86 +5139,86 @@ msgstr "grup"
 
 #: ../quota/util.c:209
 msgid "Project"
-msgstr "projektów"
+msgstr "projektÃ³w"
 
 #: ../quota/util.c:417
 #, c-format
 msgid "%s: open on %s failed: %s\n"
-msgstr "%s: open dla %s nie powiod³o siê: %s\n"
+msgstr "%s: open dla %s nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../quota/util.c:423
 #, c-format
 msgid "%s: fdopen on %s failed: %s\n"
-msgstr "%s: fdopen dla %s nie powiod³o siê: %s\n"
+msgstr "%s: fdopen dla %s nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../repair/agheader.c:35
 #, c-format
 msgid "bad magic # 0x%x for agf %d\n"
-msgstr "b³êdna liczba magiczna 0x%x dla agf %d\n"
+msgstr "bÅ‚Ä™dna liczba magiczna 0x%x dla agf %d\n"
 
 #: ../repair/agheader.c:44
 #, c-format
 msgid "bad version # %d for agf %d\n"
-msgstr "b³êdny numer wersji %d dla agf %d\n"
+msgstr "bÅ‚Ä™dny numer wersji %d dla agf %d\n"
 
 #: ../repair/agheader.c:53
 #, c-format
 msgid "bad sequence # %d for agf %d\n"
-msgstr "b³êdny numer sekwencji %d dla agf %d\n"
+msgstr "bÅ‚Ä™dny numer sekwencji %d dla agf %d\n"
 
 #: ../repair/agheader.c:63
 #, c-format
 msgid "bad length %d for agf %d, should be %d\n"
-msgstr "b³êdna d³ugo¶æ %d dla agf %d, powinno byæ %d\n"
+msgstr "bÅ‚Ä™dna dÅ‚ugoÅ›Ä‡ %d dla agf %d, powinno byÄ‡ %d\n"
 
 #: ../repair/agheader.c:76
 #, c-format
 msgid "bad length %d for agf %d, should be %llu\n"
-msgstr "b³êdna d³ugo¶æ %d dla agf %d, powinno byæ %llu\n"
+msgstr "bÅ‚Ä™dna dÅ‚ugoÅ›Ä‡ %d dla agf %d, powinno byÄ‡ %llu\n"
 
 #: ../repair/agheader.c:90
 #, c-format
 msgid "flfirst %d in agf %d too large (max = %d)\n"
-msgstr "flfirst %d w agf %d zbyt du¿e (maksimum = %d)\n"
+msgstr "flfirst %d w agf %d zbyt duÅ¼e (maksimum = %d)\n"
 
 #: ../repair/agheader.c:97
 #, c-format
 msgid "fllast %d in agf %d too large (max = %d)\n"
-msgstr "fllast %d w agf %d zbyt du¿e (maksimum = %d)\n"
+msgstr "fllast %d w agf %d zbyt duÅ¼e (maksimum = %d)\n"
 
 #: ../repair/agheader.c:118
 #, c-format
 msgid "bad magic # 0x%x for agi %d\n"
-msgstr "b³êdna liczba magiczna 0x%x dla agi %d\n"
+msgstr "bÅ‚Ä™dna liczba magiczna 0x%x dla agi %d\n"
 
 #: ../repair/agheader.c:127
 #, c-format
 msgid "bad version # %d for agi %d\n"
-msgstr "b³êdny numer wersji %d dla agi %d\n"
+msgstr "bÅ‚Ä™dny numer wersji %d dla agi %d\n"
 
 #: ../repair/agheader.c:136
 #, c-format
 msgid "bad sequence # %d for agi %d\n"
-msgstr "b³êdny numer sekwencji %d dla agi %d\n"
+msgstr "bÅ‚Ä™dny numer sekwencji %d dla agi %d\n"
 
 #: ../repair/agheader.c:146
 #, c-format
 msgid "bad length # %d for agi %d, should be %d\n"
-msgstr "b³êdna d³ugo¶æ %d dla agi %d, powinno byæ %d\n"
+msgstr "bÅ‚Ä™dna dÅ‚ugoÅ›Ä‡ %d dla agi %d, powinno byÄ‡ %d\n"
 
 #: ../repair/agheader.c:159
 #, c-format
 msgid "bad length # %d for agi %d, should be %llu\n"
-msgstr "b³êdna d³ugo¶æ %d dla agi %d, powinno byæ %llu\n"
+msgstr "bÅ‚Ä™dna dÅ‚ugoÅ›Ä‡ %d dla agi %d, powinno byÄ‡ %llu\n"
 
 #: ../repair/agheader.c:270
 #, c-format
 msgid "zeroing unused portion of %s superblock (AG #%u)\n"
-msgstr "zerowanie nieu¿ywanej czê¶ci superbloku %s (AG #%u)\n"
+msgstr "zerowanie nieuÅ¼ywanej czÄ™Å›ci superbloku %s (AG #%u)\n"
 
 #: ../repair/agheader.c:271 ../repair/agheader.c:277
 msgid "primary"
-msgstr "g³ównego"
+msgstr "gÅ‚Ã³wnego"
 
 #: ../repair/agheader.c:271 ../repair/agheader.c:277
 msgid "secondary"
@@ -5227,389 +5227,389 @@ msgstr "zapasowego"
 #: ../repair/agheader.c:276
 #, c-format
 msgid "would zero unused portion of %s superblock (AG #%u)\n"
-msgstr "nieu¿ywana czê¶æ superbloku %s (AG #%u) zosta³aby wyzerowana\n"
+msgstr "nieuÅ¼ywana czÄ™Å›Ä‡ superbloku %s (AG #%u) zostaÅ‚aby wyzerowana\n"
 
 #: ../repair/agheader.c:295
 #, c-format
 msgid "bad flags field in superblock %d\n"
-msgstr "b³êdne pole flag w superbloku %d\n"
+msgstr "bÅ‚Ä™dne pole flag w superbloku %d\n"
 
 #: ../repair/agheader.c:312
 #, c-format
 msgid "non-null user quota inode field in superblock %d\n"
-msgstr "niezerowe pole i-wêz³a limitów u¿ytkowników w superbloku %d\n"
+msgstr "niezerowe pole i-wÄ™zÅ‚a limitÃ³w uÅ¼ytkownikÃ³w w superbloku %d\n"
 
 #: ../repair/agheader.c:325
 #, c-format
 msgid "non-null group quota inode field in superblock %d\n"
-msgstr "niezerowe pole i-wêz³a limitów grup w superbloku %d\n"
+msgstr "niezerowe pole i-wÄ™zÅ‚a limitÃ³w grup w superbloku %d\n"
 
 #: ../repair/agheader.c:337
 #, c-format
 msgid "non-null quota flags in superblock %d\n"
-msgstr "niezerowe flagi limitów w superbloku %d\n"
+msgstr "niezerowe flagi limitÃ³w w superbloku %d\n"
 
 #: ../repair/agheader.c:355
 #, c-format
 msgid "bad shared version number in superblock %d\n"
-msgstr "b³êdny numer wersji dzielonej w superbloku %d\n"
+msgstr "bÅ‚Ä™dny numer wersji dzielonej w superbloku %d\n"
 
 #: ../repair/agheader.c:367
 #, c-format
 msgid "bad inode alignment field in superblock %d\n"
-msgstr "b³êdne pole wyrównania i-wêz³ów w superbloku %d\n"
+msgstr "bÅ‚Ä™dne pole wyrÃ³wnania i-wÄ™zÅ‚Ã³w w superbloku %d\n"
 
 #: ../repair/agheader.c:380
 #, c-format
 msgid "bad stripe unit/width fields in superblock %d\n"
-msgstr "b³êdne pola jednostki/szeroko¶ci pasa w superbloku %d\n"
+msgstr "bÅ‚Ä™dne pola jednostki/szerokoÅ›ci pasa w superbloku %d\n"
 
 #: ../repair/agheader.c:398
 #, c-format
 msgid "bad log/data device sector size fields in superblock %d\n"
-msgstr "b³êdne pola rozmiaru sektora urz±dzenia logu/danych w superbloku %d\n"
+msgstr "bÅ‚Ä™dne pola rozmiaru sektora urzÄ…dzenia logu/danych w superbloku %d\n"
 
 #: ../repair/agheader.c:429
 #, c-format
 msgid "bad on-disk superblock %d - %s\n"
-msgstr "b³êdny superblok %d na dysku - %s\n"
+msgstr "bÅ‚Ä™dny superblok %d na dysku - %s\n"
 
 #: ../repair/agheader.c:436
 #, c-format
 msgid "primary/secondary superblock %d conflict - %s\n"
-msgstr "konflikt g³ównego/zapasowego superbloku %d - %s\n"
+msgstr "konflikt gÅ‚Ã³wnego/zapasowego superbloku %d - %s\n"
 
 #: ../repair/attr_repair.c:106
 msgid "entry contains illegal value in attribute named SGI_ACL_FILE or SGI_ACL_DEFAULT\n"
-msgstr "wpis zawiera niedozwolon± warto¶æ w atrybucie SGI_ACL_FILE lub SGI_ACL_DEFAULT\n"
+msgstr "wpis zawiera niedozwolonÄ… wartoÅ›Ä‡ w atrybucie SGI_ACL_FILE lub SGI_ACL_DEFAULT\n"
 
 #: ../repair/attr_repair.c:128
 msgid "entry contains illegal value in attribute named SGI_MAC_LABEL\n"
-msgstr "wpis zawiera niedozwolon± warto¶æ w atrybucie SGI_MAC_LABEL\n"
+msgstr "wpis zawiera niedozwolonÄ… wartoÅ›Ä‡ w atrybucie SGI_MAC_LABEL\n"
 
 #: ../repair/attr_repair.c:134
 msgid "entry contains illegal value in attribute named SGI_CAP_FILE\n"
-msgstr "wpis zawiera niedozwolon± warto¶æ w atrybucie SGI_CAP_FILE\n"
+msgstr "wpis zawiera niedozwolonÄ… wartoÅ›Ä‡ w atrybucie SGI_CAP_FILE\n"
 
 #: ../repair/attr_repair.c:173
 #, c-format
 msgid "there are no attributes in the fork for inode %llu\n"
-msgstr "nie ma atrybutów w ga³êzi dla i-wêz³a %llu\n"
+msgstr "nie ma atrybutÃ³w w gaÅ‚Ä™zi dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:181
 #, c-format
 msgid "would junk the attribute fork since count is 0 for inode %llu\n"
-msgstr "ga³±¼ atrybutów zosta³aby usuniêta poniewa¿ licznik wynosi 0 dla i-wêz³a %llu\n"
+msgstr "gaÅ‚Ä…Åº atrybutÃ³w zostaÅ‚aby usuniÄ™ta poniewaÅ¼ licznik wynosi 0 dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:201
 msgid "zero length name entry in attribute fork,"
-msgstr "wpis nazwy zerowej d³ugo¶ci w ga³êzi atrybutów,"
+msgstr "wpis nazwy zerowej dÅ‚ugoÅ›ci w gaÅ‚Ä™zi atrybutÃ³w,"
 
 #: ../repair/attr_repair.c:204 ../repair/attr_repair.c:224
 #, c-format
 msgid " truncating attributes for inode %llu to %d\n"
-msgstr " uciêto atrybuty dla i-wêz³a %llu do %d\n"
+msgstr " uciÄ™to atrybuty dla i-wÄ™zÅ‚a %llu do %d\n"
 
 #: ../repair/attr_repair.c:209 ../repair/attr_repair.c:230
 #, c-format
 msgid " would truncate attributes for inode %llu to %d\n"
-msgstr " atrybuty dla i-wêz³a %llu zosta³yby uciête do %d\n"
+msgstr " atrybuty dla i-wÄ™zÅ‚a %llu zostaÅ‚yby uciÄ™te do %d\n"
 
 #: ../repair/attr_repair.c:221
 msgid "name or value attribute lengths are too large,\n"
-msgstr "d³ugo¶ci nazwy lub warto¶ci atrybutów s± zbyt du¿e,\n"
+msgstr "dÅ‚ugoÅ›ci nazwy lub wartoÅ›ci atrybutÃ³w sÄ… zbyt duÅ¼e,\n"
 
 #: ../repair/attr_repair.c:243
 msgid "entry contains illegal character in shortform attribute name\n"
-msgstr "wpis zawiera niedozwolony znak w nazwie atrybutu krótkiego\n"
+msgstr "wpis zawiera niedozwolony znak w nazwie atrybutu krÃ³tkiego\n"
 
 #: ../repair/attr_repair.c:249
 msgid "entry has INCOMPLETE flag on in shortform attribute\n"
-msgstr "wpis ma flagê NIEPE£NY w atrybucie krótkim\n"
+msgstr "wpis ma flagÄ™ NIEPEÅNY w atrybucie krÃ³tkim\n"
 
 #: ../repair/attr_repair.c:266
 #, c-format
 msgid "removing attribute entry %d for inode %llu\n"
-msgstr "usuniêto wpis atrybutu %d dla i-wêz³a %llu\n"
+msgstr "usuniÄ™to wpis atrybutu %d dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:278
 #, c-format
 msgid "would remove attribute entry %d for inode %llu\n"
-msgstr "wpis atrybutu %d dla i-wêz³a %llu zosta³by usuniêty\n"
+msgstr "wpis atrybutu %d dla i-wÄ™zÅ‚a %llu zostaÅ‚by usuniÄ™ty\n"
 
 #: ../repair/attr_repair.c:292
 #, c-format
 msgid "would have corrected attribute entry count in inode %llu from %d to %d\n"
-msgstr "liczba wpisów atrybutów w i-wê¼le %llu zosta³aby poprawiona z %d na %d\n"
+msgstr "liczba wpisÃ³w atrybutÃ³w w i-wÄ™Åºle %llu zostaÅ‚aby poprawiona z %d na %d\n"
 
 #: ../repair/attr_repair.c:296
 #, c-format
 msgid "corrected attribute entry count in inode %llu, was %d, now %d\n"
-msgstr "poprawiono liczbê wpisów atrybutów w i-wê¼le %llu - by³o %d, jest %d\n"
+msgstr "poprawiono liczbÄ™ wpisÃ³w atrybutÃ³w w i-wÄ™Åºle %llu - byÅ‚o %d, jest %d\n"
 
 #: ../repair/attr_repair.c:307
 #, c-format
 msgid "would have corrected attribute totsize in inode %llu from %d to %d\n"
-msgstr "totsize atrybutów w i-wê¼le %llu zosta³by poprawiony z %d na %d\n"
+msgstr "totsize atrybutÃ³w w i-wÄ™Åºle %llu zostaÅ‚by poprawiony z %d na %d\n"
 
 #: ../repair/attr_repair.c:312
 #, c-format
 msgid "corrected attribute entry totsize in inode %llu, was %d, now %d\n"
-msgstr "poprawiono totsize wpisu atrybutów w i-wê¼le %llu - by³o %d, jest %d\n"
+msgstr "poprawiono totsize wpisu atrybutÃ³w w i-wÄ™Åºle %llu - byÅ‚o %d, jest %d\n"
 
 #: ../repair/attr_repair.c:342
 #, c-format
 msgid "remote block for attributes of inode %llu is missing\n"
-msgstr "brak odleg³ego bloku dla atrybutów i-wêz³a %llu\n"
+msgstr "brak odlegÅ‚ego bloku dla atrybutÃ³w i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:350
 #, c-format
 msgid "can't read remote block for attributes of inode %llu\n"
-msgstr "nie mo¿na odczytaæ odleg³ego bloku dla atrybutów i-wêz³a %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ odlegÅ‚ego bloku dla atrybutÃ³w i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:394
 #, c-format
 msgid "attribute entry %d in attr block %u, inode %llu has bad name (namelen = %d)\n"
-msgstr "wpis atrybutu %d w bloku atrybutów %u, i-wê¼le %llu ma b³êdn± nazwê (namelen = %d)\n"
+msgstr "wpis atrybutu %d w bloku atrybutÃ³w %u, i-wÄ™Åºle %llu ma bÅ‚Ä™dnÄ… nazwÄ™ (namelen = %d)\n"
 
 #: ../repair/attr_repair.c:411
 #, c-format
 msgid "bad hashvalue for attribute entry %d in attr block %u, inode %llu\n"
-msgstr "b³êdna warto¶æ hasza dla wpisu atrybutu %d w bloku atrybutów %u, i-wê¼le %llu\n"
+msgstr "bÅ‚Ä™dna wartoÅ›Ä‡ hasza dla wpisu atrybutu %d w bloku atrybutÃ³w %u, i-wÄ™Åºle %llu\n"
 
 #: ../repair/attr_repair.c:420
 #, c-format
 msgid "bad security value for attribute entry %d in attr block %u, inode %llu\n"
-msgstr "b³êdna warto¶æ bezpieczeñstwa dla wpisu atrybutu %d w bloku atrybutów %u, i-wê¼le %llu\n"
+msgstr "bÅ‚Ä™dna wartoÅ›Ä‡ bezpieczeÅ„stwa dla wpisu atrybutu %d w bloku atrybutÃ³w %u, i-wÄ™Åºle %llu\n"
 
 #: ../repair/attr_repair.c:453
 #, c-format
 msgid "inconsistent remote attribute entry %d in attr block %u, ino %llu\n"
-msgstr "niespójny wpis odleg³ego atrybutu %d w bloku atrybutów %u, i-wê¼le %llu\n"
+msgstr "niespÃ³jny wpis odlegÅ‚ego atrybutu %d w bloku atrybutÃ³w %u, i-wÄ™Åºle %llu\n"
 
 #: ../repair/attr_repair.c:463
 #, c-format
 msgid "cannot malloc enough for remotevalue attribute for inode %llu\n"
-msgstr "nie mo¿na przydzieliæ wystarczaj±co du¿o dla atrybutu remotevalue dla i-wêz³a %llu\n"
+msgstr "nie moÅ¼na przydzieliÄ‡ wystarczajÄ…co duÅ¼o dla atrybutu remotevalue dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:465
 msgid "SKIPPING this remote attribute\n"
-msgstr "POMINIÊTO ten atrybut odleg³y\n"
+msgstr "POMINIÄ˜TO ten atrybut odlegÅ‚y\n"
 
 #: ../repair/attr_repair.c:470
 #, c-format
 msgid "remote attribute get failed for entry %d, inode %llu\n"
-msgstr "pobranie odleg³ego atrybutu nie powiod³o siê dla wpisu %d, i-wêz³a %llu\n"
+msgstr "pobranie odlegÅ‚ego atrybutu nie powiodÅ‚o siÄ™ dla wpisu %d, i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:476
 #, c-format
 msgid "remote attribute value check failed for entry %d, inode %llu\n"
-msgstr "sprawdzenie warto¶ci odleg³ego atrybutu nie powiod³o siê dla wpisu %d, i-wêz³a %llu\n"
+msgstr "sprawdzenie wartoÅ›ci odlegÅ‚ego atrybutu nie powiodÅ‚o siÄ™ dla wpisu %d, i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:513
 #, c-format
 msgid "bad attribute count %d in attr block %u, inode %llu\n"
-msgstr "b³êdna liczba atrybutów %d w bloku atrybutów %u, i-wê¼le %llu\n"
+msgstr "bÅ‚Ä™dna liczba atrybutÃ³w %d w bloku atrybutÃ³w %u, i-wÄ™Åºle %llu\n"
 
 #: ../repair/attr_repair.c:528
 #, c-format
 msgid "bad attribute nameidx %d in attr block %u, inode %llu\n"
-msgstr "b³êdny nameidx atrybutu %d w bloku atrybutów %u, i-wê¼le %llu\n"
+msgstr "bÅ‚Ä™dny nameidx atrybutu %d w bloku atrybutÃ³w %u, i-wÄ™Åºle %llu\n"
 
 #: ../repair/attr_repair.c:537
 #, c-format
 msgid "attribute entry #%d in attr block %u, inode %llu is INCOMPLETE\n"
-msgstr "wpis atrybutu #%d w bloku atrybutów %u, i-wê¼le %llu jest NIEPE£NY\n"
+msgstr "wpis atrybutu #%d w bloku atrybutÃ³w %u, i-wÄ™Åºle %llu jest NIEPEÅNY\n"
 
 #: ../repair/attr_repair.c:548
 #, c-format
 msgid "attribute entry %d in attr block %u, inode %llu claims already used space\n"
-msgstr "wpis atrybutu %d w bloku atrybutów %u, i-wê¼le %llu odwo³uje siê do ju¿ u¿ytego miejsca\n"
+msgstr "wpis atrybutu %d w bloku atrybutÃ³w %u, i-wÄ™Åºle %llu odwoÅ‚uje siÄ™ do juÅ¼ uÅ¼ytego miejsca\n"
 
 #: ../repair/attr_repair.c:571
 #, c-format
 msgid "attribute entry %d in attr block %u, inode %llu claims used space\n"
-msgstr "wpis atrybutu %d w bloku atrybutów %u, i-wê¼le %llu odwo³uje siê do u¿ywanego miejsca\n"
+msgstr "wpis atrybutu %d w bloku atrybutÃ³w %u, i-wÄ™Åºle %llu odwoÅ‚uje siÄ™ do uÅ¼ywanego miejsca\n"
 
 #: ../repair/attr_repair.c:596
 #, c-format
 msgid "- resetting first used heap value from %d to %d in block %u of attribute fork of inode %llu\n"
-msgstr "- przestawiono pierwsz± u¿ywan± warto¶æ sterty z %d na %d w bloku %u ga³êzi atrybutów i-wêz³a %llu\n"
+msgstr "- przestawiono pierwszÄ… uÅ¼ywanÄ… wartoÅ›Ä‡ sterty z %d na %d w bloku %u gaÅ‚Ä™zi atrybutÃ³w i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:604
 #, c-format
 msgid "- would reset first used value from %d to %d in block %u of attribute fork of inode %llu\n"
-msgstr "- pierwsza u¿ywana warto¶æ zosta³aby przestawiona z %d na %d w bloku %u ga³êzi atrybutów i-wêz³a %llu\n"
+msgstr "- pierwsza uÅ¼ywana wartoÅ›Ä‡ zostaÅ‚aby przestawiona z %d na %d w bloku %u gaÅ‚Ä™zi atrybutÃ³w i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:614
 #, c-format
 msgid "- resetting usedbytes cnt from %d to %d in block %u of attribute fork of inode %llu\n"
-msgstr "- przestawiono liczbê u¿ytych bajtów z %d na %d w bloku %u ga³êzi atrybutów i-wêz³a %llu\n"
+msgstr "- przestawiono liczbÄ™ uÅ¼ytych bajtÃ³w z %d na %d w bloku %u gaÅ‚Ä™zi atrybutÃ³w i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:622
 #, c-format
 msgid "- would reset usedbytes cnt from %d to %d in block %u of attribute fork of %llu\n"
-msgstr "- liczba u¿ytych bajtów zosta³aby przestawiona z %d na %d w bloku %u ga³êzi atrybutów i-wêz³a %llu\n"
+msgstr "- liczba uÅ¼ytych bajtÃ³w zostaÅ‚aby przestawiona z %d na %d w bloku %u gaÅ‚Ä™zi atrybutÃ³w i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:671
 #, c-format
 msgid "can't map block %u for attribute fork for inode %llu\n"
-msgstr "nie mo¿na odwzorowaæ bloku %u dla ga³êzi atrybutów dla i-wêz³a %llu\n"
+msgstr "nie moÅ¼na odwzorowaÄ‡ bloku %u dla gaÅ‚Ä™zi atrybutÃ³w dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:679
 #, c-format
 msgid "can't read file block %u (fsbno %llu) for attribute fork of inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku pliku %u (fsbno %llu) dla ga³êzi atrybutów i-wêz³a %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku pliku %u (fsbno %llu) dla gaÅ‚Ä™zi atrybutÃ³w i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:689
 #, c-format
 msgid "bad attribute leaf magic %#x for inode %llu\n"
-msgstr "b³êdna liczba magiczna li¶cia atrybutu %#x dla i-wêz³a %llu\n"
+msgstr "bÅ‚Ä™dna liczba magiczna liÅ›cia atrybutu %#x dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:720
 #, c-format
 msgid "bad sibling back pointer for block %u in attribute fork for inode %llu\n"
-msgstr "b³êdny wska¼nik wsteczny dla bloku %u w ga³êzi atrybutów dla i-wêz³a %llu\n"
+msgstr "bÅ‚Ä™dny wskaÅºnik wsteczny dla bloku %u w gaÅ‚Ä™zi atrybutÃ³w dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:747
 #, c-format
 msgid "bad hash path in attribute fork for inode %llu\n"
-msgstr "b³êdna ¶cie¿ka hasza w ga³êzi atrybutów dla i-wêz³a %llu\n"
+msgstr "bÅ‚Ä™dna Å›cieÅ¼ka hasza w gaÅ‚Ä™zi atrybutÃ³w dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/attr_repair.c:846
 #, c-format
 msgid "block 0 of inode %llu attribute fork is missing\n"
-msgstr "brak bloku 0 i-wêz³a %llu ga³êzi atrybutów\n"
+msgstr "brak bloku 0 i-wÄ™zÅ‚a %llu gaÅ‚Ä™zi atrybutÃ³w\n"
 
 #: ../repair/attr_repair.c:852
 #, c-format
 msgid "agno of attribute fork of inode %llu out of regular partition\n"
-msgstr "agno ga³êzi atrybutów i-wêz³a %llu spoza zwyk³ej partycji\n"
+msgstr "agno gaÅ‚Ä™zi atrybutÃ³w i-wÄ™zÅ‚a %llu spoza zwykÅ‚ej partycji\n"
 
 #: ../repair/attr_repair.c:860
 #, c-format
 msgid "can't read block 0 of inode %llu attribute fork\n"
-msgstr "nie mo¿na odczytaæ bloku 0 i-wêz³a %llu ga³êzi atrybutów\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku 0 i-wÄ™zÅ‚a %llu gaÅ‚Ä™zi atrybutÃ³w\n"
 
 #: ../repair/attr_repair.c:874
 #, c-format
 msgid "clearing forw/back pointers in block 0 for attributes in inode %llu\n"
-msgstr "wyczyszczono wska¼niki forw/back w bloku 0 dla atrybutów w i-wê¼le %llu\n"
+msgstr "wyczyszczono wskaÅºniki forw/back w bloku 0 dla atrybutÃ³w w i-wÄ™Åºle %llu\n"
 
 #: ../repair/attr_repair.c:880
 #, c-format
 msgid "would clear forw/back pointers in block 0 for attributes in inode %llu\n"
-msgstr "wska¼niki forw/back w bloku 0 dla atrybutów w i-wê¼le %llu zosta³yby wyczyszczone\n"
+msgstr "wskaÅºniki forw/back w bloku 0 dla atrybutÃ³w w i-wÄ™Åºle %llu zostaÅ‚yby wyczyszczone\n"
 
 #: ../repair/attr_repair.c:910
 #, c-format
 msgid "bad attribute leaf magic # %#x for dir ino %llu\n"
-msgstr "b³êdna liczba magiczna li¶cia atrybutu %#x dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dna liczba magiczna liÅ›cia atrybutu %#x dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/attr_repair.c:977 ../repair/dinode.c:2176
 #, c-format
 msgid "illegal attribute format %d, ino %llu\n"
-msgstr "niedozwolony format atrybutu %d, i-wêze³ %llu\n"
+msgstr "niedozwolony format atrybutu %d, i-wÄ™zeÅ‚ %llu\n"
 
 #: ../repair/attr_repair.c:1000
 msgid "cannot malloc enough for ACL attribute\n"
-msgstr "nie mo¿na wykonaæ wystarczaj±cego malloc dla atrybutu ACL\n"
+msgstr "nie moÅ¼na wykonaÄ‡ wystarczajÄ…cego malloc dla atrybutu ACL\n"
 
 #: ../repair/attr_repair.c:1001
 msgid "SKIPPING this ACL\n"
-msgstr "POMINIÊTO ten ACL\n"
+msgstr "POMINIÄ˜TO ten ACL\n"
 
 #: ../repair/avl.c:1011 ../repair/avl64.c:1032
 #, c-format
 msgid "avl_insert: Warning! duplicate range [%llu,%llu]\n"
-msgstr "avl_insert: Uwaga! powtórzony przedzia³ [%llu,%llu]\n"
+msgstr "avl_insert: Uwaga! powtÃ³rzony przedziaÅ‚ [%llu,%llu]\n"
 
 #: ../repair/bmap.c:43
 #, c-format
 msgid "realloc failed in blkent_append (%u bytes)\n"
-msgstr "realloc nie powiod³o siê w blkent_append (%u bajtów)\n"
+msgstr "realloc nie powiodÅ‚o siÄ™ w blkent_append (%u bajtÃ³w)\n"
 
 #: ../repair/bmap.c:65
 #, c-format
 msgid "malloc failed in blkent_new (%u bytes)\n"
-msgstr "malloc nie powiod³o siê w blkend_new (%u bajtów)\n"
+msgstr "malloc nie powiodÅ‚o siÄ™ w blkend_new (%u bajtÃ³w)\n"
 
 #: ../repair/bmap.c:91
 #, c-format
 msgid "malloc failed in blkent_prepend (%u bytes)\n"
-msgstr "malloc nie powiod³o siê w blkent_prepend (%u bajtów)\n"
+msgstr "malloc nie powiodÅ‚o siÄ™ w blkent_prepend (%u bajtÃ³w)\n"
 
 #: ../repair/bmap.c:118
 #, c-format
 msgid "malloc failed in blkmap_alloc (%u bytes)\n"
-msgstr "malloc nie powiod³o siê w blkmap_alloc (%u bajtów)\n"
+msgstr "malloc nie powiodÅ‚o siÄ™ w blkmap_alloc (%u bajtÃ³w)\n"
 
 #: ../repair/bmap.c:216
 #, c-format
 msgid "blkmap_getn realloc failed (%u bytes)\n"
-msgstr "realloc w blkmap_getn nie powiod³o siê (%u bajtów)\n"
+msgstr "realloc w blkmap_getn nie powiodÅ‚o siÄ™ (%u bajtÃ³w)\n"
 
 #: ../repair/bmap.c:252
 #, c-format
 msgid "realloc failed in blkmap_grow (%u bytes)\n"
-msgstr "realloc nie powiod³o siê w blkmap_grow (%u bajtów)\n"
+msgstr "realloc nie powiodÅ‚o siÄ™ w blkmap_grow (%u bajtÃ³w)\n"
 
 #: ../repair/dino_chunks.c:59
 #, c-format
 msgid "cannot read agbno (%u/%u), disk block %lld\n"
-msgstr "nie mo¿na odczytaæ agbno (%u/%u), blok dysku %lld\n"
+msgstr "nie moÅ¼na odczytaÄ‡ agbno (%u/%u), blok dysku %lld\n"
 
 #: ../repair/dino_chunks.c:157
 #, c-format
 msgid "uncertain inode block %d/%d already known\n"
-msgstr "niepewny blok i-wêz³a %d/%d ju¿ znany\n"
+msgstr "niepewny blok i-wÄ™zÅ‚a %d/%d juÅ¼ znany\n"
 
 #: ../repair/dino_chunks.c:173 ../repair/dino_chunks.c:443
 #: ../repair/dino_chunks.c:505
 #, c-format
 msgid "inode block %d/%d multiply claimed, (state %d)\n"
-msgstr "blok i-wêz³a %d/%d ju¿ przypisany (stan %d)\n"
+msgstr "blok i-wÄ™zÅ‚a %d/%d juÅ¼ przypisany (stan %d)\n"
 
 #: ../repair/dino_chunks.c:180 ../repair/dino_chunks.c:510
 #, c-format
 msgid "inode block %d/%d bad state, (state %d)\n"
-msgstr "blok i-wêz³a (%d/%d) w b³êdnym stanie (stan %d)\n"
+msgstr "blok i-wÄ™zÅ‚a (%d/%d) w bÅ‚Ä™dnym stanie (stan %d)\n"
 
 #: ../repair/dino_chunks.c:450
 #, c-format
 msgid "uncertain inode block overlap, agbno = %d, ino = %llu\n"
-msgstr "niepewny blok i-wêz³a pokrywa siê, agbno = %d, i-wêze³ %llu\n"
+msgstr "niepewny blok i-wÄ™zÅ‚a pokrywa siÄ™, agbno = %d, i-wÄ™zeÅ‚ %llu\n"
 
 #: ../repair/dino_chunks.c:492
 #, c-format
 msgid "uncertain inode block %llu already known\n"
-msgstr "niepewny blok i-wêz³a %llu ju¿ znany\n"
+msgstr "niepewny blok i-wÄ™zÅ‚a %llu juÅ¼ znany\n"
 
 #: ../repair/dino_chunks.c:628
 #, c-format
 msgid "failed to allocate %d bytes of memory\n"
-msgstr "nie uda³o siê przydzieliæ %d bajtów pamiêci\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ %d bajtÃ³w pamiÄ™ci\n"
 
 #: ../repair/dino_chunks.c:640
 #, c-format
 msgid "cannot read inode %llu, disk block %lld, cnt %d\n"
-msgstr "nie mo¿na odczytaæ i-wêz³a %llu, blok dysku %lld, cnt %d\n"
+msgstr "nie moÅ¼na odczytaÄ‡ i-wÄ™zÅ‚a %llu, blok dysku %lld, cnt %d\n"
 
 #: ../repair/dino_chunks.c:757 ../repair/dino_chunks.c:938
 #: ../repair/phase3.c:74
 #, c-format
 msgid "bad state in block map %d\n"
-msgstr "b³êdny stan w mapie bloku %d\n"
+msgstr "bÅ‚Ä™dny stan w mapie bloku %d\n"
 
 #: ../repair/dino_chunks.c:761 ../repair/dino_chunks.c:943
 #, c-format
 msgid "inode block %llu multiply claimed, state was %d\n"
-msgstr "blok i-wêz³a %llu wielokrotnie przydzielony, stan by³ %d\n"
+msgstr "blok i-wÄ™zÅ‚a %llu wielokrotnie przydzielony, stan byÅ‚ %d\n"
 
 #: ../repair/dino_chunks.c:796
 #, c-format
 msgid "imap claims in-use inode %llu is free, "
-msgstr "imap twierdzi, ¿e u¿ywany i-wêze³ %llu jest wolny, "
+msgstr "imap twierdzi, Å¼e uÅ¼ywany i-wÄ™zeÅ‚ %llu jest wolny, "
 
 #: ../repair/dino_chunks.c:803
 msgid "correcting imap\n"
@@ -5617,106 +5617,106 @@ msgstr "poprawiono imap\n"
 
 #: ../repair/dino_chunks.c:805
 msgid "would correct imap\n"
-msgstr "imap zosta³oby poprawione\n"
+msgstr "imap zostaÅ‚oby poprawione\n"
 
 #: ../repair/dino_chunks.c:851
 #, c-format
 msgid "cleared root inode %llu\n"
-msgstr "wyczyszczono g³ówny i-wêze³ %llu\n"
+msgstr "wyczyszczono gÅ‚Ã³wny i-wÄ™zeÅ‚ %llu\n"
 
 #: ../repair/dino_chunks.c:855
 #, c-format
 msgid "would clear root inode %llu\n"
-msgstr "g³ówny wêze³ %llu zosta³by wyczyszczony\n"
+msgstr "gÅ‚Ã³wny wÄ™zeÅ‚ %llu zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/dino_chunks.c:864
 #, c-format
 msgid "cleared realtime bitmap inode %llu\n"
-msgstr "wyczyszczono i-wêze³ bitmapy realtime %llu\n"
+msgstr "wyczyszczono i-wÄ™zeÅ‚ bitmapy realtime %llu\n"
 
 #: ../repair/dino_chunks.c:869
 #, c-format
 msgid "would clear realtime bitmap inode %llu\n"
-msgstr "i-wêze³ bitmapy realtime %llu zosta³by wyczyszczony\n"
+msgstr "i-wÄ™zeÅ‚ bitmapy realtime %llu zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/dino_chunks.c:879
 #, c-format
 msgid "cleared realtime summary inode %llu\n"
-msgstr "wyczyszczono i-wêze³ opisu realtime %llu\n"
+msgstr "wyczyszczono i-wÄ™zeÅ‚ opisu realtime %llu\n"
 
 #: ../repair/dino_chunks.c:884
 #, c-format
 msgid "would clear realtime summary inode %llu\n"
-msgstr "i-wêze³ opisu realtime %llu zosta³by wyczyszczony\n"
+msgstr "i-wÄ™zeÅ‚ opisu realtime %llu zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/dino_chunks.c:890
 #, c-format
 msgid "cleared inode %llu\n"
-msgstr "wyczyszczono i-wêze³ %llu\n"
+msgstr "wyczyszczono i-wÄ™zeÅ‚ %llu\n"
 
 #: ../repair/dino_chunks.c:893
 #, c-format
 msgid "would have cleared inode %llu\n"
-msgstr "i-wêze³ %llu zosta³by wyczyszczony\n"
+msgstr "i-wÄ™zeÅ‚ %llu zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/dino_chunks.c:1099 ../repair/dino_chunks.c:1134
 #: ../repair/dino_chunks.c:1248
 msgid "found inodes not in the inode allocation tree\n"
-msgstr "znaleziono i-wêz³y nieobecne w drzewie alokacji i-wêz³ów\n"
+msgstr "znaleziono i-wÄ™zÅ‚y nieobecne w drzewie alokacji i-wÄ™zÅ‚Ã³w\n"
 
 #: ../repair/dinode.c:70
 msgid "Unknown inode format.\n"
-msgstr "Nieznany format i-wêz³a.\n"
+msgstr "Nieznany format i-wÄ™zÅ‚a.\n"
 
 #: ../repair/dinode.c:87
 #, c-format
 msgid "clearing inode %llu attributes\n"
-msgstr "wyczyszczono atrybuty i-wêz³a %llu\n"
+msgstr "wyczyszczono atrybuty i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/dinode.c:90
 #, c-format
 msgid "would have cleared inode %llu attributes\n"
-msgstr "atrybuty i-wêz³a %llu zosta³yby wyczyszczone\n"
+msgstr "atrybuty i-wÄ™zÅ‚a %llu zostaÅ‚yby wyczyszczone\n"
 
 #: ../repair/dinode.c:492
 #, c-format
 msgid "inode %llu - bad rt extent start block number %llu, offset %llu\n"
-msgstr "i-wêze³ %llu - b³êdny numer bloku pocz±tkowego fragmentu rt %llu, offset %llu\n"
+msgstr "i-wÄ™zeÅ‚ %llu - bÅ‚Ä™dny numer bloku poczÄ…tkowego fragmentu rt %llu, offset %llu\n"
 
 #: ../repair/dinode.c:498
 #, c-format
 msgid "inode %llu - bad rt extent last block number %llu, offset %llu\n"
-msgstr "i-wêze³ %llu - b³êdny numer bloku koñcowego fragmentu rt %llu, offset %llu\n"
+msgstr "i-wÄ™zeÅ‚ %llu - bÅ‚Ä™dny numer bloku koÅ„cowego fragmentu rt %llu, offset %llu\n"
 
 #: ../repair/dinode.c:504
 #, c-format
 msgid "inode %llu - bad rt extent overflows - start %llu, end %llu, offset %llu\n"
-msgstr "i-wêze³ %llu - b³êdne przepe³nienie fragmentu rt - pocz±tek %llu, koniec %llu, offset %llu\n"
+msgstr "i-wÄ™zeÅ‚ %llu - bÅ‚Ä™dne przepeÅ‚nienie fragmentu rt - poczÄ…tek %llu, koniec %llu, offset %llu\n"
 
 #: ../repair/dinode.c:518
 #, c-format
 msgid "malformed rt inode extent [%llu %llu] (fs rtext size = %u)\n"
-msgstr "zniekszta³cony fragment i-wêz³a rt [%llu %llu] (rozmiar fs rtext = %u)\n"
+msgstr "znieksztaÅ‚cony fragment i-wÄ™zÅ‚a rt [%llu %llu] (rozmiar fs rtext = %u)\n"
 
 #: ../repair/dinode.c:536
 #, c-format
 msgid "data fork in rt ino %llu claims dup rt extent, off - %llu, start - %llu, count %llu\n"
-msgstr "ga³±¼ danych w i-wê¼le rt %llu odwo³uje siê do powtórzonego fragmentu rt, offset %llu, pocz±tek %llu, liczba %llu\n"
+msgstr "gaÅ‚Ä…Åº danych w i-wÄ™Åºle rt %llu odwoÅ‚uje siÄ™ do powtÃ³rzonego fragmentu rt, offset %llu, poczÄ…tek %llu, liczba %llu\n"
 
 #: ../repair/dinode.c:556
 #, c-format
 msgid "bad state in rt block map %llu\n"
-msgstr "b³êdny stan w mapie bloku rt %llu\n"
+msgstr "bÅ‚Ä™dny stan w mapie bloku rt %llu\n"
 
 #: ../repair/dinode.c:562
 #, c-format
 msgid "data fork in rt inode %llu found metadata block %llu in rt bmap\n"
-msgstr "ga³±¼ danych w i-wê¼le rt %llu - znaleziono blok metadanych %llu w bmapie rt\n"
+msgstr "gaÅ‚Ä…Åº danych w i-wÄ™Åºle rt %llu - znaleziono blok metadanych %llu w bmapie rt\n"
 
 #: ../repair/dinode.c:572
 #, c-format
 msgid "data fork in rt inode %llu claims used rt block %llu\n"
-msgstr "ga³±¼ danych w i-wê¼le rt %llu odwo³uje siê do u¿ywanego bloku rt %llu\n"
+msgstr "gaÅ‚Ä…Åº danych w i-wÄ™Åºle rt %llu odwoÅ‚uje siÄ™ do uÅ¼ywanego bloku rt %llu\n"
 
 #: ../repair/dinode.c:579
 #, c-format
@@ -5729,7 +5729,7 @@ msgstr "danych"
 
 #: ../repair/dinode.c:632 ../repair/dinode.c:1179 ../repair/scan.c:155
 msgid "attr"
-msgstr "atrybutów"
+msgstr "atrybutÃ³w"
 
 #: ../repair/dinode.c:635
 msgid "real-time"
@@ -5737,62 +5737,62 @@ msgstr "realtime"
 
 #: ../repair/dinode.c:637
 msgid "regular"
-msgstr "zwyk³ym"
+msgstr "zwykÅ‚ym"
 
 #: ../repair/dinode.c:646
 #, c-format
 msgid "bmap rec out of order, inode %llu entry %d [o s c] [%llu %llu %llu], %d [%llu %llu %llu]\n"
-msgstr "rekord bmap uszkodzony, i-wêze³ %llu wpis %d [o s c] [%llu %llu %llu], %d [%llu %llu %llu]\n"
+msgstr "rekord bmap uszkodzony, i-wÄ™zeÅ‚ %llu wpis %d [o s c] [%llu %llu %llu], %d [%llu %llu %llu]\n"
 
 #: ../repair/dinode.c:660
 #, c-format
 msgid "zero length extent (off = %llu, fsbno = %llu) in ino %llu\n"
-msgstr "fragment zerowej d³ugo¶ci (off = %llu, fsbno = %llu) w i-wê¼le %llu\n"
+msgstr "fragment zerowej dÅ‚ugoÅ›ci (off = %llu, fsbno = %llu) w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dinode.c:689
 #, c-format
 msgid "inode %llu - bad extent starting block number %llu, offset %llu\n"
-msgstr "i-wêze³ %llu - b³êdny numer bloku pocz±tkowego fragmentu %llu, offset %llu\n"
+msgstr "i-wÄ™zeÅ‚ %llu - bÅ‚Ä™dny numer bloku poczÄ…tkowego fragmentu %llu, offset %llu\n"
 
 #: ../repair/dinode.c:696
 #, c-format
 msgid "inode %llu - bad extent last block number %llu, offset %llu\n"
-msgstr "i-wêze³ %llu - b³êdny numer bloku koñcowego fragmentu %llu, offset %llu\n"
+msgstr "i-wÄ™zeÅ‚ %llu - bÅ‚Ä™dny numer bloku koÅ„cowego fragmentu %llu, offset %llu\n"
 
 #: ../repair/dinode.c:703
 #, c-format
 msgid "inode %llu - bad extent overflows - start %llu, end %llu, offset %llu\n"
-msgstr "i-wêze³ %llu - b³êdne przepe³nienie fragmentu - pocz±tek %llu, koniec %llu, offset %llu\n"
+msgstr "i-wÄ™zeÅ‚ %llu - bÅ‚Ä™dne przepeÅ‚nienie fragmentu - poczÄ…tek %llu, koniec %llu, offset %llu\n"
 
 #: ../repair/dinode.c:711
 #, c-format
 msgid "inode %llu - extent offset too large - start %llu, count %llu, offset %llu\n"
-msgstr "i-wêze³ %llu - offset fragmentu zbyt du¿y - pocz±tek %llu, liczba %llu, offset %llu\n"
+msgstr "i-wÄ™zeÅ‚ %llu - offset fragmentu zbyt duÅ¼y - poczÄ…tek %llu, liczba %llu, offset %llu\n"
 
 #: ../repair/dinode.c:744
 #, c-format
 msgid "%s fork in ino %llu claims dup extent, off - %llu, start - %llu, cnt %llu\n"
-msgstr "ga³±¼ %s w i-wê¼le %llu odwo³uje siê do powtórzonego fragmentu, offset %llu, pocz±tek %llu, liczba %llu\n"
+msgstr "gaÅ‚Ä…Åº %s w i-wÄ™Åºle %llu odwoÅ‚uje siÄ™ do powtÃ³rzonego fragmentu, offset %llu, poczÄ…tek %llu, liczba %llu\n"
 
 #: ../repair/dinode.c:777
 #, c-format
 msgid "%s fork in ino %llu claims free block %llu\n"
-msgstr "ga³±¼ %s w i-wê¼le %llu odwo³uje siê do wolnego bloku %llu\n"
+msgstr "gaÅ‚Ä…Åº %s w i-wÄ™Åºle %llu odwoÅ‚uje siÄ™ do wolnego bloku %llu\n"
 
 #: ../repair/dinode.c:786
 #, c-format
 msgid "bad state in block map %llu\n"
-msgstr "b³êdny stan w mapie bloku %llu\n"
+msgstr "bÅ‚Ä™dny stan w mapie bloku %llu\n"
 
 #: ../repair/dinode.c:791
 #, c-format
 msgid "%s fork in inode %llu claims metadata block %llu\n"
-msgstr "ga³±¼ %s w i-wê¼le %llu odwo³uje siê do bloku metadanych %llu\n"
+msgstr "gaÅ‚Ä…Åº %s w i-wÄ™Åºle %llu odwoÅ‚uje siÄ™ do bloku metadanych %llu\n"
 
 #: ../repair/dinode.c:799
 #, c-format
 msgid "%s fork in %s inode %llu claims used block %llu\n"
-msgstr "ga³±¼ %s w i-wê¼le %s %llu odwo³uje siê do u¿ywanego bloku %llu\n"
+msgstr "gaÅ‚Ä…Åº %s w i-wÄ™Åºle %s %llu odwoÅ‚uje siÄ™ do uÅ¼ywanego bloku %llu\n"
 
 #: ../repair/dinode.c:805
 #, c-format
@@ -5802,207 +5802,207 @@ msgstr "niedozwolony stan %d w mapie bloku %llu\n"
 #: ../repair/dinode.c:883
 #, c-format
 msgid "cannot read inode (%u/%u), disk block %lld\n"
-msgstr "nie mo¿na odczytaæ i-wêz³a (%u/%u), blok dysku %lld\n"
+msgstr "nie moÅ¼na odczytaÄ‡ i-wÄ™zÅ‚a (%u/%u), blok dysku %lld\n"
 
 #: ../repair/dinode.c:994 ../repair/dinode.c:1051
 #, c-format
 msgid "cannot read bmap block %llu\n"
-msgstr "nie mo¿na odczytaæ bloku bmap %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku bmap %llu\n"
 
 #: ../repair/dinode.c:1014
 #, c-format
 msgid "# of bmap records in inode %llu exceeds max (%u, max - %u)\n"
-msgstr "liczba rekordów bmap w i-wê¼le %llu przekracza maksimum (%u, maksimum %u)\n"
+msgstr "liczba rekordÃ³w bmap w i-wÄ™Åºle %llu przekracza maksimum (%u, maksimum %u)\n"
 
 #: ../repair/dinode.c:1022
 #, c-format
 msgid "- # of bmap records in inode %llu less than minimum (%u, min - %u), proceeding ...\n"
-msgstr "- liczba rekordów bmap w i-wê¼le %llu mniejsza ni¿ minimum (%u, minimum %u), kontynuacja...\n"
+msgstr "- liczba rekordÃ³w bmap w i-wÄ™Åºle %llu mniejsza niÅ¼ minimum (%u, minimum %u), kontynuacja...\n"
 
 #: ../repair/dinode.c:1063
 #, c-format
 msgid "# of bmap records in inode %llu greater than maximum (%u, max - %u)\n"
-msgstr "liczba rekordów bmap w i-wê¼le %llu wiêksza ni¿ maksimum (%u, maksimum %u)\n"
+msgstr "liczba rekordÃ³w bmap w i-wÄ™Åºle %llu wiÄ™ksza niÅ¼ maksimum (%u, maksimum %u)\n"
 
 #: ../repair/dinode.c:1070
 #, c-format
 msgid "- # of bmap records in inode %llu less than minimum (%u, min - %u), continuing...\n"
-msgstr "- liczba rekordów bmap w i-wê¼le %llu mniejsza ni¿ minimum (%u, minimum %u), kontynuacja...\n"
+msgstr "- liczba rekordÃ³w bmap w i-wÄ™Åºle %llu mniejsza niÅ¼ minimum (%u, minimum %u), kontynuacja...\n"
 
 #: ../repair/dinode.c:1087
 #, c-format
 msgid "could not map block %llu\n"
-msgstr "nie uda³o siê odwzorowaæ bloku %llu\n"
+msgstr "nie udaÅ‚o siÄ™ odwzorowaÄ‡ bloku %llu\n"
 
 #: ../repair/dinode.c:1121
 #, c-format
 msgid "get_bmapi() called for local inode %llu\n"
-msgstr "get_bmapi() wywo³ano dla lokalnego i-wêz³a %llu\n"
+msgstr "get_bmapi() wywoÅ‚ano dla lokalnego i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/dinode.c:1129
 #, c-format
 msgid "bad inode format for inode %llu\n"
-msgstr "b³êdny format i-wêz³a dla i-wêz³a %llu\n"
+msgstr "bÅ‚Ä™dny format i-wÄ™zÅ‚a dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/dinode.c:1193
 #, c-format
 msgid "bad level %d in inode %llu bmap btree root block\n"
-msgstr "b³êdny poziom %d w bloku g³ównym bmap btree i-wêz³a %llu\n"
+msgstr "bÅ‚Ä™dny poziom %d w bloku gÅ‚Ã³wnym bmap btree i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/dinode.c:1198
 #, c-format
 msgid "bad numrecs 0 in inode %llu bmap btree root block\n"
-msgstr "b³êdne numrecs 0 w bloku g³ównym bmap btree i-wêz³a %llu\n"
+msgstr "bÅ‚Ä™dne numrecs 0 w bloku gÅ‚Ã³wnym bmap btree i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/dinode.c:1207
 #, c-format
 msgid "indicated size of %s btree root (%d bytes) greater than space in inode %llu %s fork\n"
-msgstr "oznaczony rozmiar korzenia b-drzewa %s (%d bajtów) wiêkszy ni¿ miejsce w i-wê¼le %llu ga³êzi %s\n"
+msgstr "oznaczony rozmiar korzenia b-drzewa %s (%d bajtÃ³w) wiÄ™kszy niÅ¼ miejsce w i-wÄ™Åºle %llu gaÅ‚Ä™zi %s\n"
 
 #: ../repair/dinode.c:1227 ../repair/scan.c:366
 #, c-format
 msgid "bad bmap btree ptr 0x%llx in ino %llu\n"
-msgstr "b³êdny wska¼nik bmap btree 0x%llx w i-wê¼le %llu\n"
+msgstr "bÅ‚Ä™dny wskaÅºnik bmap btree 0x%llx w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dinode.c:1246
 #, c-format
 msgid "correcting key in bmbt root (was %llu, now %llu) in inode %llu %s fork\n"
-msgstr "poprawiono klucz w korzeniu bmbt (by³ %llu, jest %llu) w i-wê¼le %llu ga³êzi %s\n"
+msgstr "poprawiono klucz w korzeniu bmbt (byÅ‚ %llu, jest %llu) w i-wÄ™Åºle %llu gaÅ‚Ä™zi %s\n"
 
 #: ../repair/dinode.c:1257
 #, c-format
 msgid "bad key in bmbt root (is %llu, would reset to %llu) in inode %llu %s fork\n"
-msgstr "b³êdny klucz w korzeniu bmbt (jest %llu, zosta³y przestawiony na %llu) w i-wê¼le %llu ga³êzi %s\n"
+msgstr "bÅ‚Ä™dny klucz w korzeniu bmbt (jest %llu, zostaÅ‚y przestawiony na %llu) w i-wÄ™Åºle %llu gaÅ‚Ä™zi %s\n"
 
 #: ../repair/dinode.c:1273
 #, c-format
 msgid "out of order bmbt root key %llu in inode %llu %s fork\n"
-msgstr "niepoprawny klucz korzenia bmbt %llu w i-wê¼le %llu ga³êzi %s\n"
+msgstr "niepoprawny klucz korzenia bmbt %llu w i-wÄ™Åºle %llu gaÅ‚Ä™zi %s\n"
 
 #: ../repair/dinode.c:1289
 #, c-format
 msgid "bad fwd (right) sibling pointer (saw %llu should be NULLDFSBNO)\n"
-msgstr "b³êdny wska¼nik fwd (prawy) (widziano %llu, powinno byæ NULLDFSBNO)\n"
+msgstr "bÅ‚Ä™dny wskaÅºnik fwd (prawy) (widziano %llu, powinno byÄ‡ NULLDFSBNO)\n"
 
 #: ../repair/dinode.c:1292
 #, c-format
 msgid "\tin inode %u (%s fork) bmap btree block %llu\n"
-msgstr "\tw i-wê¼le %u (ga³êzi %s) bloku bmap btree %llu\n"
+msgstr "\tw i-wÄ™Åºle %u (gaÅ‚Ä™zi %s) bloku bmap btree %llu\n"
 
 #: ../repair/dinode.c:1360
 #, c-format
 msgid "local inode %llu data fork is too large (size = %lld, max = %d)\n"
-msgstr "ga³±¼ danych lokalnego i-wêz³a %llu zbyt du¿a (rozmiar = %lld, maksimum = %d)\n"
+msgstr "gaÅ‚Ä…Åº danych lokalnego i-wÄ™zÅ‚a %llu zbyt duÅ¼a (rozmiar = %lld, maksimum = %d)\n"
 
 #: ../repair/dinode.c:1368
 #, c-format
 msgid "local inode %llu attr fork too large (size %d, max = %d)\n"
-msgstr "ga³±¼ atrybutów lokalnego i-wêz³a %llu zbyt du¿a (rozmiar %d, maksimum = %d)\n"
+msgstr "gaÅ‚Ä…Åº atrybutÃ³w lokalnego i-wÄ™zÅ‚a %llu zbyt duÅ¼a (rozmiar %d, maksimum = %d)\n"
 
 #: ../repair/dinode.c:1375
 #, c-format
 msgid "local inode %llu attr too small (size = %d, min size = %d)\n"
-msgstr "ga³±¼ atrybutów lokalnego i-wêz³a %llu zbyt ma³a (rozmiar = %d, minimum = %d)\n"
+msgstr "gaÅ‚Ä…Åº atrybutÃ³w lokalnego i-wÄ™zÅ‚a %llu zbyt maÅ‚a (rozmiar = %d, minimum = %d)\n"
 
 #: ../repair/dinode.c:1398
 #, c-format
 msgid "mismatch between format (%d) and size (%lld) in symlink ino %llu\n"
-msgstr "niezgodno¶æ miêdzy formatem (%d) i rozmiarem (%lld) w i-wê¼le dowi±zania symbolicznego %llu\n"
+msgstr "niezgodnoÅ›Ä‡ miÄ™dzy formatem (%d) i rozmiarem (%lld) w i-wÄ™Åºle dowiÄ…zania symbolicznego %llu\n"
 
 #: ../repair/dinode.c:1404
 #, c-format
 msgid "mismatch between format (%d) and size (%lld) in symlink inode %llu\n"
-msgstr "niezgodno¶æ miêdzy formatem (%d) i rozmiarem (%lld) w i-wê¼le dowi±zania symbolicznego %llu\n"
+msgstr "niezgodnoÅ›Ä‡ miÄ™dzy formatem (%d) i rozmiarem (%lld) w i-wÄ™Åºle dowiÄ…zania symbolicznego %llu\n"
 
 #: ../repair/dinode.c:1419
 #, c-format
 msgid "bad number of extents (%d) in symlink %llu data fork\n"
-msgstr "b³êdna liczba fragmentów (%d) w ga³êzi danych dowi±zania symbolicznego %llu\n"
+msgstr "bÅ‚Ä™dna liczba fragmentÃ³w (%d) w gaÅ‚Ä™zi danych dowiÄ…zania symbolicznego %llu\n"
 
 #: ../repair/dinode.c:1432
 #, c-format
 msgid "bad extent #%d offset (%llu) in symlink %llu data fork\n"
-msgstr "b³êdny offset fragmentu %d (%llu) w ga³êzi danych dowi±zania symbolicznego %llu\n"
+msgstr "bÅ‚Ä™dny offset fragmentu %d (%llu) w gaÅ‚Ä™zi danych dowiÄ…zania symbolicznego %llu\n"
 
 #: ../repair/dinode.c:1438
 #, c-format
 msgid "bad extent #%d count (%llu) in symlink %llu data fork\n"
-msgstr "b³êdna liczba fragmentu #%d (%llu) w ga³êzi danych dowi±zania symbolicznego %llu\n"
+msgstr "bÅ‚Ä™dna liczba fragmentu #%d (%llu) w gaÅ‚Ä™zi danych dowiÄ…zania symbolicznego %llu\n"
 
 #: ../repair/dinode.c:1494
 #, c-format
 msgid "symlink in inode %llu too long (%lld chars)\n"
-msgstr "dowi±zanie symboliczne w i-wê¼le %llu zbyt d³ugie (%lld znaków)\n"
+msgstr "dowiÄ…zanie symboliczne w i-wÄ™Åºle %llu zbyt dÅ‚ugie (%lld znakÃ³w)\n"
 
 #: ../repair/dinode.c:1527
 #, c-format
 msgid "cannot read inode %llu, file block %d, disk block %llu\n"
-msgstr "nie mo¿na odczytaæ i-wêz³a %llu, blok pliku %d, blok dysku %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ i-wÄ™zÅ‚a %llu, blok pliku %d, blok dysku %llu\n"
 
 #: ../repair/dinode.c:1549
 #, c-format
 msgid "found illegal null character in symlink inode %llu\n"
-msgstr "znaleziono niedozwolony znak null w i-wê¼le dowi±zania symbolicznego %llu\n"
+msgstr "znaleziono niedozwolony znak null w i-wÄ™Åºle dowiÄ…zania symbolicznego %llu\n"
 
 #: ../repair/dinode.c:1563 ../repair/dinode.c:1573
 #, c-format
 msgid "component of symlink in inode %llu too long\n"
-msgstr "sk³adnik dowi±zania symbolicznego w i-wê¼le %llu zbyt d³ugi\n"
+msgstr "skÅ‚adnik dowiÄ…zania symbolicznego w i-wÄ™Åºle %llu zbyt dÅ‚ugi\n"
 
 #: ../repair/dinode.c:1598
 #, c-format
 msgid "inode %llu has bad inode type (IFMNT)\n"
-msgstr "i-wêze³ %llu ma b³êdny typ i-wêz³a (IFMNT)\n"
+msgstr "i-wÄ™zeÅ‚ %llu ma bÅ‚Ä™dny typ i-wÄ™zÅ‚a (IFMNT)\n"
 
 #: ../repair/dinode.c:1608
 #, c-format
 msgid "size of character device inode %llu != 0 (%lld bytes)\n"
-msgstr "rozmiar i-wêz³a urz±dzenia znakowego %llu != 0 (%lld bajtów)\n"
+msgstr "rozmiar i-wÄ™zÅ‚a urzÄ…dzenia znakowego %llu != 0 (%lld bajtÃ³w)\n"
 
 #: ../repair/dinode.c:1613
 #, c-format
 msgid "size of block device inode %llu != 0 (%lld bytes)\n"
-msgstr "rozmiar i-wêz³a urz±dzenia blokowego %llu != 0 (%lld bajtów)\n"
+msgstr "rozmiar i-wÄ™zÅ‚a urzÄ…dzenia blokowego %llu != 0 (%lld bajtÃ³w)\n"
 
 #: ../repair/dinode.c:1618
 #, c-format
 msgid "size of socket inode %llu != 0 (%lld bytes)\n"
-msgstr "rozmiar i-wêz³a gniazda %llu != 0 (%lld bajtów)\n"
+msgstr "rozmiar i-wÄ™zÅ‚a gniazda %llu != 0 (%lld bajtÃ³w)\n"
 
 #: ../repair/dinode.c:1623
 #, c-format
 msgid "size of fifo inode %llu != 0 (%lld bytes)\n"
-msgstr "rozmiar i-wêz³a potoku %llu != 0 (%lld bajtów)\n"
+msgstr "rozmiar i-wÄ™zÅ‚a potoku %llu != 0 (%lld bajtÃ³w)\n"
 
 #: ../repair/dinode.c:1628
 #, c-format
 msgid "Internal error - process_misc_ino_types, illegal type %d\n"
-msgstr "B³±d wewnêtrzny - process_misc_ino_types, niedozwolony typ %d\n"
+msgstr "BÅ‚Ä…d wewnÄ™trzny - process_misc_ino_types, niedozwolony typ %d\n"
 
 #: ../repair/dinode.c:1655
 #, c-format
 msgid "size of character device inode %llu != 0 (%llu blocks)\n"
-msgstr "rozmiar i-wêz³a urz±dzenia znakowego %llu != 0 (%llu bloków)\n"
+msgstr "rozmiar i-wÄ™zÅ‚a urzÄ…dzenia znakowego %llu != 0 (%llu blokÃ³w)\n"
 
 #: ../repair/dinode.c:1660
 #, c-format
 msgid "size of block device inode %llu != 0 (%llu blocks)\n"
-msgstr "rozmiar i-wêz³a urz±dzenia blokowego %llu != 0 (%llu bloków)\n"
+msgstr "rozmiar i-wÄ™zÅ‚a urzÄ…dzenia blokowego %llu != 0 (%llu blokÃ³w)\n"
 
 #: ../repair/dinode.c:1665
 #, c-format
 msgid "size of socket inode %llu != 0 (%llu blocks)\n"
-msgstr "rozmiar i-wêz³a gniazda %llu != 0 (%llu bloków)\n"
+msgstr "rozmiar i-wÄ™zÅ‚a gniazda %llu != 0 (%llu blokÃ³w)\n"
 
 #: ../repair/dinode.c:1670
 #, c-format
 msgid "size of fifo inode %llu != 0 (%llu blocks)\n"
-msgstr "rozmiar i-wêz³a potoku %llu != 0 (%llu bloków)\n"
+msgstr "rozmiar i-wÄ™zÅ‚a potoku %llu != 0 (%llu blokÃ³w)\n"
 
 #: ../repair/dinode.c:1748
 #, c-format
 msgid "root inode %llu has bad type 0x%x\n"
-msgstr "i-wêze³ g³ówny %llu ma b³êdny typ 0x%x\n"
+msgstr "i-wÄ™zeÅ‚ gÅ‚Ã³wny %llu ma bÅ‚Ä™dny typ 0x%x\n"
 
 #: ../repair/dinode.c:1752
 msgid "resetting to directory\n"
@@ -6010,185 +6010,185 @@ msgstr "przestawiono na katalog\n"
 
 #: ../repair/dinode.c:1756
 msgid "would reset to directory\n"
-msgstr "zosta³by przestawiony na katalog\n"
+msgstr "zostaÅ‚by przestawiony na katalog\n"
 
 #: ../repair/dinode.c:1762
 #, c-format
 msgid "user quota inode %llu has bad type 0x%x\n"
-msgstr "i-wêze³ limitu u¿ytkownika %llu ma b³êdny typ 0x%x\n"
+msgstr "i-wÄ™zeÅ‚ limitu uÅ¼ytkownika %llu ma bÅ‚Ä™dny typ 0x%x\n"
 
 #: ../repair/dinode.c:1771
 #, c-format
 msgid "group quota inode %llu has bad type 0x%x\n"
-msgstr "i-wêze³ limitu grupy %llu ma b³êdny typ 0x%x\n"
+msgstr "i-wÄ™zeÅ‚ limitu grupy %llu ma bÅ‚Ä™dny typ 0x%x\n"
 
 #: ../repair/dinode.c:1780
 #, c-format
 msgid "realtime summary inode %llu has bad type 0x%x, "
-msgstr "i-wêze³ opisu realtime %llu ma b³êdny typ 0x%x, "
+msgstr "i-wÄ™zeÅ‚ opisu realtime %llu ma bÅ‚Ä™dny typ 0x%x, "
 
 #: ../repair/dinode.c:1783 ../repair/dinode.c:1802
 msgid "resetting to regular file\n"
-msgstr "przestawiono na zwyk³y plik\n"
+msgstr "przestawiono na zwykÅ‚y plik\n"
 
 #: ../repair/dinode.c:1787 ../repair/dinode.c:1806
 msgid "would reset to regular file\n"
-msgstr "zosta³by przestawiony na zwyk³y plik\n"
+msgstr "zostaÅ‚by przestawiony na zwykÅ‚y plik\n"
 
 #: ../repair/dinode.c:1791
 #, c-format
 msgid "bad # of extents (%u) for realtime summary inode %llu\n"
-msgstr "b³êdna liczba fragmentów (%u) dla i-wêz³± opisu realtime %llu\n"
+msgstr "bÅ‚Ä™dna liczba fragmentÃ³w (%u) dla i-wÄ™zÅ‚Ä… opisu realtime %llu\n"
 
 #: ../repair/dinode.c:1799
 #, c-format
 msgid "realtime bitmap inode %llu has bad type 0x%x, "
-msgstr "i-wêze³ bitmapy realtime %llu ma b³êdny typ 0x%x, "
+msgstr "i-wÄ™zeÅ‚ bitmapy realtime %llu ma bÅ‚Ä™dny typ 0x%x, "
 
 #: ../repair/dinode.c:1810
 #, c-format
 msgid "bad # of extents (%u) for realtime bitmap inode %llu\n"
-msgstr "b³êdna liczba fragmentów (%u) dla i-wêz³± bitmapy realtime %llu\n"
+msgstr "bÅ‚Ä™dna liczba fragmentÃ³w (%u) dla i-wÄ™zÅ‚Ä… bitmapy realtime %llu\n"
 
 #: ../repair/dinode.c:1845
 #, c-format
 msgid "mismatch between format (%d) and size (%lld) in directory ino %llu\n"
-msgstr "niezgodno¶æ miêdzy formatem (%d) i rozmiarem (%lld) w i-wê¼le katalogu %llu\n"
+msgstr "niezgodnoÅ›Ä‡ miÄ™dzy formatem (%d) i rozmiarem (%lld) w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dinode.c:1851
 #, c-format
 msgid "directory inode %llu has bad size %lld\n"
-msgstr "i-wêze³ katalogu %llu ma b³êdny rozmiar %lld\n"
+msgstr "i-wÄ™zeÅ‚ katalogu %llu ma bÅ‚Ä™dny rozmiar %lld\n"
 
 #: ../repair/dinode.c:1859
 #, c-format
 msgid "bad data fork in symlink %llu\n"
-msgstr "b³êdna ga³±¼ danych w dowi±zaniu symbolicznym %llu\n"
+msgstr "bÅ‚Ä™dna gaÅ‚Ä…Åº danych w dowiÄ…zaniu symbolicznym %llu\n"
 
 #: ../repair/dinode.c:1879
 #, c-format
 msgid "found inode %llu claiming to be a real-time file\n"
-msgstr "znaleziono i-wêze³ %llu twierdz±cy, ¿e nale¿y do pliku realtime\n"
+msgstr "znaleziono i-wÄ™zeÅ‚ %llu twierdzÄ…cy, Å¼e naleÅ¼y do pliku realtime\n"
 
 #: ../repair/dinode.c:1888
 #, c-format
 msgid "realtime bitmap inode %llu has bad size %lld (should be %lld)\n"
-msgstr "i-wêze³ bitmapy realtime %llu ma b³êdny rozmiar %lld (powinien byæ %lld)\n"
+msgstr "i-wÄ™zeÅ‚ bitmapy realtime %llu ma bÅ‚Ä™dny rozmiar %lld (powinien byÄ‡ %lld)\n"
 
 #: ../repair/dinode.c:1898
 #, c-format
 msgid "realtime summary inode %llu has bad size %lld (should be %d)\n"
-msgstr "i-wêze³ opisu realtime %llu ma b³êdny rozmiar %lld (powinien byæ %d)\n"
+msgstr "i-wÄ™zeÅ‚ opisu realtime %llu ma bÅ‚Ä™dny rozmiar %lld (powinien byÄ‡ %d)\n"
 
 #: ../repair/dinode.c:1926
 #, c-format
 msgid "bad attr fork offset %d in dev inode %llu, should be %d\n"
-msgstr "b³êdny offset ga³êzi atrybutów %d w i-wê¼le urz±dzenia %llu, powinien byæ %d\n"
+msgstr "bÅ‚Ä™dny offset gaÅ‚Ä™zi atrybutÃ³w %d w i-wÄ™Åºle urzÄ…dzenia %llu, powinien byÄ‡ %d\n"
 
 #: ../repair/dinode.c:1936
 #, c-format
 msgid "bad attr fork offset %d in inode %llu, max=%d\n"
-msgstr "b³êdny offset ga³êzi atrybutów %d w i-wê¼le %llu, maksimum=%d\n"
+msgstr "bÅ‚Ä™dny offset gaÅ‚Ä™zi atrybutÃ³w %d w i-wÄ™Åºle %llu, maksimum=%d\n"
 
 #: ../repair/dinode.c:1943
 #, c-format
 msgid "unexpected inode format %d\n"
-msgstr "nieoczekiwany format i-wêz³a %d\n"
+msgstr "nieoczekiwany format i-wÄ™zÅ‚a %d\n"
 
 #: ../repair/dinode.c:1963
 #, c-format
 msgid "correcting nblocks for inode %llu, was %llu - counted %llu\n"
-msgstr "poprawiono nblocks dla i-wêz³a %llu - by³o %llu, naliczono %llu\n"
+msgstr "poprawiono nblocks dla i-wÄ™zÅ‚a %llu - byÅ‚o %llu, naliczono %llu\n"
 
 #: ../repair/dinode.c:1969
 #, c-format
 msgid "bad nblocks %llu for inode %llu, would reset to %llu\n"
-msgstr "b³êdne nblocks %llu dla i-wêz³a %llu, zosta³oby przestawione na %llu\n"
+msgstr "bÅ‚Ä™dne nblocks %llu dla i-wÄ™zÅ‚a %llu, zostaÅ‚oby przestawione na %llu\n"
 
 #: ../repair/dinode.c:1976
 #, c-format
 msgid "too many data fork extents (%llu) in inode %llu\n"
-msgstr "zbyt du¿o fragmentów ga³êzi danych (%llu) w i-wê¼le %llu\n"
+msgstr "zbyt duÅ¼o fragmentÃ³w gaÅ‚Ä™zi danych (%llu) w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dinode.c:1982
 #, c-format
 msgid "correcting nextents for inode %llu, was %d - counted %llu\n"
-msgstr "poprawiono nextents dla i-wêz³a %llu - by³o %d, naliczono %llu\n"
+msgstr "poprawiono nextents dla i-wÄ™zÅ‚a %llu - byÅ‚o %d, naliczono %llu\n"
 
 #: ../repair/dinode.c:1988
 #, c-format
 msgid "bad nextents %d for inode %llu, would reset to %llu\n"
-msgstr "b³êdne nextents %d dla i-wêz³a %llu, zosta³oby przestawione na %llu\n"
+msgstr "bÅ‚Ä™dne nextents %d dla i-wÄ™zÅ‚a %llu, zostaÅ‚oby przestawione na %llu\n"
 
 #: ../repair/dinode.c:1995
 #, c-format
 msgid "too many attr fork extents (%llu) in inode %llu\n"
-msgstr "zbyt du¿o fragmentów ga³êzi atrybutów (%llu) w i-wê¼le %llu\n"
+msgstr "zbyt duÅ¼o fragmentÃ³w gaÅ‚Ä™zi atrybutÃ³w (%llu) w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dinode.c:2001
 #, c-format
 msgid "correcting anextents for inode %llu, was %d - counted %llu\n"
-msgstr "poprawiono anextents dla i-wêz³a %llu - by³o %d, naliczono %llu\n"
+msgstr "poprawiono anextents dla i-wÄ™zÅ‚a %llu - byÅ‚o %d, naliczono %llu\n"
 
 #: ../repair/dinode.c:2007
 #, c-format
 msgid "bad anextents %d for inode %llu, would reset to %llu\n"
-msgstr "b³êdne anextents %d dla i-wêz³a %llu, zosta³oby przestawione na %llu\n"
+msgstr "bÅ‚Ä™dne anextents %d dla i-wÄ™zÅ‚a %llu, zostaÅ‚oby przestawione na %llu\n"
 
 #: ../repair/dinode.c:2062 ../repair/dinode.c:2100
 #, c-format
 msgid "unknown format %d, ino %llu (mode = %d)\n"
-msgstr "nieznany format %d, i-wêze³ %llu (tryb = %d)\n"
+msgstr "nieznany format %d, i-wÄ™zeÅ‚ %llu (tryb = %d)\n"
 
 #: ../repair/dinode.c:2067
 #, c-format
 msgid "bad data fork in inode %llu\n"
-msgstr "b³êdna ga³±¼ danych w i-wê¼le %llu\n"
+msgstr "bÅ‚Ä™dna gaÅ‚Ä…Åº danych w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dinode.c:2139
 #, c-format
 msgid "bad attribute format %d in inode %llu, "
-msgstr "b³êdny format atrybutów %d w i-wê¼le %llu, "
+msgstr "bÅ‚Ä™dny format atrybutÃ³w %d w i-wÄ™Åºle %llu, "
 
 #: ../repair/dinode.c:2142
 msgid "resetting value\n"
-msgstr "przestawiono warto¶æ\n"
+msgstr "przestawiono wartoÅ›Ä‡\n"
 
 #: ../repair/dinode.c:2146
 msgid "would reset value\n"
-msgstr "warto¶æ zosta³aby przestawiona\n"
+msgstr "wartoÅ›Ä‡ zostaÅ‚aby przestawiona\n"
 
 #: ../repair/dinode.c:2191
 #, c-format
 msgid "bad attribute fork in inode %llu"
-msgstr "b³êdna ga³±¼ atrybutów w i-wê¼le %llu"
+msgstr "bÅ‚Ä™dna gaÅ‚Ä…Åº atrybutÃ³w w i-wÄ™Åºle %llu"
 
 #: ../repair/dinode.c:2195
 msgid ", clearing attr fork\n"
-msgstr ", wyczyszczono ga³±¼ atrybutów\n"
+msgstr ", wyczyszczono gaÅ‚Ä…Åº atrybutÃ³w\n"
 
 #: ../repair/dinode.c:2204
 msgid ", would clear attr fork\n"
-msgstr ", ga³±¼ atrybutów zosta³aby wyczyszczona\n"
+msgstr ", gaÅ‚Ä…Åº atrybutÃ³w zostaÅ‚aby wyczyszczona\n"
 
 #: ../repair/dinode.c:2232
 #, c-format
 msgid "illegal attribute fmt %d, ino %llu\n"
-msgstr "niedozwolony format atrybutów %d, i-wêze³ %llu\n"
+msgstr "niedozwolony format atrybutÃ³w %d, i-wÄ™zeÅ‚ %llu\n"
 
 #: ../repair/dinode.c:2251
 #, c-format
 msgid "problem with attribute contents in inode %llu\n"
-msgstr "problem z zawarto¶ci± atrybutu w i-wê¼le %llu\n"
+msgstr "problem z zawartoÅ›ciÄ… atrybutu w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dinode.c:2259
 msgid "would clear attr fork\n"
-msgstr "ga³±¼ atrybutów zosta³aby wyczyszczona\n"
+msgstr "gaÅ‚Ä…Åº atrybutÃ³w zostaÅ‚aby wyczyszczona\n"
 
 #: ../repair/dinode.c:2301
 #, c-format
 msgid "version 2 inode %llu claims > %u links, "
-msgstr "i-wêze³ %llu w wersji 2 odwo³uje siê do > %u dowi±zañ, "
+msgstr "i-wÄ™zeÅ‚ %llu w wersji 2 odwoÅ‚uje siÄ™ do > %u dowiÄ…zaÅ„, "
 
 #: ../repair/dinode.c:2304
 msgid "updating superblock version number\n"
@@ -6196,12 +6196,12 @@ msgstr "uaktualniono numer wersji superbloku\n"
 
 #: ../repair/dinode.c:2307
 msgid "would update superblock version number\n"
-msgstr "numer wersji superbloku zosta³by uaktualniony\n"
+msgstr "numer wersji superbloku zostaÅ‚by uaktualniony\n"
 
 #: ../repair/dinode.c:2315
 #, c-format
 msgid "WARNING:  version 2 inode %llu claims > %u links, "
-msgstr "UWAGA: i-wêze³ %llu w wersji 2 odwo³uje siê do > %u dowi±zañ, "
+msgstr "UWAGA: i-wÄ™zeÅ‚ %llu w wersji 2 odwoÅ‚uje siÄ™ do > %u dowiÄ…zaÅ„, "
 
 #: ../repair/dinode.c:2319
 #, c-format
@@ -6209,8 +6209,8 @@ msgid ""
 "converting back to version 1,\n"
 "this may destroy %d links\n"
 msgstr ""
-"przekszta³canie z powrotem do wersji 1,\n"
-"mo¿e to zniszczyæ %d dowi±zañ\n"
+"przeksztaÅ‚canie z powrotem do wersji 1,\n"
+"moÅ¼e to zniszczyÄ‡ %d dowiÄ…zaÅ„\n"
 
 #: ../repair/dinode.c:2329
 #, c-format
@@ -6218,49 +6218,49 @@ msgid ""
 "would convert back to version 1,\n"
 "\tthis might destroy %d links\n"
 msgstr ""
-"zosta³by przekszta³cony z powrotem do wersji 1,\n"
-"\tco mog³oby zniszczyæ %d dowi±zañ\n"
+"zostaÅ‚by przeksztaÅ‚cony z powrotem do wersji 1,\n"
+"\tco mogÅ‚oby zniszczyÄ‡ %d dowiÄ…zaÅ„\n"
 
 #: ../repair/dinode.c:2344
 #, c-format
 msgid "found version 2 inode %llu, "
-msgstr "znaleziono i-wêze³ %llu w wersji 2, "
+msgstr "znaleziono i-wÄ™zeÅ‚ %llu w wersji 2, "
 
 #: ../repair/dinode.c:2346
 msgid "converting back to version 1\n"
-msgstr "przekszta³cono z powrotem do wersji 1\n"
+msgstr "przeksztaÅ‚cono z powrotem do wersji 1\n"
 
 #: ../repair/dinode.c:2352
 msgid "would convert back to version 1\n"
-msgstr "zosta³by przekszta³cony z powrotem do wersji 1\n"
+msgstr "zostaÅ‚by przeksztaÅ‚cony z powrotem do wersji 1\n"
 
 #: ../repair/dinode.c:2365
 #, c-format
 msgid "clearing obsolete nlink field in version 2 inode %llu, was %d, now 0\n"
-msgstr "wyczyszczono przestarza³e pole nlink w i-wê¼le %llu w wersji 2 - by³o %d, jest 0\n"
+msgstr "wyczyszczono przestarzaÅ‚e pole nlink w i-wÄ™Åºle %llu w wersji 2 - byÅ‚o %d, jest 0\n"
 
 #: ../repair/dinode.c:2371
 #, c-format
 msgid "would clear obsolete nlink field in version 2 inode %llu, currently %d\n"
-msgstr "przestarza³e pole nlink w i-wê¼le %llu w wersji 2 zosta³oby wyczyszczone, aktualnie %d\n"
+msgstr "przestarzaÅ‚e pole nlink w i-wÄ™Åºle %llu w wersji 2 zostaÅ‚oby wyczyszczone, aktualnie %d\n"
 
 #: ../repair/dinode.c:2444
 #, c-format
 msgid "bad magic number 0x%x on inode %llu%c"
-msgstr "b³êdna liczba magiczna 0x%x w i-wê¼le %llu%c"
+msgstr "bÅ‚Ä™dna liczba magiczna 0x%x w i-wÄ™Åºle %llu%c"
 
 #: ../repair/dinode.c:2449
 msgid " resetting magic number\n"
-msgstr " przestawiono liczbê magiczn±\n"
+msgstr " przestawiono liczbÄ™ magicznÄ…\n"
 
 #: ../repair/dinode.c:2453
 msgid " would reset magic number\n"
-msgstr " liczba magiczna zosta³aby przestawiona\n"
+msgstr " liczba magiczna zostaÅ‚aby przestawiona\n"
 
 #: ../repair/dinode.c:2461
 #, c-format
 msgid "bad version number 0x%x on inode %llu%c"
-msgstr "b³êdny numer wersji 0x%x w i-wê¼le %llu%c"
+msgstr "bÅ‚Ä™dny numer wersji 0x%x w i-wÄ™Åºle %llu%c"
 
 #: ../repair/dinode.c:2466
 msgid " resetting version number\n"
@@ -6268,40 +6268,40 @@ msgstr " przestawiono numer wersji\n"
 
 #: ../repair/dinode.c:2472
 msgid " would reset version number\n"
-msgstr " numer wersji zosta³by przestawiony\n"
+msgstr " numer wersji zostaÅ‚by przestawiony\n"
 
 #: ../repair/dinode.c:2481
 #, c-format
 msgid "bad (negative) size %lld on inode %llu\n"
-msgstr "b³êdny (ujemny) rozmiar %lld w i-wê¼le %llu\n"
+msgstr "bÅ‚Ä™dny (ujemny) rozmiar %lld w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dinode.c:2512
 #, c-format
 msgid "imap claims a free inode %llu is in use, "
-msgstr "imap odwo³uje siê do wolnego bloku %llu, który jest w u¿yciu, "
+msgstr "imap odwoÅ‚uje siÄ™ do wolnego bloku %llu, ktÃ³ry jest w uÅ¼yciu, "
 
 #: ../repair/dinode.c:2514
 msgid "correcting imap and clearing inode\n"
-msgstr "poprawiono imap i wyczyszczono i-wêze³\n"
+msgstr "poprawiono imap i wyczyszczono i-wÄ™zeÅ‚\n"
 
 #: ../repair/dinode.c:2518
 msgid "would correct imap and clear inode\n"
-msgstr "poprawiono by imap i wyczyszczono by i-wêze³\n"
+msgstr "poprawiono by imap i wyczyszczono by i-wÄ™zeÅ‚\n"
 
 #: ../repair/dinode.c:2534
 #, c-format
 msgid "bad inode format in inode %llu\n"
-msgstr "b³êdny format i-wêz³a w i-wê¼le %llu\n"
+msgstr "bÅ‚Ä™dny format i-wÄ™zÅ‚a w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dinode.c:2587
 #, c-format
 msgid "bad inode type %#o inode %llu\n"
-msgstr "b³êdny typ i-wêz³a %#o w i-wê¼le %llu\n"
+msgstr "bÅ‚Ä™dny typ i-wÄ™zÅ‚a %#o w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dinode.c:2610
 #, c-format
 msgid "bad non-zero extent size %u for non-realtime/extsize inode %llu, "
-msgstr "b³êdny niezerowy rozmiar fragmentu %u dla extsize i-wêz³a nie-realtime %llu, "
+msgstr "bÅ‚Ä™dny niezerowy rozmiar fragmentu %u dla extsize i-wÄ™zÅ‚a nie-realtime %llu, "
 
 #: ../repair/dinode.c:2614
 msgid "resetting to zero\n"
@@ -6309,82 +6309,82 @@ msgstr "przestawiono na zero\n"
 
 #: ../repair/dinode.c:2618
 msgid "would reset to zero\n"
-msgstr "zosta³by przestawiony na zero\n"
+msgstr "zostaÅ‚by przestawiony na zero\n"
 
 #: ../repair/dinode.c:2673
 #, c-format
 msgid "problem with directory contents in inode %llu\n"
-msgstr "problem z zawarto¶ci± katalogu w i-wê¼le %llu\n"
+msgstr "problem z zawartoÅ›ciÄ… katalogu w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dinode.c:2680
 #, c-format
 msgid "problem with symbolic link in inode %llu\n"
-msgstr "problem z dowi±zaniem symbolicznym w i-wê¼le %llu\n"
+msgstr "problem z dowiÄ…zaniem symbolicznym w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dir.c:153
 #, c-format
 msgid "invalid inode number %llu in directory %llu\n"
-msgstr "b³êdny numer i-wêz³a %llu w katalogu %llu\n"
+msgstr "bÅ‚Ä™dny numer i-wÄ™zÅ‚a %llu w katalogu %llu\n"
 
 #: ../repair/dir.c:158
 #, c-format
 msgid "entry in shortform dir %llu references rt bitmap inode %llu\n"
-msgstr "wpis w krótkim katalogu %llu odwo³uje siê do i-wêz³a bitmapy rt %llu\n"
+msgstr "wpis w krÃ³tkim katalogu %llu odwoÅ‚uje siÄ™ do i-wÄ™zÅ‚a bitmapy rt %llu\n"
 
 #: ../repair/dir.c:163
 #, c-format
 msgid "entry in shortform dir %llu references rt summary inode %llu\n"
-msgstr "wpis w krótkim katalogu %llu odwo³uje siê do i-wêz³a opisu rt %llu\n"
+msgstr "wpis w krÃ³tkim katalogu %llu odwoÅ‚uje siÄ™ do i-wÄ™zÅ‚a opisu rt %llu\n"
 
 #: ../repair/dir.c:168
 #, c-format
 msgid "entry in shortform dir %llu references user quota inode %llu\n"
-msgstr "wpis w krótkim katalogu %llu odwo³uje siê do i-wêz³a limitu u¿ytkownika %llu\n"
+msgstr "wpis w krÃ³tkim katalogu %llu odwoÅ‚uje siÄ™ do i-wÄ™zÅ‚a limitu uÅ¼ytkownika %llu\n"
 
 #: ../repair/dir.c:173
 #, c-format
 msgid "entry in shortform dir %llu references group quota inode %llu\n"
-msgstr "wpis w krótkim katalogu %llu odwo³uje siê do i-wêz³a limitu grupy %llu\n"
+msgstr "wpis w krÃ³tkim katalogu %llu odwoÅ‚uje siÄ™ do i-wÄ™zÅ‚a limitu grupy %llu\n"
 
 #: ../repair/dir.c:193
 #, c-format
 msgid "entry references free inode %llu in shortform directory %llu\n"
-msgstr "wpis odwo³uje siê do wolnego i-wêz³a %llu w krótkim katalogu %llu\n"
+msgstr "wpis odwoÅ‚uje siÄ™ do wolnego i-wÄ™zÅ‚a %llu w krÃ³tkim katalogu %llu\n"
 
 #: ../repair/dir.c:212
 #, c-format
 msgid "entry references non-existent inode %llu in shortform dir %llu\n"
-msgstr "wpis odwo³uje siê do nie istniej±cego i-wêz³a %llu w krótkim katalogu %llu\n"
+msgstr "wpis odwoÅ‚uje siÄ™ do nie istniejÄ…cego i-wÄ™zÅ‚a %llu w krÃ³tkim katalogu %llu\n"
 
 #: ../repair/dir.c:236 ../repair/dir2.c:982
 #, c-format
 msgid "zero length entry in shortform dir %llu, resetting to %d\n"
-msgstr "wpis zerowej d³ugo¶ci w krótkim katalogu %llu, przestawiono na %d\n"
+msgstr "wpis zerowej dÅ‚ugoÅ›ci w krÃ³tkim katalogu %llu, przestawiono na %d\n"
 
 #: ../repair/dir.c:241 ../repair/dir2.c:988
 #, c-format
 msgid "zero length entry in shortform dir %llu, would set to %d\n"
-msgstr "wpis zerowej d³ugo¶ci w krótkim katalogu %llu, zosta³by przestawiony na %d\n"
+msgstr "wpis zerowej dÅ‚ugoÅ›ci w krÃ³tkim katalogu %llu, zostaÅ‚by przestawiony na %d\n"
 
 #: ../repair/dir.c:246
 #, c-format
 msgid "zero length entry in shortform dir %llu, "
-msgstr "wpis zerowej d³ugo¶ci w krótkim katalogu %llu, "
+msgstr "wpis zerowej dÅ‚ugoÅ›ci w krÃ³tkim katalogu %llu, "
 
 #: ../repair/dir.c:249 ../repair/dir.c:292 ../repair/dir2.c:1041
 #, c-format
 msgid "junking %d entries\n"
-msgstr "wyrzucono %d wpisów\n"
+msgstr "wyrzucono %d wpisÃ³w\n"
 
 #: ../repair/dir.c:252 ../repair/dir.c:301 ../repair/dir2.c:1050
 #, c-format
 msgid "would junk %d entries\n"
-msgstr "%d wpisów zosta³oby wyrzuconych\n"
+msgstr "%d wpisÃ³w zostaÅ‚oby wyrzuconych\n"
 
 #: ../repair/dir.c:270 ../repair/dir2.c:1018
 #, c-format
 msgid "size of last entry overflows space left in in shortform dir %llu, "
-msgstr "rozmiar ostatniego wpisu przekracza miejsce pozosta³e w krótkim katalogu %llu, "
+msgstr "rozmiar ostatniego wpisu przekracza miejsce pozostaÅ‚e w krÃ³tkim katalogu %llu, "
 
 #: ../repair/dir.c:273 ../repair/dir2.c:1022
 #, c-format
@@ -6394,12 +6394,12 @@ msgstr "przestawiono na %d\n"
 #: ../repair/dir.c:278 ../repair/dir2.c:1027
 #, c-format
 msgid "would reset to %d\n"
-msgstr "zosta³by przestawiony na %d\n"
+msgstr "zostaÅ‚by przestawiony na %d\n"
 
 #: ../repair/dir.c:283 ../repair/dir2.c:1031
 #, c-format
 msgid "size of entry #%d overflows space left in in shortform dir %llu\n"
-msgstr "rozmiar wpisu #%d przekracza miejsce pozosta³e w krótkim katalogu %llu\n"
+msgstr "rozmiar wpisu #%d przekracza miejsce pozostaÅ‚e w krÃ³tkim katalogu %llu\n"
 
 #: ../repair/dir.c:288 ../repair/dir2.c:1037
 #, c-format
@@ -6409,168 +6409,168 @@ msgstr "wyrzucono wpis #%d\n"
 #: ../repair/dir.c:297 ../repair/dir2.c:1046
 #, c-format
 msgid "would junk entry #%d\n"
-msgstr "wpis #%d zosta³by wyrzucony\n"
+msgstr "wpis #%d zostaÅ‚by wyrzucony\n"
 
 #: ../repair/dir.c:320 ../repair/dir2.c:1068
 #, c-format
 msgid "entry contains illegal character in shortform dir %llu\n"
-msgstr "wpis zawiera niedozwolony znak w krótkim katalogu %llu\n"
+msgstr "wpis zawiera niedozwolony znak w krÃ³tkim katalogu %llu\n"
 
 #: ../repair/dir.c:374 ../repair/dir2.c:1132
 #, c-format
 msgid "junking entry \"%s\" in directory inode %llu\n"
-msgstr "wyrzucono wpis \"%s\" w i-wê¼le katalogu %llu\n"
+msgstr "wyrzucono wpis \"%s\" w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:378 ../repair/dir2.c:1136
 #, c-format
 msgid "would have junked entry \"%s\" in directory inode %llu\n"
-msgstr "wpis \"%s\" w i-wê¼le katalogu %llu zosta³by wyrzucony\n"
+msgstr "wpis \"%s\" w i-wÄ™Åºle katalogu %llu zostaÅ‚by wyrzucony\n"
 
 #: ../repair/dir.c:404 ../repair/dir2.c:1163
 #, c-format
 msgid "would have corrected entry count in directory %llu from %d to %d\n"
-msgstr "liczba wpisów w katalogu %llu zosta³aby poprawiona z %d na %d\n"
+msgstr "liczba wpisÃ³w w katalogu %llu zostaÅ‚aby poprawiona z %d na %d\n"
 
 #: ../repair/dir.c:408 ../repair/dir2.c:1167
 #, c-format
 msgid "corrected entry count in directory %llu, was %d, now %d\n"
-msgstr "poprawiono liczbê wpisów w katalogu %llu - by³o %d, jest %d\n"
+msgstr "poprawiono liczbÄ™ wpisÃ³w w katalogu %llu - byÅ‚o %d, jest %d\n"
 
 #: ../repair/dir.c:419 ../repair/dir2.c:1196
 #, c-format
 msgid "would have corrected directory %llu size from %lld to %lld\n"
-msgstr "rozmiar katalogu %llu zosta³by poprawiony z %lld na %lld\n"
+msgstr "rozmiar katalogu %llu zostaÅ‚by poprawiony z %lld na %lld\n"
 
 #: ../repair/dir.c:424 ../repair/dir2.c:1202
 #, c-format
 msgid "corrected directory %llu size, was %lld, now %lld\n"
-msgstr "poprawiono rozmiar katalogu %llu - by³o %lld, jest %lld\n"
+msgstr "poprawiono rozmiar katalogu %llu - byÅ‚o %lld, jest %lld\n"
 
 #: ../repair/dir.c:446 ../repair/dir2.c:1244
 #, c-format
 msgid "bogus .. inode number (%llu) in directory inode %llu, "
-msgstr "b³êdny numer i-wêz³a .. (%llu) w i-wê¼le katalogu %llu, "
+msgstr "bÅ‚Ä™dny numer i-wÄ™zÅ‚a .. (%llu) w i-wÄ™Åºle katalogu %llu, "
 
 #: ../repair/dir.c:449 ../repair/dir.c:483 ../repair/dir2.c:1249
 #: ../repair/dir2.c:1284
 msgid "clearing inode number\n"
-msgstr "wyczyszczono numer i-wêz³a\n"
+msgstr "wyczyszczono numer i-wÄ™zÅ‚a\n"
 
 #: ../repair/dir.c:455 ../repair/dir.c:489 ../repair/dir2.c:1255
 #: ../repair/dir2.c:1290
 msgid "would clear inode number\n"
-msgstr "numer i-wêz³a zosta³by wyczyszczony\n"
+msgstr "numer i-wÄ™zÅ‚a zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/dir.c:463 ../repair/dir2.c:1262
 #, c-format
 msgid "corrected root directory %llu .. entry, was %llu, now %llu\n"
-msgstr "poprawiono wpis .. g³ównego katalogu %llu - by³o %llu, jest %llu\n"
+msgstr "poprawiono wpis .. gÅ‚Ã³wnego katalogu %llu - byÅ‚o %llu, jest %llu\n"
 
 #: ../repair/dir.c:471 ../repair/dir2.c:1270
 #, c-format
 msgid "would have corrected root directory %llu .. entry from %llu to %llu\n"
-msgstr "wpis .. g³ównego katalogu %llu zosta³by poprawiony z %llu na %llu\n"
+msgstr "wpis .. gÅ‚Ã³wnego katalogu %llu zostaÅ‚by poprawiony z %llu na %llu\n"
 
 #: ../repair/dir.c:480
 #, c-format
 msgid "bad .. entry in dir ino %llu, points to self, "
-msgstr "b³êdny wpis .. w i-wê¼le katalogu %llu, wskazuje na siebie, "
+msgstr "bÅ‚Ä™dny wpis .. w i-wÄ™Åºle katalogu %llu, wskazuje na siebie, "
 
 #: ../repair/dir.c:528
 #, c-format
 msgid "bad range claimed [%d, %d) in da block\n"
-msgstr "b³êdny przedzia³ [%d, %d) przypisany w bloku da\n"
+msgstr "bÅ‚Ä™dny przedziaÅ‚ [%d, %d) przypisany w bloku da\n"
 
 #: ../repair/dir.c:535
 #, c-format
 msgid "byte range end [%d %d) in da block larger than blocksize %d\n"
-msgstr "koniec przedzia³u bajtów [%d %d) w bloku da wiêkszy ni¿ rozmiar bloku %d\n"
+msgstr "koniec przedziaÅ‚u bajtÃ³w [%d %d) w bloku da wiÄ™kszy niÅ¼ rozmiar bloku %d\n"
 
 #: ../repair/dir.c:542
 #, c-format
 msgid "multiply claimed byte %d in da block\n"
-msgstr "wielokrotnie u¿yty bajt %d w bloku da\n"
+msgstr "wielokrotnie uÅ¼yty bajt %d w bloku da\n"
 
 #: ../repair/dir.c:572
 #, c-format
 msgid "hole (start %d, len %d) out of range, block %d, dir ino %llu\n"
-msgstr "dziura (pocz±tek %d, d³ugo¶æ %d) poza zakresem, blok %d, i-wêze³ katalogu %llu\n"
+msgstr "dziura (poczÄ…tek %d, dÅ‚ugoÅ›Ä‡ %d) poza zakresem, blok %d, i-wÄ™zeÅ‚ katalogu %llu\n"
 
 #: ../repair/dir.c:583
 #, c-format
 msgid "hole claims used byte %d, block %d, dir ino %llu\n"
-msgstr "dziura odwo³uje siê do u¿ywanego bajtu %d, blok %d, i-wêze³ katalogu %llu\n"
+msgstr "dziura odwoÅ‚uje siÄ™ do uÅ¼ywanego bajtu %d, blok %d, i-wÄ™zeÅ‚ katalogu %llu\n"
 
 #: ../repair/dir.c:698
 #, c-format
 msgid "- derived hole value %d, saw %d, block %d, dir ino %llu\n"
-msgstr "- wyprowadzona warto¶æ dziury %d, widziano %d, blok %d, i-wêze³ katalogu %llu\n"
+msgstr "- wyprowadzona wartoÅ›Ä‡ dziury %d, widziano %d, blok %d, i-wÄ™zeÅ‚ katalogu %llu\n"
 
 #: ../repair/dir.c:717
 #, c-format
 msgid "- derived hole (base %d, size %d) in block %d, dir inode %llu not found\n"
-msgstr "- wyprowadzona dziura (podstawa %d, rozmiar %d) w bloku %d, i-wêze³ katalogu %llu nie znaleziona\n"
+msgstr "- wyprowadzona dziura (podstawa %d, rozmiar %d) w bloku %d, i-wÄ™zeÅ‚ katalogu %llu nie znaleziona\n"
 
 #: ../repair/dir.c:793 ../repair/dir.c:971 ../repair/phase6.c:1198
 #: ../repair/phase6.c:1566
 #, c-format
 msgid "can't read block %u (fsbno %llu) for directory inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku %u (fsbno %llu) dla i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku %u (fsbno %llu) dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:797
 #, c-format
 msgid "can't read block %u (fsbno %llu) for attrbute fork of inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku %u (fsbno %llu) dla ga³êzi atrybutów i-wêz³a %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku %u (fsbno %llu) dla gaÅ‚Ä™zi atrybutÃ³w i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/dir.c:806 ../repair/dir.c:981 ../repair/phase6.c:1208
 #, c-format
 msgid "bad dir/attr magic number in inode %llu, file bno = %u, fsbno = %llu\n"
-msgstr "b³êdna liczba magiczna katalogu/atrybutu w i-wê¼le %llu, bno pliku = %u, fsbno = %llu\n"
+msgstr "bÅ‚Ä™dna liczba magiczna katalogu/atrybutu w i-wÄ™Åºle %llu, bno pliku = %u, fsbno = %llu\n"
 
 #: ../repair/dir.c:814 ../repair/dir2.c:333
 #, c-format
 msgid "bad record count in inode %llu, count = %d, max = %d\n"
-msgstr "b³êdna liczba rekordów w i-wê¼le %llu, liczba = %d, maksimum = %d\n"
+msgstr "bÅ‚Ä™dna liczba rekordÃ³w w i-wÄ™Åºle %llu, liczba = %d, maksimum = %d\n"
 
 #: ../repair/dir.c:833 ../repair/dir2.c:348
 #, c-format
 msgid "bad directory btree for directory inode %llu\n"
-msgstr "b³êdne b-drzewo katalogu dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dne b-drzewo katalogu dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:837
 #, c-format
 msgid "bad attribute fork btree for inode %llu\n"
-msgstr "b³êdne b-drzewo ga³êzi atrybutów dla i-wêz³a %llu\n"
+msgstr "bÅ‚Ä™dne b-drzewo gaÅ‚Ä™zi atrybutÃ³w dla i-wÄ™zÅ‚a %llu\n"
 
 #: ../repair/dir.c:891
 #, c-format
 msgid "release_da_cursor_int got unexpected non-null bp, dabno = %u\n"
-msgstr "release_da_cursor_int otrzyma³o nieoczekiwany niepusty bp, dabno = %u\n"
+msgstr "release_da_cursor_int otrzymaÅ‚o nieoczekiwany niepusty bp, dabno = %u\n"
 
 #: ../repair/dir.c:952 ../repair/dir.c:997
 #, c-format
 msgid "bmap of block #%u of inode %llu failed\n"
-msgstr "bmap bloku #%u i-wêz³a %llu nie powiod³o siê\n"
+msgstr "bmap bloku #%u i-wÄ™zÅ‚a %llu nie powiodÅ‚o siÄ™\n"
 
 #: ../repair/dir.c:1043
 #, c-format
 msgid "directory/attribute block used/count inconsistency - %d/%hu\n"
-msgstr "niespójno¶æ warto¶ci used/count bloku katalogu/atrybutu - %d/%hu\n"
+msgstr "niespÃ³jnoÅ›Ä‡ wartoÅ›ci used/count bloku katalogu/atrybutu - %d/%hu\n"
 
 #: ../repair/dir.c:1053 ../repair/dir2.c:471
 #, c-format
 msgid "directory/attribute block hashvalue inconsistency, expected > %u / saw %u\n"
-msgstr "niespójno¶æ warto¶ci hasza bloku katalogu/atrybutu - oczekiwano > %u, widziano %u\n"
+msgstr "niespÃ³jnoÅ›Ä‡ wartoÅ›ci hasza bloku katalogu/atrybutu - oczekiwano > %u, widziano %u\n"
 
 #: ../repair/dir.c:1060 ../repair/dir2.c:478
 #, c-format
 msgid "bad directory/attribute forward block pointer, expected 0, saw %u\n"
-msgstr "b³êdny wska¼nik bloku w przód katalogu/atrybutu - oczekiwano 0, widziano %u\n"
+msgstr "bÅ‚Ä™dny wskaÅºnik bloku w przÃ³d katalogu/atrybutu - oczekiwano 0, widziano %u\n"
 
 #: ../repair/dir.c:1066
 #, c-format
 msgid "bad directory block in dir ino %llu\n"
-msgstr "b³êdny blok katalogu w i-wê¼le katalogu %llu\n"
+msgstr "bÅ‚Ä™dny blok katalogu w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:1096
 #, c-format
@@ -6578,8 +6578,8 @@ msgid ""
 "correcting bad hashval in non-leaf dir/attr block\n"
 "\tin (level %d) in inode %llu.\n"
 msgstr ""
-"poprawiono b³êdne hashval w bloku katalogu/atrybutu nie bêd±cego li¶ciem\n"
-"\tw i-wê¼le (poziomu %d) %llu.\n"
+"poprawiono bÅ‚Ä™dne hashval w bloku katalogu/atrybutu nie bÄ™dÄ…cego liÅ›ciem\n"
+"\tw i-wÄ™Åºle (poziomu %d) %llu.\n"
 
 #: ../repair/dir.c:1104
 #, c-format
@@ -6587,38 +6587,38 @@ msgid ""
 "would correct bad hashval in non-leaf dir/attr block\n"
 "\tin (level %d) in inode %llu.\n"
 msgstr ""
-"b³êdne hashval zosta³oby poprawione w bloku katalogu/atrybutu nie bêd±cego li¶ciem\n"
-"\tw i-wê¼le (poziomu %d) %llu.\n"
+"bÅ‚Ä™dne hashval zostaÅ‚oby poprawione w bloku katalogu/atrybutu nie bÄ™dÄ…cego liÅ›ciem\n"
+"\tw i-wÄ™Åºle (poziomu %d) %llu.\n"
 
 #: ../repair/dir.c:1242 ../repair/dir2.c:642
 #, c-format
 msgid "can't get map info for block %u of directory inode %llu\n"
-msgstr "nie mo¿na uzyskaæ informacji o mapie dla bloku %u i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na uzyskaÄ‡ informacji o mapie dla bloku %u i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:1251
 #, c-format
 msgid "can't read block %u (%llu) for directory inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku %u (%llu) dla i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku %u (%llu) dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:1264
 #, c-format
 msgid "bad magic number %x in block %u (%llu) for directory inode %llu\n"
-msgstr "b³êdna liczba magiczna %x w bloku %u (%llu) dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dna liczba magiczna %x w bloku %u (%llu) dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:1272
 #, c-format
 msgid "bad back pointer in block %u (%llu) for directory inode %llu\n"
-msgstr "b³êdny wska¼nik wstecz w bloku %u (%llu) dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dny wskaÅºnik wstecz w bloku %u (%llu) dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:1278
 #, c-format
 msgid "entry count %d too large in block %u (%llu) for directory inode %llu\n"
-msgstr "liczba wpisów %d zbyt du¿a w bloku %u (%llu) dla i-wêz³a katalogu %llu\n"
+msgstr "liczba wpisÃ³w %d zbyt duÅ¼a w bloku %u (%llu) dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:1285
 #, c-format
 msgid "bad level %d in block %u (%llu) for directory inode %llu\n"
-msgstr "b³êdny poziom %d w bloku %u (%llu) dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dny poziom %d w bloku %u (%llu) dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:1343
 #, c-format
@@ -6626,8 +6626,8 @@ msgid ""
 "correcting bad hashval in interior dir/attr block\n"
 "\tin (level %d) in inode %llu.\n"
 msgstr ""
-"poprawiono b³êdne hashval w wewnêtrznym bloku katalogu/atrybutu\n"
-"\tw i-wê¼le (poziomu %d) %llu.\n"
+"poprawiono bÅ‚Ä™dne hashval w wewnÄ™trznym bloku katalogu/atrybutu\n"
+"\tw i-wÄ™Åºle (poziomu %d) %llu.\n"
 
 #: ../repair/dir.c:1351
 #, c-format
@@ -6635,168 +6635,168 @@ msgid ""
 "would correct bad hashval in interior dir/attr block\n"
 "\tin (level %d) in inode %llu.\n"
 msgstr ""
-"b³êdne hashval zosta³oby poprawione w wewnêtrznym bloku katalogu/atrybutu\n"
-"\tw i-wê¼le (poziomu %d) %llu.\n"
+"bÅ‚Ä™dne hashval zostaÅ‚oby poprawione w wewnÄ™trznym bloku katalogu/atrybutu\n"
+"\tw i-wÄ™Åºle (poziomu %d) %llu.\n"
 
 #: ../repair/dir.c:1462
 #, c-format
 msgid "directory block header conflicts with used space in directory inode %llu\n"
-msgstr "nag³ówek bloku katalogu jest w konflikcie z u¿ytym miejscem w i-wê¼le katalogu %llu\n"
+msgstr "nagÅ‚Ã³wek bloku katalogu jest w konflikcie z uÅ¼ytym miejscem w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:1491
 #, c-format
 msgid "nameidx %d for entry #%d, bno %d, ino %llu > fs blocksize, deleting entry\n"
-msgstr "nameidx %d dla wpisu #%d, bno %d, i-wêze³ %llu > rozmiaru bloku fs, usuniêto wpis\n"
+msgstr "nameidx %d dla wpisu #%d, bno %d, i-wÄ™zeÅ‚ %llu > rozmiaru bloku fs, usuniÄ™to wpis\n"
 
 #: ../repair/dir.c:1528
 #, c-format
 msgid "nameidx %d, entry #%d, bno %d, ino %llu > fs blocksize, marking entry bad\n"
-msgstr "nameidx %d, wpis #%d, bno %d, i-wêze³ %llu > rozmiaru bloku fs, zaznaczono wpis jako b³êdny\n"
+msgstr "nameidx %d, wpis #%d, bno %d, i-wÄ™zeÅ‚ %llu > rozmiaru bloku fs, zaznaczono wpis jako bÅ‚Ä™dny\n"
 
 #: ../repair/dir.c:1543
 #, c-format
 msgid "nameidx %d, entry #%d, bno %d, ino %llu > fs blocksize, would delete entry\n"
-msgstr "nameidx %d, wpis #%d, bno %d, i-wêze³ %llu > rozmiaru bloku fs, wpis zosta³by usuniêty\n"
+msgstr "nameidx %d, wpis #%d, bno %d, i-wÄ™zeÅ‚ %llu > rozmiaru bloku fs, wpis zostaÅ‚by usuniÄ™ty\n"
 
 #: ../repair/dir.c:1580
 #, c-format
 msgid "invalid ino number %llu in dir ino %llu, entry #%d, bno %d\n"
-msgstr "nieprawid³owy numer i-wêz³a %llu w i-wê¼le katalogu %llu, wpis #%d, bno %d\n"
+msgstr "nieprawidÅ‚owy numer i-wÄ™zÅ‚a %llu w i-wÄ™Åºle katalogu %llu, wpis #%d, bno %d\n"
 
 #: ../repair/dir.c:1584 ../repair/dir.c:1600 ../repair/dir.c:1617
 #: ../repair/dir.c:1633 ../repair/dir.c:1650
 #, c-format
 msgid "\tclearing ino number in entry %d...\n"
-msgstr "\twyczyszczono numer i-wêz³a we wpisie %d...\n"
+msgstr "\twyczyszczono numer i-wÄ™zÅ‚a we wpisie %d...\n"
 
 #: ../repair/dir.c:1591 ../repair/dir.c:1608 ../repair/dir.c:1624
 #: ../repair/dir.c:1641 ../repair/dir.c:1658
 #, c-format
 msgid "\twould clear ino number in entry %d...\n"
-msgstr "\tnumer i-wêz³a we wpisie %d zosta³by wyczyszczony...\n"
+msgstr "\tnumer i-wÄ™zÅ‚a we wpisie %d zostaÅ‚by wyczyszczony...\n"
 
 #: ../repair/dir.c:1596
 #, c-format
 msgid "entry #%d, bno %d in directory %llu references realtime bitmap inode %llu\n"
-msgstr "wpis #%d, bno %d w katalogu %llu odwo³uje siê do i-wêz³a bitmapy realtime %llu\n"
+msgstr "wpis #%d, bno %d w katalogu %llu odwoÅ‚uje siÄ™ do i-wÄ™zÅ‚a bitmapy realtime %llu\n"
 
 #: ../repair/dir.c:1613
 #, c-format
 msgid "entry #%d, bno %d in directory %llu references realtime summary inode %llu\n"
-msgstr "wpis #%d, bno %d w katalogu %llu odwo³uje siê do i-wêz³a opisu realtime %llu\n"
+msgstr "wpis #%d, bno %d w katalogu %llu odwoÅ‚uje siÄ™ do i-wÄ™zÅ‚a opisu realtime %llu\n"
 
 #: ../repair/dir.c:1629
 #, c-format
 msgid "entry #%d, bno %d in directory %llu references user quota inode %llu\n"
-msgstr "wpis #%d, bno %d w katalogu %llu odwo³uje siê do i-wêz³a limitu u¿ytkownika %llu\n"
+msgstr "wpis #%d, bno %d w katalogu %llu odwoÅ‚uje siÄ™ do i-wÄ™zÅ‚a limitu uÅ¼ytkownika %llu\n"
 
 #: ../repair/dir.c:1646
 #, c-format
 msgid "entry #%d, bno %d in directory %llu references group quota inode %llu\n"
-msgstr "wpis #%d, bno %d w katalogu %llu odwo³uje siê do i-wêz³a limitu grupy %llu\n"
+msgstr "wpis #%d, bno %d w katalogu %llu odwoÅ‚uje siÄ™ do i-wÄ™zÅ‚a limitu grupy %llu\n"
 
 #: ../repair/dir.c:1683
 #, c-format
 msgid "entry references free inode %llu in directory %llu, will clear entry\n"
-msgstr "wpis odwo³uje siê do wolnego i-wêz³a %llu w katalogu %llu, zostanie wyczyszczony\n"
+msgstr "wpis odwoÅ‚uje siÄ™ do wolnego i-wÄ™zÅ‚a %llu w katalogu %llu, zostanie wyczyszczony\n"
 
 #: ../repair/dir.c:1691
 #, c-format
 msgid "entry references free inode %llu in directory %llu, would clear entry\n"
-msgstr "wpis odwo³uje siê do wolnego i-wêz³a %llu w katalogu %llu, zosta³by wyczyszczony\n"
+msgstr "wpis odwoÅ‚uje siÄ™ do wolnego i-wÄ™zÅ‚a %llu w katalogu %llu, zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/dir.c:1699
 #, c-format
 msgid "bad ino number %llu in dir ino %llu, entry #%d, bno %d\n"
-msgstr "b³êdny numer i-wêz³a %llu w i-wê¼le katalogu %llu, wpis #%d, bno %d\n"
+msgstr "bÅ‚Ä™dny numer i-wÄ™zÅ‚a %llu w i-wÄ™Åºle katalogu %llu, wpis #%d, bno %d\n"
 
 #: ../repair/dir.c:1702
 msgid "clearing inode number...\n"
-msgstr "wyczyszczono numer i-wêz³a...\n"
+msgstr "wyczyszczono numer i-wÄ™zÅ‚a...\n"
 
 #: ../repair/dir.c:1707
 msgid "would clear inode number...\n"
-msgstr "numer i-wêz³a zosta³by wyczyszczony\n"
+msgstr "numer i-wÄ™zÅ‚a zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/dir.c:1727
 #, c-format
 msgid "entry #%d, dir inode %llu, has zero-len name, deleting entry\n"
-msgstr "wpis #%d, i-wêze³ katalogu %llu ma nazwê zerowej d³ugo¶ci, usuniêto\n"
+msgstr "wpis #%d, i-wÄ™zeÅ‚ katalogu %llu ma nazwÄ™ zerowej dÅ‚ugoÅ›ci, usuniÄ™to\n"
 
 #: ../repair/dir.c:1765
 #, c-format
 msgid "entry #%d, dir inode %llu, has zero-len name, marking entry bad\n"
-msgstr "wpis #%d, i-wêze³ katalogu %llu ma nazwê zerowej d³ugo¶ci, zaznaczono jako b³êdny\n"
+msgstr "wpis #%d, i-wÄ™zeÅ‚ katalogu %llu ma nazwÄ™ zerowej dÅ‚ugoÅ›ci, zaznaczono jako bÅ‚Ä™dny\n"
 
 #: ../repair/dir.c:1778
 #, c-format
 msgid "bad size, entry #%d in dir inode %llu, block %u -- entry overflows block\n"
-msgstr "b³êdny rozmiar, wpis #%d w i-wê¼le katalogu %llu, blok %u - wpis wykracza poza blok\n"
+msgstr "bÅ‚Ä™dny rozmiar, wpis #%d w i-wÄ™Åºle katalogu %llu, blok %u - wpis wykracza poza blok\n"
 
 #: ../repair/dir.c:1789
 #, c-format
 msgid "dir entry slot %d in block %u conflicts with used space in dir inode %llu\n"
-msgstr "slot wpisu katalogu %d w bloku %u jest w konflikcie z u¿ytym miejscem w i-wê¼le katalogu %llu\n"
+msgstr "slot wpisu katalogu %d w bloku %u jest w konflikcie z uÅ¼ytym miejscem w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:1828
 #, c-format
 msgid "illegal name \"%s\" in directory inode %llu, entry will be cleared\n"
-msgstr "niedozwolona nazwa \"%s\" w i-wê¼le katalogu %llu, wpis zostanie wyczyszczony\n"
+msgstr "niedozwolona nazwa \"%s\" w i-wÄ™Åºle katalogu %llu, wpis zostanie wyczyszczony\n"
 
 #: ../repair/dir.c:1834
 #, c-format
 msgid "illegal name \"%s\" in directory inode %llu, entry would be cleared\n"
-msgstr "niedozwolona nazwa \"%s\" w i-wê¼le katalogu %llu, wpis zosta³by wyczyszczony\n"
+msgstr "niedozwolona nazwa \"%s\" w i-wÄ™Åºle katalogu %llu, wpis zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/dir.c:1844
 #, c-format
 msgid "\tmismatched hash value for entry \"%s\"\n"
-msgstr "\tniedopasowana warto¶æ hasza dla wpisu \"%s\"\n"
+msgstr "\tniedopasowana wartoÅ›Ä‡ hasza dla wpisu \"%s\"\n"
 
 #: ../repair/dir.c:1848
 #, c-format
 msgid "\t\tin directory inode %llu.  resetting hash value.\n"
-msgstr "\t\tw i-wê¼le katalogu %llu. Przestawiono warto¶æ hasza.\n"
+msgstr "\t\tw i-wÄ™Åºle katalogu %llu. Przestawiono wartoÅ›Ä‡ hasza.\n"
 
 #: ../repair/dir.c:1854
 #, c-format
 msgid "\t\tin directory inode %llu.  would reset hash value.\n"
-msgstr "\t\tw i-wê¼le katalogu %llu. Warto¶æ hasza zosta³aby przestawiona.\n"
+msgstr "\t\tw i-wÄ™Åºle katalogu %llu. WartoÅ›Ä‡ hasza zostaÅ‚aby przestawiona.\n"
 
 #: ../repair/dir.c:1884
 #, c-format
 msgid "\tbad hash ordering for entry \"%s\"\n"
-msgstr "\tb³êdny porz±dek hasza dla wpisu \"%s\"\n"
+msgstr "\tbÅ‚Ä™dny porzÄ…dek hasza dla wpisu \"%s\"\n"
 
 #: ../repair/dir.c:1888
 #, c-format
 msgid "\t\tin directory inode %llu.  will clear entry\n"
-msgstr "\t\tw i-wê¼le katalogu %llu. Wpis zostanie wyczyszczony.\n"
+msgstr "\t\tw i-wÄ™Åºle katalogu %llu. Wpis zostanie wyczyszczony.\n"
 
 #: ../repair/dir.c:1895
 #, c-format
 msgid "\t\tin directory inode %llu.  would clear entry\n"
-msgstr "\t\tw i-wê¼le katalogu %llu. Wpis zosta³by wyczyszczony.\n"
+msgstr "\t\tw i-wÄ™Åºle katalogu %llu. Wpis zostaÅ‚by wyczyszczony.\n"
 
 #: ../repair/dir.c:1911
 #, c-format
 msgid "name \"%s\" (block %u, slot %d) conflicts with used space in dir inode %llu\n"
-msgstr "nazwa \"%s\" (blok %u, slot %d) jest w konflikcie z u¿ytym miejscem w i-wê¼le katalogu %llu\n"
+msgstr "nazwa \"%s\" (blok %u, slot %d) jest w konflikcie z uÅ¼ytym miejscem w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:1918
 #, c-format
 msgid "will clear entry \"%s\" (#%d) in directory inode %llu\n"
-msgstr "wpis \"%s\" (#%d) zostanie wyczyszczony w i-wê¼le katalogu %llu\n"
+msgstr "wpis \"%s\" (#%d) zostanie wyczyszczony w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:1922
 #, c-format
 msgid "would clear entry \"%s\" (#%d)in directory inode %llu\n"
-msgstr "wpis \"%s\" (#%d) zosta³by wyczyszczony w i-wê¼le katalogu %llu\n"
+msgstr "wpis \"%s\" (#%d) zostaÅ‚by wyczyszczony w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:1958
 #, c-format
 msgid "bad .. entry in dir ino %llu, points to self"
-msgstr "b³êdny wpis .. w i-wê¼le katalogu %llu, wskazuje na siebie"
+msgstr "bÅ‚Ä™dny wpis .. w i-wÄ™Åºle katalogu %llu, wskazuje na siebie"
 
 #: ../repair/dir.c:1962 ../repair/dir.c:2059
 msgid "will clear entry\n"
@@ -6804,97 +6804,97 @@ msgstr "wpis zostanie wyczyszczony\n"
 
 #: ../repair/dir.c:1967 ../repair/dir.c:2063 ../repair/dir2.c:1633
 msgid "would clear entry\n"
-msgstr "wpis zosta³by wyczyszczony\n"
+msgstr "wpis zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/dir.c:1977
 #, c-format
 msgid "correcting .. entry in root inode %llu, was %llu\n"
-msgstr "poprawiono wpis .. w g³ównym i-wê¼le %llu, by³o %llu\n"
+msgstr "poprawiono wpis .. w gÅ‚Ã³wnym i-wÄ™Åºle %llu, byÅ‚o %llu\n"
 
 #: ../repair/dir.c:1984
 #, c-format
 msgid "bad .. entry (%llu) in root inode %llu should be %llu\n"
-msgstr "b³êdny wpis .. (%llu) w g³ównym i-wê¼le %llu, powinno byæ %llu\n"
+msgstr "bÅ‚Ä™dny wpis .. (%llu) w gÅ‚Ã³wnym i-wÄ™Åºle %llu, powinno byÄ‡ %llu\n"
 
 #: ../repair/dir.c:2001
 #, c-format
 msgid "multiple .. entries in directory inode %llu, will clear second entry\n"
-msgstr "wiele wpisów .. w i-wê¼le katalogu %llu, drugi wpis zostanie wyczyszczony\n"
+msgstr "wiele wpisÃ³w .. w i-wÄ™Åºle katalogu %llu, drugi wpis zostanie wyczyszczony\n"
 
 #: ../repair/dir.c:2007
 #, c-format
 msgid "multiple .. entries in directory inode %llu, would clear second entry\n"
-msgstr "wiele wpisów .. w i-wê¼le katalogu %llu, drugi wpis zosta³by wyczyszczony\n"
+msgstr "wiele wpisÃ³w .. w i-wÄ™Åºle katalogu %llu, drugi wpis zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/dir.c:2020
 #, c-format
 msgid ". in directory inode %llu has wrong value (%llu), fixing entry...\n"
-msgstr ". w i-wê¼le katalogu %llu ma niepoprawn± warto¶æ (%llu), poprawiono wpis...\n"
+msgstr ". w i-wÄ™Åºle katalogu %llu ma niepoprawnÄ… wartoÅ›Ä‡ (%llu), poprawiono wpis...\n"
 
 #: ../repair/dir.c:2027
 #, c-format
 msgid ". in directory inode %llu has wrong value (%llu)\n"
-msgstr ". w i-wê¼le katalogu %llu ma niepoprawn± warto¶æ (%llu)\n"
+msgstr ". w i-wÄ™Åºle katalogu %llu ma niepoprawnÄ… wartoÅ›Ä‡ (%llu)\n"
 
 #: ../repair/dir.c:2033
 #, c-format
 msgid "multiple . entries in directory inode %llu\n"
-msgstr "wiele wpisów . w i-wê¼le katalogu %llu\n"
+msgstr "wiele wpisÃ³w . w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:2040
 #, c-format
 msgid "will clear one . entry in directory inode %llu\n"
-msgstr "jeden wpis . w i-wê¼le katalogu %llu zostanie wyczyszczony\n"
+msgstr "jeden wpis . w i-wÄ™Åºle katalogu %llu zostanie wyczyszczony\n"
 
 #: ../repair/dir.c:2046
 #, c-format
 msgid "would clear one . entry in directory inode %llu\n"
-msgstr "jeden wpis . w i-wê¼le katalogu %llu zosta³by wyczyszczony\n"
+msgstr "jeden wpis . w i-wÄ™Åºle katalogu %llu zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/dir.c:2056
 #, c-format
 msgid "entry \"%s\" in directory inode %llu points to self, "
-msgstr "wpis \"%s\" w i-wê¼le katalogu %llu wskazuje na siebie, "
+msgstr "wpis \"%s\" w i-wÄ™Åºle katalogu %llu wskazuje na siebie, "
 
 #: ../repair/dir.c:2081
 #, c-format
 msgid "- resetting first used heap value from %d to %d in block %u of dir ino %llu\n"
-msgstr "- przestawiono pierwsz± u¿ywan± warto¶æ sterty z %d na %d w bloku %u i-wêz³a katalogu %llu\n"
+msgstr "- przestawiono pierwszÄ… uÅ¼ywanÄ… wartoÅ›Ä‡ sterty z %d na %d w bloku %u i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:2089
 #, c-format
 msgid "- would reset first used value from %d to %d in block %u of dir ino %llu\n"
-msgstr "- pierwsza u¿ywana warto¶æ zosta³aby przestawiona z %d na %d w bloku %u i-wêz³a katalogu %llu\n"
+msgstr "- pierwsza uÅ¼ywana wartoÅ›Ä‡ zostaÅ‚aby przestawiona z %d na %d w bloku %u i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:2099
 #, c-format
 msgid "- resetting namebytes cnt from %d to %d in block %u of dir inode %llu\n"
-msgstr "- przestawiono liczbê bajtów nazwy z %d na %d w bloku %u i-wêz³a katalogu %llu\n"
+msgstr "- przestawiono liczbÄ™ bajtÃ³w nazwy z %d na %d w bloku %u i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:2107
 #, c-format
 msgid "- would reset namebytes cnt from %d to %d in block %u of dir inode %llu\n"
-msgstr "- liczba bajtów nazwy zosta³aby przestawiona z %d na %d w bloku %u i-wêz³a katalogu %llu\n"
+msgstr "- liczba bajtÃ³w nazwy zostaÅ‚aby przestawiona z %d na %d w bloku %u i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:2142
 #, c-format
 msgid "- found unexpected lost holes in block %u, dir inode %llu\n"
-msgstr "- znaleziono nieoczekiwane utracone dziury w bloku %u, i-wê¼le katalogu %llu\n"
+msgstr "- znaleziono nieoczekiwane utracone dziury w bloku %u, i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:2150
 #, c-format
 msgid "- hole info non-optimal in block %u, dir inode %llu\n"
-msgstr "- nieoptymalna informacja o dziurze w bloku %u, i-wê¼le katalogu %llu\n"
+msgstr "- nieoptymalna informacja o dziurze w bloku %u, i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:2157
 #, c-format
 msgid "- hole info incorrect in block %u, dir inode %llu\n"
-msgstr "- niepoprawna informacja o dziurze w bloku %u, i-wê¼le katalogu %llu\n"
+msgstr "- niepoprawna informacja o dziurze w bloku %u, i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:2168
 #, c-format
 msgid "- existing hole info for block %d, dir inode %llu (base, size) - \n"
-msgstr "- istniej±ca informacja o dziurze dla bloku %d, i-wêz³a katalogu %llu (podstawa, rozmiar) - \n"
+msgstr "- istniejÄ…ca informacja o dziurze dla bloku %d, i-wÄ™zÅ‚a katalogu %llu (podstawa, rozmiar) - \n"
 
 #: ../repair/dir.c:2176
 #, c-format
@@ -6904,72 +6904,72 @@ msgstr "- flaga dziur = %d\n"
 #: ../repair/dir.c:2182
 #, c-format
 msgid "- compacting block %u in dir inode %llu\n"
-msgstr "- zagêszczono blok %u w i-wê¼le katalogu %llu\n"
+msgstr "- zagÄ™szczono blok %u w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:2223
 #, c-format
 msgid "not enough space in block %u of dir inode %llu for all entries\n"
-msgstr "zbyt ma³o miejsca dla wszystkich wpisów w bloku %u i-wêz³a katalogu %llu\n"
+msgstr "zbyt maÅ‚o miejsca dla wszystkich wpisÃ³w w bloku %u i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:2291
 #, c-format
 msgid "- would compact block %u in dir inode %llu\n"
-msgstr "- bloku %u w i-wê¼le katalogu %llu zosta³by zagêszczony\n"
+msgstr "- bloku %u w i-wÄ™Åºle katalogu %llu zostaÅ‚by zagÄ™szczony\n"
 
 #: ../repair/dir.c:2353 ../repair/dir2.c:1815
 #, c-format
 msgid "can't map block %u for directory inode %llu\n"
-msgstr "nie mo¿na odwzorowaæ bloku %u dla i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odwzorowaÄ‡ bloku %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:2364
 #, c-format
 msgid "can't read file block %u (fsbno %llu, daddr %lld) for directory inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku pliku %u (fsbno %llu, daddr %lld) dla i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku pliku %u (fsbno %llu, daddr %lld) dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:2378 ../repair/dir.c:2639
 #, c-format
 msgid "bad directory leaf magic # %#x for dir ino %llu\n"
-msgstr "b³êdna liczba magiczna li¶cia katalogu %#x dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dna liczba magiczna liÅ›cia katalogu %#x dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:2417
 #, c-format
 msgid "bad sibling back pointer for directory block %u in directory inode %llu\n"
-msgstr "b³êdny wska¼nik wstecz dla bloku katalogu %u w i-wê¼le katalogu %llu\n"
+msgstr "bÅ‚Ä™dny wskaÅºnik wstecz dla bloku katalogu %u w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir.c:2449 ../repair/dir2.c:1892
 #, c-format
 msgid "bad hash path in directory %llu\n"
-msgstr "b³êdna ¶cie¿ka hasza w katalogu %llu\n"
+msgstr "bÅ‚Ä™dna Å›cieÅ¼ka hasza w katalogu %llu\n"
 
 #: ../repair/dir.c:2559
 #, c-format
 msgid "out of range internal directory block numbers (inode %llu)\n"
-msgstr "numery bloków wewnêtrznego katalogu spoza zakresu (i-wêze³ %llu)\n"
+msgstr "numery blokÃ³w wewnÄ™trznego katalogu spoza zakresu (i-wÄ™zeÅ‚ %llu)\n"
 
 #: ../repair/dir.c:2565
 #, c-format
 msgid "setting directory inode (%llu) size to %llu bytes, was %lld bytes\n"
-msgstr "ustawiono rozmiar i-wêz³a katalogu (%llu) na %llu bajtów, by³o %lld bajtów\n"
+msgstr "ustawiono rozmiar i-wÄ™zÅ‚a katalogu (%llu) na %llu bajtÃ³w, byÅ‚o %lld bajtÃ³w\n"
 
 #: ../repair/dir.c:2619
 #, c-format
 msgid "block 0 for directory inode %llu is missing\n"
-msgstr "brak bloku 0 dla i-wêz³a katalogu %llu\n"
+msgstr "brak bloku 0 dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:2626
 #, c-format
 msgid "can't read block 0 for directory inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku 0 dla i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku 0 dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:2662
 #, c-format
 msgid "clearing forw/back pointers for directory inode %llu\n"
-msgstr "wyczyszczono wska¼niki w przód/wstecz dla i-wêz³a katalogu %llu\n"
+msgstr "wyczyszczono wskaÅºniki w przÃ³d/wstecz dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir.c:2668
 #, c-format
 msgid "would clear forw/back pointers for directory inode %llu\n"
-msgstr "wska¼niki w przód/wstecz dla i-wêz³a katalogu %llu zosta³yby wyczyszczone\n"
+msgstr "wskaÅºniki w przÃ³d/wstecz dla i-wÄ™zÅ‚a katalogu %llu zostaÅ‚yby wyczyszczone\n"
 
 #: ../repair/dir.c:2733 ../repair/dir2.c:2097
 #, c-format
@@ -6984,55 +6984,55 @@ msgstr "brak wpisu .. dla katalogu %llu\n"
 #: ../repair/dir.c:2744 ../repair/dir2.c:2109
 #, c-format
 msgid "no .. entry for root directory %llu\n"
-msgstr "brak wpisu .. dla katalogu g³ównego %llu\n"
+msgstr "brak wpisu .. dla katalogu gÅ‚Ã³wnego %llu\n"
 
 #: ../repair/dir2.c:56
 #, c-format
 msgid "malloc failed (%u bytes) dir2_add_badlist:ino %llu\n"
-msgstr "malloc nie powiod³o siê (%u bajtów) w dir2_add_badlist:ino %llu\n"
+msgstr "malloc nie powiodÅ‚o siÄ™ (%u bajtÃ³w) w dir2_add_badlist:ino %llu\n"
 
 #: ../repair/dir2.c:97 ../repair/dir2.c:208 ../repair/dir2.c:244
 msgid "couldn't malloc dir2 buffer list\n"
-msgstr "nie mo¿na przydzieliæ listy bufora dir2\n"
+msgstr "nie moÅ¼na przydzieliÄ‡ listy bufora dir2\n"
 
 #: ../repair/dir2.c:124
 msgid "couldn't malloc dir2 buffer header\n"
-msgstr "nie mo¿na przydzieliæ nag³ówka bufora dir2\n"
+msgstr "nie moÅ¼na przydzieliÄ‡ nagÅ‚Ã³wka bufora dir2\n"
 
 #: ../repair/dir2.c:141
 msgid "couldn't malloc dir2 buffer data\n"
-msgstr "nie mo¿na przydzieliæ danych bufora dir2\n"
+msgstr "nie moÅ¼na przydzieliÄ‡ danych bufora dir2\n"
 
 #: ../repair/dir2.c:305 ../repair/dir2.c:653 ../repair/dir2.c:1697
 #: ../repair/phase6.c:2272
 #, c-format
 msgid "can't read block %u for directory inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku %u dla i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:315
 #, c-format
 msgid "found non-root LEAFN node in inode %llu bno = %u\n"
-msgstr "znaleziono nieg³ówny wêze³ LEAFN w i-wê¼le %llu bno = %u\n"
+msgstr "znaleziono niegÅ‚Ã³wny wÄ™zeÅ‚ LEAFN w i-wÄ™Åºle %llu bno = %u\n"
 
 #: ../repair/dir2.c:324
 #, c-format
 msgid "bad dir magic number 0x%x in inode %llu bno = %u\n"
-msgstr "b³êdna liczba magiczna katalogu 0x%x w i-wê¼le %llu bno = %u\n"
+msgstr "bÅ‚Ä™dna liczba magiczna katalogu 0x%x w i-wÄ™Åºle %llu bno = %u\n"
 
 #: ../repair/dir2.c:399
 #, c-format
 msgid "release_dir2_cursor_int got unexpected non-null bp, dabno = %u\n"
-msgstr "release_dir2_cursor_int otrzyma³ nieoczekiwany niezerowy bp, dabno = %u\n"
+msgstr "release_dir2_cursor_int otrzymaÅ‚ nieoczekiwany niezerowy bp, dabno = %u\n"
 
 #: ../repair/dir2.c:462
 #, c-format
 msgid "directory block used/count inconsistency - %d / %hu\n"
-msgstr "niespójno¶æ warto¶ci used/count bloku katalogu - %d / %hu\n"
+msgstr "niespÃ³jnoÅ›Ä‡ wartoÅ›ci used/count bloku katalogu - %d / %hu\n"
 
 #: ../repair/dir2.c:484
 #, c-format
 msgid "bad directory block in inode %llu\n"
-msgstr "b³êdny blok katalogu w i-wê¼le %llu\n"
+msgstr "bÅ‚Ä™dny blok katalogu w i-wÄ™Åºle %llu\n"
 
 #: ../repair/dir2.c:504
 #, c-format
@@ -7040,8 +7040,8 @@ msgid ""
 "correcting bad hashval in non-leaf dir block\n"
 "\tin (level %d) in inode %llu.\n"
 msgstr ""
-"poprawiono b³êdne hashval w bloku katalogu nie bêd±cego li¶ciem\n"
-"\tw i-wê¼le (poziomu %d) %llu.\n"
+"poprawiono bÅ‚Ä™dne hashval w bloku katalogu nie bÄ™dÄ…cego liÅ›ciem\n"
+"\tw i-wÄ™Åºle (poziomu %d) %llu.\n"
 
 #: ../repair/dir2.c:511
 #, c-format
@@ -7049,28 +7049,28 @@ msgid ""
 "would correct bad hashval in non-leaf dir block\n"
 "\tin (level %d) in inode %llu.\n"
 msgstr ""
-"b³êdne hashval w bloku katalogu nie bêd±cego li¶ciem zosta³oby poprawione\n"
-"\tw i-wê¼le (poziomu %d) %llu.\n"
+"bÅ‚Ä™dne hashval w bloku katalogu nie bÄ™dÄ…cego liÅ›ciem zostaÅ‚oby poprawione\n"
+"\tw i-wÄ™Åºle (poziomu %d) %llu.\n"
 
 #: ../repair/dir2.c:666
 #, c-format
 msgid "bad magic number %x in block %u for directory inode %llu\n"
-msgstr "b³êdna liczba magiczna %x w bloku %u dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dna liczba magiczna %x w bloku %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:674
 #, c-format
 msgid "bad back pointer in block %u for directory inode %llu\n"
-msgstr "b³êdny wska¼nik wstecz w bloku %u dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dny wskaÅºnik wstecz w bloku %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:680
 #, c-format
 msgid "entry count %d too large in block %u for directory inode %llu\n"
-msgstr "liczba wpisów %d zbyt du¿a w bloku %u dla i-wêz³a katalogu %llu\n"
+msgstr "liczba wpisÃ³w %d zbyt duÅ¼a w bloku %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:687
 #, c-format
 msgid "bad level %d in block %u for directory inode %llu\n"
-msgstr "b³êdny poziom %d w bloku %u dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dny poziom %d w bloku %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:730
 #, c-format
@@ -7078,8 +7078,8 @@ msgid ""
 "correcting bad hashval in interior dir block\n"
 "\tin (level %d) in inode %llu.\n"
 msgstr ""
-"poprawiono b³êdne hashval w wewnêtrznym bloku katalogu\n"
-"\tw i-wê¼le (poziomu %d) %llu.\n"
+"poprawiono bÅ‚Ä™dne hashval w wewnÄ™trznym bloku katalogu\n"
+"\tw i-wÄ™Åºle (poziomu %d) %llu.\n"
 
 #: ../repair/dir2.c:737
 #, c-format
@@ -7087,100 +7087,100 @@ msgid ""
 "would correct bad hashval in interior dir block\n"
 "\tin (level %d) in inode %llu.\n"
 msgstr ""
-"b³êdne hashval w wewnêtrznym bloku katalogu zosta³oby poprawione\n"
-"\tw i-wê¼le (poziomu %d) %llu.\n"
+"bÅ‚Ä™dne hashval w wewnÄ™trznym bloku katalogu zostaÅ‚oby poprawione\n"
+"\tw i-wÄ™Åºle (poziomu %d) %llu.\n"
 
 #: ../repair/dir2.c:771
 msgid "couldn't malloc dir2 shortform copy\n"
-msgstr "nie uda³o siê przydzieliæ krótkiej kopii dir2\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ krÃ³tkiej kopii dir2\n"
 
 #: ../repair/dir2.c:909
 msgid "current"
-msgstr "bie¿±cego i-wêz³a"
+msgstr "bieÅ¼Ä…cego i-wÄ™zÅ‚a"
 
 #: ../repair/dir2.c:912 ../repair/dir2.c:1435
 msgid "invalid"
-msgstr "nieprawid³owego i-wêz³a"
+msgstr "nieprawidÅ‚owego i-wÄ™zÅ‚a"
 
 #: ../repair/dir2.c:915 ../repair/dir2.c:1437
 msgid "realtime bitmap"
-msgstr "i-wêz³a bitmapy realtime"
+msgstr "i-wÄ™zÅ‚a bitmapy realtime"
 
 #: ../repair/dir2.c:918 ../repair/dir2.c:1439
 msgid "realtime summary"
-msgstr "i-wêz³a opisu realtime"
+msgstr "i-wÄ™zÅ‚a opisu realtime"
 
 #: ../repair/dir2.c:921 ../repair/dir2.c:1441
 msgid "user quota"
-msgstr "i-wêz³a limitów u¿ytkownika"
+msgstr "i-wÄ™zÅ‚a limitÃ³w uÅ¼ytkownika"
 
 #: ../repair/dir2.c:924 ../repair/dir2.c:1443
 msgid "group quota"
-msgstr "i-wêz³a limitów grupy"
+msgstr "i-wÄ™zÅ‚a limitÃ³w grupy"
 
 #: ../repair/dir2.c:958 ../repair/dir2.c:1452
 msgid "non-existent"
-msgstr "nie istniej±cego i-wêz³a"
+msgstr "nie istniejÄ…cego i-wÄ™zÅ‚a"
 
 #: ../repair/dir2.c:962
 #, c-format
 msgid "entry \"%*.*s\" in shortform directory %llu references %s inode %llu\n"
-msgstr "wpis \"%*.*s\" w krótkim katalogu %llu odwo³uje siê do %s %llu\n"
+msgstr "wpis \"%*.*s\" w krÃ³tkim katalogu %llu odwoÅ‚uje siÄ™ do %s %llu\n"
 
 #: ../repair/dir2.c:994
 #, c-format
 msgid "zero length entry in shortform dir %llu"
-msgstr "wpis zerowej d³ugo¶ci w krótkim katalogu %llu"
+msgstr "wpis zerowej dÅ‚ugoÅ›ci w krÃ³tkim katalogu %llu"
 
 #: ../repair/dir2.c:998
 #, c-format
 msgid ", junking %d entries\n"
-msgstr ", wyrzucono %d wpisów\n"
+msgstr ", wyrzucono %d wpisÃ³w\n"
 
 #: ../repair/dir2.c:1001
 #, c-format
 msgid ", would junk %d entries\n"
-msgstr ", %d wpisów zosta³oby wyrzucone\n"
+msgstr ", %d wpisÃ³w zostaÅ‚oby wyrzucone\n"
 
 #: ../repair/dir2.c:1075
 #, c-format
 msgid "entry contains offset out of order in shortform dir %llu\n"
-msgstr "wpis zawiera uszkodzony offset w krótkim katalogu %llu\n"
+msgstr "wpis zawiera uszkodzony offset w krÃ³tkim katalogu %llu\n"
 
 #: ../repair/dir2.c:1178
 #, c-format
 msgid "would have corrected i8 count in directory %llu from %d to %d\n"
-msgstr "liczba i8 zosta³aby poprawiona w katalogu %llu z %d na %d\n"
+msgstr "liczba i8 zostaÅ‚aby poprawiona w katalogu %llu z %d na %d\n"
 
 #: ../repair/dir2.c:1182
 #, c-format
 msgid "corrected i8 count in directory %llu, was %d, now %d\n"
-msgstr "poprawiono liczbê i8 w katalogu %llu - by³o %d, jest %d\n"
+msgstr "poprawiono liczbÄ™ i8 w katalogu %llu - byÅ‚o %d, jest %d\n"
 
 #: ../repair/dir2.c:1216
 #, c-format
 msgid "directory %llu offsets too high\n"
-msgstr "offsety zbyt du¿e w katalogu %llu\n"
+msgstr "offsety zbyt duÅ¼e w katalogu %llu\n"
 
 #: ../repair/dir2.c:1221
 #, c-format
 msgid "would have corrected entry offsets in directory %llu\n"
-msgstr "offsety wpisów w katalogu %llu zosta³yby poprawione\n"
+msgstr "offsety wpisÃ³w w katalogu %llu zostaÅ‚yby poprawione\n"
 
 #: ../repair/dir2.c:1225
 #, c-format
 msgid "corrected entry offsets in directory %llu\n"
-msgstr "poprawiono offsety wpisów w katalogu %llu\n"
+msgstr "poprawiono offsety wpisÃ³w w katalogu %llu\n"
 
 #: ../repair/dir2.c:1280
 #, c-format
 msgid "bad .. entry in directory inode %llu, points to self, "
-msgstr "b³êdny wpis .. w i-wê¼le katalogu %llu, wskazuje na siebie, "
+msgstr "bÅ‚Ä™dny wpis .. w i-wÄ™Åºle katalogu %llu, wskazuje na siebie, "
 
 #: ../repair/dir2.c:1393
 #, c-format
 msgid "corrupt block %u in directory inode %llu\n"
-msgstr "uszkodzony blok %u w i-wê¼le katalogu %llu\n"
+msgstr "uszkodzony blok %u w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir2.c:1396
 msgid "\twill junk block\n"
@@ -7188,42 +7188,42 @@ msgstr "\tblok zostanie wyrzucony\n"
 
 #: ../repair/dir2.c:1398
 msgid "\twould junk block\n"
-msgstr "\tblok zosta³by wyrzucony\n"
+msgstr "\tblok zostaÅ‚by wyrzucony\n"
 
 #: ../repair/dir2.c:1480
 #, c-format
 msgid "entry \"%*.*s\" at block %u offset %d in directory inode %llu references %s inode %llu\n"
-msgstr "wpis \"%*.*s\" w bloku %u offsecie %d w i-wê¼le katalogu %llu odwo³uje siê do %s %llu\n"
+msgstr "wpis \"%*.*s\" w bloku %u offsecie %d w i-wÄ™Åºle katalogu %llu odwoÅ‚uje siÄ™ do %s %llu\n"
 
 #: ../repair/dir2.c:1491
 #, c-format
 msgid "entry at block %u offset %d in directory inode %llu has 0 namelength\n"
-msgstr "wpis w bloku %u offsecie %d w i-wê¼le katalogu %llu ma zerow± d³ugo¶æ nazwy\n"
+msgstr "wpis w bloku %u offsecie %d w i-wÄ™Åºle katalogu %llu ma zerowÄ… dÅ‚ugoÅ›Ä‡ nazwy\n"
 
 #: ../repair/dir2.c:1503
 #, c-format
 msgid "\tclearing inode number in entry at offset %d...\n"
-msgstr "\twyczyszczono numer i-wêz³a we wpisie o offsecie %d...\n"
+msgstr "\twyczyszczono numer i-wÄ™zÅ‚a we wpisie o offsecie %d...\n"
 
 #: ../repair/dir2.c:1510
 #, c-format
 msgid "\twould clear inode number in entry at offset %d...\n"
-msgstr "\tnumer i-wêz³a we wpisie o offsecie %d zosta³by wyczyszczony...\n"
+msgstr "\tnumer i-wÄ™zÅ‚a we wpisie o offsecie %d zostaÅ‚by wyczyszczony...\n"
 
 #: ../repair/dir2.c:1523
 #, c-format
 msgid "entry at block %u offset %d in directory inode %llu has illegal name \"%*.*s\": "
-msgstr "wpis w bloku %u offsecie %d w i-wê¼le katalogu %llu ma niedozwolon± nazwê \"%*.*s\": "
+msgstr "wpis w bloku %u offsecie %d w i-wÄ™Åºle katalogu %llu ma niedozwolonÄ… nazwÄ™ \"%*.*s\": "
 
 #: ../repair/dir2.c:1553
 #, c-format
 msgid "bad .. entry in directory inode %llu, points to self: "
-msgstr "b³êdny wpis .. w i-wê¼le katalogu %llu, wskazuje na siebie: "
+msgstr "bÅ‚Ä™dny wpis .. w i-wÄ™Åºle katalogu %llu, wskazuje na siebie: "
 
 #: ../repair/dir2.c:1564
 #, c-format
 msgid "bad .. entry in root directory inode %llu, was %llu: "
-msgstr "b³êdny wpis w i-wê¼le g³ównego katalogu %llu, by³o %llu: "
+msgstr "bÅ‚Ä™dny wpis w i-wÄ™Åºle gÅ‚Ã³wnego katalogu %llu, byÅ‚o %llu: "
 
 #: ../repair/dir2.c:1569 ../repair/dir2.c:1601 ../repair/phase2.c:193
 #: ../repair/phase2.c:202 ../repair/phase2.c:211
@@ -7233,27 +7233,27 @@ msgstr "poprawiono\n"
 #: ../repair/dir2.c:1573 ../repair/dir2.c:1605 ../repair/phase2.c:195
 #: ../repair/phase2.c:204 ../repair/phase2.c:213
 msgid "would correct\n"
-msgstr "zosta³by poprawiony\n"
+msgstr "zostaÅ‚by poprawiony\n"
 
 #: ../repair/dir2.c:1584
 #, c-format
 msgid "multiple .. entries in directory inode %llu: "
-msgstr "wiele wpisów .. w i-wê¼le katalogu %llu: "
+msgstr "wiele wpisÃ³w .. w i-wÄ™Åºle katalogu %llu: "
 
 #: ../repair/dir2.c:1597
 #, c-format
 msgid "bad . entry in directory inode %llu, was %llu: "
-msgstr "b³êdny wpis . w i-wê¼le katalogu %llu, by³o %llu: "
+msgstr "bÅ‚Ä™dny wpis . w i-wÄ™Åºle katalogu %llu, byÅ‚o %llu: "
 
 #: ../repair/dir2.c:1609
 #, c-format
 msgid "multiple . entries in directory inode %llu: "
-msgstr "wiele wpisów . w i-wê¼le katalogu %llu: "
+msgstr "wiele wpisÃ³w . w i-wÄ™Åºle katalogu %llu: "
 
 #: ../repair/dir2.c:1619
 #, c-format
 msgid "entry \"%*.*s\" in directory inode %llu points to self: "
-msgstr "wpis \"%*.*s\" w i-wê¼le katalogu %llu wskazuje na siebie: "
+msgstr "wpis \"%*.*s\" w i-wÄ™Åºle katalogu %llu wskazuje na siebie: "
 
 #: ../repair/dir2.c:1631
 msgid "clearing entry\n"
@@ -7262,174 +7262,174 @@ msgstr "wyczyszczono wpis\n"
 #: ../repair/dir2.c:1645
 #, c-format
 msgid "bad bestfree table in block %u in directory inode %llu: "
-msgstr "b³êdna tablica bestfree w bloku %u w i-wê¼le katalogu %llu: "
+msgstr "bÅ‚Ä™dna tablica bestfree w bloku %u w i-wÄ™Åºle katalogu %llu: "
 
 #: ../repair/dir2.c:1648
 msgid "repairing table\n"
-msgstr "naprawiono tablicê\n"
+msgstr "naprawiono tablicÄ™\n"
 
 #: ../repair/dir2.c:1652
 msgid "would repair table\n"
-msgstr "tablica zosta³aby naprawiona\n"
+msgstr "tablica zostaÅ‚aby naprawiona\n"
 
 #: ../repair/dir2.c:1689
 #, c-format
 msgid "block %u for directory inode %llu is missing\n"
-msgstr "brak bloku %u dla i-wêz³a katalogu %llu\n"
+msgstr "brak bloku %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:1706
 #, c-format
 msgid "bad directory block magic # %#x in block %u for directory inode %llu\n"
-msgstr "b³êdna liczba magiczna bloku katalogu %#x w bloku %u dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dna liczba magiczna bloku katalogu %#x w bloku %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:1750
 #, c-format
 msgid "bad entry count in block %u of directory inode %llu\n"
-msgstr "b³êdna liczba wpisów w bloku %u i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dna liczba wpisÃ³w w bloku %u i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:1758
 #, c-format
 msgid "bad hash ordering in block %u of directory inode %llu\n"
-msgstr "b³êdna kolejno¶æ hasza w bloku %u i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dna kolejnoÅ›Ä‡ hasza w bloku %u i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:1767
 #, c-format
 msgid "bad stale count in block %u of directory inode %llu\n"
-msgstr "b³êdna liczba stale %u i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dna liczba stale %u i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:1825
 #, c-format
 msgid "can't read file block %u for directory inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku pliku %u dla i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku pliku %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:1836
 #, c-format
 msgid "bad directory leaf magic # %#x for directory inode %llu block %u\n"
-msgstr "b³êdna liczba magiczna li¶cia katalogu %#x dla i-wêz³a katalogu %llu bloku %u\n"
+msgstr "bÅ‚Ä™dna liczba magiczna liÅ›cia katalogu %#x dla i-wÄ™zÅ‚a katalogu %llu bloku %u\n"
 
 #: ../repair/dir2.c:1866
 #, c-format
 msgid "bad sibling back pointer for block %u in directory inode %llu\n"
-msgstr "b³êdny wska¼nik wstecz dla bloku %u w i-wê¼le katalogu %llu\n"
+msgstr "bÅ‚Ä™dny wskaÅºnik wstecz dla bloku %u w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/dir2.c:1996
 #, c-format
 msgid "block %llu for directory inode %llu is missing\n"
-msgstr "brak bloku %llu dla i-wêz³a katalogu %llu\n"
+msgstr "brak bloku %llu dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:2005
 #, c-format
 msgid "can't read block %llu for directory inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku %llu dla i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku %llu dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:2012
 #, c-format
 msgid "bad directory block magic # %#x in block %llu for directory inode %llu\n"
-msgstr "b³êdna liczba magiczna bloku katalogu %#x w bloku %llu dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dna liczba magiczna bloku katalogu %#x w bloku %llu dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/dir2.c:2090
 #, c-format
 msgid "bad size/format for directory %llu\n"
-msgstr "b³êdny rozmiar/format dla katalogu %llu\n"
+msgstr "bÅ‚Ä™dny rozmiar/format dla katalogu %llu\n"
 
 #: ../repair/incore.c:65
 msgid "couldn't allocate block map pointers\n"
-msgstr "nie uda³o siê przydzieliæ wska¼ników mapy bloków\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ wskaÅºnikÃ³w mapy blokÃ³w\n"
 
 #: ../repair/incore.c:68
 msgid "couldn't allocate block map locks\n"
-msgstr "nie uda³o siê przydzieliæ blokad mapy bloków\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ blokad mapy blokÃ³w\n"
 
 #: ../repair/incore.c:76
 #, c-format
 msgid "couldn't allocate block map, size = %d\n"
-msgstr "nie uda³o siê przydzieliæ mapy bloków, rozmiar = %d\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ mapy blokÃ³w, rozmiar = %d\n"
 
 #: ../repair/incore.c:94
 #, c-format
 msgid "couldn't allocate realtime block map, size = %llu\n"
-msgstr "nie uda³o siê przydzieliæ mapy bloków realtime, size = %llu\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ mapy blokÃ³w realtime, size = %llu\n"
 
 #: ../repair/incore_ext.c:121 ../repair/incore_ext.c:679
 msgid "couldn't allocate new extent descriptors.\n"
-msgstr "nie uda³o siê przydzieliæ nowych deskryptorów fragmentów.\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ nowych deskryptorÃ³w fragmentÃ³w.\n"
 
 #: ../repair/incore_ext.c:254
 msgid "duplicate bno extent range\n"
-msgstr "powtórzony przedzia³ fragmentów bno\n"
+msgstr "powtÃ³rzony przedziaÅ‚ fragmentÃ³w bno\n"
 
 #: ../repair/incore_ext.c:391
 msgid ":  duplicate bno extent range\n"
-msgstr ": powtórzony przedzia³ fragmentów bno\n"
+msgstr ": powtÃ³rzony przedziaÅ‚ fragmentÃ³w bno\n"
 
 #: ../repair/incore_ext.c:555 ../repair/incore_ext.c:606
 #: ../repair/incore_ext.c:794 ../repair/incore_ext.c:849
 msgid "duplicate extent range\n"
-msgstr "powtórzony przedzia³ fragmentów\n"
+msgstr "powtÃ³rzony przedziaÅ‚ fragmentÃ³w\n"
 
 #: ../repair/incore_ext.c:907
 msgid "couldn't malloc dup extent tree descriptor table\n"
-msgstr "nie uda³o siê przydzieliæ tablicy deskryptorów drzewa powtórzonych fragmentów\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ tablicy deskryptorÃ³w drzewa powtÃ³rzonych fragmentÃ³w\n"
 
 #: ../repair/incore_ext.c:912
 msgid "couldn't malloc free by-bno extent tree descriptor table\n"
-msgstr "nie uda³o siê przydzieliæ tablicy deskryptorów drzewa wolnych fragmentów wg bno\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ tablicy deskryptorÃ³w drzewa wolnych fragmentÃ³w wg bno\n"
 
 #: ../repair/incore_ext.c:917
 msgid "couldn't malloc free by-bcnt extent tree descriptor table\n"
-msgstr "nie uda³o siê przydzieliæ tablicy deskryptorów drzewa wolnych fragmentów wg bcnt\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ tablicy deskryptorÃ³w drzewa wolnych fragmentÃ³w wg bcnt\n"
 
 #: ../repair/incore_ext.c:923
 msgid "couldn't malloc dup extent tree descriptor\n"
-msgstr "nie uda³o siê przydzieliæ deskryptora drzewa powtórzonych fragmentów\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ deskryptora drzewa powtÃ³rzonych fragmentÃ³w\n"
 
 #: ../repair/incore_ext.c:927
 msgid "couldn't malloc bno extent tree descriptor\n"
-msgstr "nie uda³o siê przydzieliæ deskryptora drzewa fragmentów wg bno\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ deskryptora drzewa fragmentÃ³w wg bno\n"
 
 #: ../repair/incore_ext.c:931
 msgid "couldn't malloc bcnt extent tree descriptor\n"
-msgstr "nie uda³o siê przydzieliæ deskryptora drzewa fragmentów wg bcnt\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ deskryptora drzewa fragmentÃ³w wg bcnt\n"
 
 #: ../repair/incore_ext.c:941
 msgid "couldn't malloc dup rt extent tree descriptor\n"
-msgstr "nie uda³o siê przydzieliæ deskryptora drzewa powtórzonych fragmentów rt\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ deskryptora drzewa powtÃ³rzonych fragmentÃ³w rt\n"
 
 #: ../repair/incore_ino.c:196 ../repair/incore_ino.c:205
 #: ../repair/incore_ino.c:222 ../repair/incore_ino.c:231
 msgid "could not allocate expanded nlink array\n"
-msgstr "Nie uda³o siê przydzieliæ rozszerzonej tablicy nlink\n"
+msgstr "Nie udaÅ‚o siÄ™ przydzieliÄ‡ rozszerzonej tablicy nlink\n"
 
 #: ../repair/incore_ino.c:268
 msgid "inode map malloc failed\n"
-msgstr "przydzielenie mapy i-wêz³ów nie powiod³o siê\n"
+msgstr "przydzielenie mapy i-wÄ™zÅ‚Ã³w nie powiodÅ‚o siÄ™\n"
 
 #: ../repair/incore_ino.c:298
 msgid "could not allocate nlink array\n"
-msgstr "Nie uda³o siê przydzieliæ tablicy nlink\n"
+msgstr "Nie udaÅ‚o siÄ™ przydzieliÄ‡ tablicy nlink\n"
 
 #: ../repair/incore_ino.c:390
 msgid "add_aginode_uncertain - duplicate inode range\n"
-msgstr "add_aginode_uncertain - powtórzony przedzia³ i-wêz³ów\n"
+msgstr "add_aginode_uncertain - powtÃ³rzony przedziaÅ‚ i-wÄ™zÅ‚Ã³w\n"
 
 #: ../repair/incore_ino.c:488
 msgid "add_inode - duplicate inode range\n"
-msgstr "add_inode - powtórzony przedzia³ i-wêz³ów\n"
+msgstr "add_inode - powtÃ³rzony przedziaÅ‚ i-wÄ™zÅ‚Ã³w\n"
 
 #: ../repair/incore_ino.c:579
 #, c-format
 msgid "good inode list is --\n"
-msgstr "lista dobrych i-wêz³ów to:\n"
+msgstr "lista dobrych i-wÄ™zÅ‚Ã³w to:\n"
 
 #: ../repair/incore_ino.c:582
 #, c-format
 msgid "uncertain inode list is --\n"
-msgstr "lista niepewnych i-wêz³ów to:\n"
+msgstr "lista niepewnych i-wÄ™zÅ‚Ã³w to:\n"
 
 #: ../repair/incore_ino.c:587
 #, c-format
 msgid "agno %d -- no inodes\n"
-msgstr "agno %d - brak i-wêz³ów\n"
+msgstr "agno %d - brak i-wÄ™zÅ‚Ã³w\n"
 
 #: ../repair/incore_ino.c:591
 #, c-format
@@ -7443,43 +7443,43 @@ msgstr "\tptr = %lx, start = 0x%x, wolne = 0x%llx, potwierdzone = 0x%llx\n"
 
 #: ../repair/incore_ino.c:646
 msgid "couldn't malloc parent list table\n"
-msgstr "nie uda³o siê przydzieliæ tablicy listy rodziców\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ tablicy listy rodzicÃ³w\n"
 
 #: ../repair/incore_ino.c:657 ../repair/incore_ino.c:703
 msgid "couldn't memalign pentries table\n"
-msgstr "nie uda³o siê memalign na tablicy pentries\n"
+msgstr "nie udaÅ‚o siÄ™ memalign na tablicy pentries\n"
 
 #: ../repair/incore_ino.c:761 ../repair/incore_ino.c:767
 msgid "could not malloc inode extra data\n"
-msgstr "nie uda³o siê przydzieliæ dodatkowych danych i-wêz³a\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ dodatkowych danych i-wÄ™zÅ‚a\n"
 
 #: ../repair/incore_ino.c:815
 msgid "couldn't malloc inode tree descriptor table\n"
-msgstr "nie uda³o siê przydzieliæ tablicy deskryptorów drzewa i-wêz³ów\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ tablicy deskryptorÃ³w drzewa i-wÄ™zÅ‚Ã³w\n"
 
 #: ../repair/incore_ino.c:819
 msgid "couldn't malloc uncertain ino tree descriptor table\n"
-msgstr "nie uda³o siê przydzieliæ tablicy deskryptorów drzewa i-wêz³ów niepewnych\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ tablicy deskryptorÃ³w drzewa i-wÄ™zÅ‚Ã³w niepewnych\n"
 
 #: ../repair/incore_ino.c:824
 msgid "couldn't malloc inode tree descriptor\n"
-msgstr "nie uda³o siê przydzieliæ deskryptora drzewa i-wêz³ów\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ deskryptora drzewa i-wÄ™zÅ‚Ã³w\n"
 
 #: ../repair/incore_ino.c:828
 msgid "couldn't malloc uncertain ino tree descriptor\n"
-msgstr "nie uda³o siê przydzieliæ deskryptora drzewa i-wêz³ów niepewnych\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ deskryptora drzewa i-wÄ™zÅ‚Ã³w niepewnych\n"
 
 #: ../repair/incore_ino.c:839
 msgid "couldn't malloc uncertain inode cache area\n"
-msgstr "nie uda³o siê przydzieliæ obszaru pamiêci podrêcznej i-wêz³ów niepewnych\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ obszaru pamiÄ™ci podrÄ™cznej i-wÄ™zÅ‚Ã³w niepewnych\n"
 
 #: ../repair/init.c:42
 msgid "ts_alloc: cannot allocate thread specific storage\n"
-msgstr "ts_alloc: nie mo¿na przydzieliæ miejsca dla w±tku\n"
+msgstr "ts_alloc: nie moÅ¼na przydzieliÄ‡ miejsca dla wÄ…tku\n"
 
 #: ../repair/init.c:147
 msgid "couldn't initialize XFS library\n"
-msgstr "nie uda³o siê zainicjowaæ biblioteki XFS\n"
+msgstr "nie udaÅ‚o siÄ™ zainicjowaÄ‡ biblioteki XFS\n"
 
 #: ../repair/phase1.c:28
 msgid "Sorry, could not find valid secondary superblock\n"
@@ -7487,12 +7487,12 @@ msgstr "Niestety nie znaleziono poprawnego zapasowego superbloku\n"
 
 #: ../repair/phase1.c:29
 msgid "Exiting now.\n"
-msgstr "Zakoñczono.\n"
+msgstr "ZakoÅ„czono.\n"
 
 #: ../repair/phase1.c:40
 #, c-format
 msgid "could not allocate ag header buffer (%d bytes)\n"
-msgstr "nie uda³o siê przydzieliæ bufora nag³ówka ag (%d bajtów)\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ bufora nagÅ‚Ã³wka ag (%d bajtÃ³w)\n"
 
 #: ../repair/phase1.c:58
 msgid "Phase 1 - find and verify superblock...\n"
@@ -7500,70 +7500,70 @@ msgstr "Faza 1 - szukanie i sprawdzanie superbloku...\n"
 
 #: ../repair/phase1.c:74
 msgid "error reading primary superblock\n"
-msgstr "b³±d podczas odczytu g³ównego superbloku\n"
+msgstr "bÅ‚Ä…d podczas odczytu gÅ‚Ã³wnego superbloku\n"
 
 #: ../repair/phase1.c:80
 #, c-format
 msgid "bad primary superblock - %s !!!\n"
-msgstr "b³êdny g³ówny superblok - %s!!!\n"
+msgstr "bÅ‚Ä™dny gÅ‚Ã³wny superblok - %s!!!\n"
 
 #: ../repair/phase1.c:87
 #, c-format
 msgid "couldn't verify primary superblock - %s !!!\n"
-msgstr "nie uda³o siê sprawdziæ g³ównego superbloku - %s!!!\n"
+msgstr "nie udaÅ‚o siÄ™ sprawdziÄ‡ gÅ‚Ã³wnego superbloku - %s!!!\n"
 
 #: ../repair/phase1.c:105
 msgid "superblock has a features2 mismatch, correcting\n"
-msgstr "superblok ma niepasuj±ce features2, poprawianie\n"
+msgstr "superblok ma niepasujÄ…ce features2, poprawianie\n"
 
 #: ../repair/phase1.c:121
 #, c-format
 msgid "Enabling lazy-counters\n"
-msgstr "W³±czanie leniwych liczników\n"
+msgstr "WÅ‚Ä…czanie leniwych licznikÃ³w\n"
 
 #: ../repair/phase1.c:125
 #, c-format
 msgid "Disabling lazy-counters\n"
-msgstr "Wy³±czanie leniwych liczników\n"
+msgstr "WyÅ‚Ä…czanie leniwych licznikÃ³w\n"
 
 #: ../repair/phase1.c:128
 #, c-format
 msgid "Lazy-counters are already %s\n"
-msgstr "Leniwe liczniki ju¿ s± %s\n"
+msgstr "Leniwe liczniki juÅ¼ sÄ… %s\n"
 
 #: ../repair/phase1.c:129
 msgid "enabled"
-msgstr "w³±czone"
+msgstr "wÅ‚Ä…czone"
 
 #: ../repair/phase1.c:129
 msgid "disabled"
-msgstr "wy³±czone"
+msgstr "wyÅ‚Ä…czone"
 
 #: ../repair/phase1.c:136
 msgid "writing modified primary superblock\n"
-msgstr "zapisano zmodyfikowany g³ówny superblok\n"
+msgstr "zapisano zmodyfikowany gÅ‚Ã³wny superblok\n"
 
 #: ../repair/phase1.c:139
 msgid "would write modified primary superblock\n"
-msgstr "zmodyfikowany g³ówny superblok zosta³by zapisany\n"
+msgstr "zmodyfikowany gÅ‚Ã³wny superblok zostaÅ‚by zapisany\n"
 
 #: ../repair/phase2.c:65
 #, c-format
 msgid "zero_log: cannot find log head/tail (xlog_find_tail=%d), zeroing it anyway\n"
-msgstr "zero_log: nie znaleziono pocz±tku/koñca logu (xlog_find_tail=%d), wyzerowano go\n"
+msgstr "zero_log: nie znaleziono poczÄ…tku/koÅ„ca logu (xlog_find_tail=%d), wyzerowano go\n"
 
 #: ../repair/phase2.c:70
 #, c-format
 msgid "zero_log: head block %lld tail block %lld\n"
-msgstr "zero_log: blok pocz±tku %lld blok koñca %lld\n"
+msgstr "zero_log: blok poczÄ…tku %lld blok koÅ„ca %lld\n"
 
 #: ../repair/phase2.c:76
 msgid ""
 "ALERT: The filesystem has valuable metadata changes in a log which is being\n"
 "destroyed because the -L option was used.\n"
 msgstr ""
-"UWAGA: system plików zawiera warto¶ciowe zmiany metadanych w logu, który jest\n"
-"niszczony, poniewa¿ u¿yto opcji -L.\n"
+"UWAGA: system plikÃ³w zawiera wartoÅ›ciowe zmiany metadanych w logu, ktÃ³ry jest\n"
+"niszczony, poniewaÅ¼ uÅ¼yto opcji -L.\n"
 
 #: ../repair/phase2.c:80
 msgid ""
@@ -7574,26 +7574,26 @@ msgid ""
 "Note that destroying the log may cause corruption -- please attempt a mount\n"
 "of the filesystem before doing this.\n"
 msgstr ""
-"B£¡D: system plików zawiera warto¶ciowe zmiany metadanych w logu, który\n"
-"musi byæ odtworzony. Nale¿y podmontowaæ system plików, aby odtworzyæ log,\n"
-"a nastêpnie odmontowaæ go przed ponownym uruchomieniem xfs_repair. Je¶li\n"
-"systemu plików nie da siê podmontowaæ, mo¿na u¿yæ opcji -L, aby zniszczyæ\n"
-"log i spróbowaæ naprawiæ system plików.\n"
-"Nale¿y zauwa¿yæ, ¿e zniszczenie logu mo¿e spowodowaæ uszkodzenia danych -\n"
-"proszê najpierw spróbowaæ podmontowaæ system plików.\n"
+"BÅÄ„D: system plikÃ³w zawiera wartoÅ›ciowe zmiany metadanych w logu, ktÃ³ry\n"
+"musi byÄ‡ odtworzony. NaleÅ¼y podmontowaÄ‡ system plikÃ³w, aby odtworzyÄ‡ log,\n"
+"a nastÄ™pnie odmontowaÄ‡ go przed ponownym uruchomieniem xfs_repair. JeÅ›li\n"
+"systemu plikÃ³w nie da siÄ™ podmontowaÄ‡, moÅ¼na uÅ¼yÄ‡ opcji -L, aby zniszczyÄ‡\n"
+"log i sprÃ³bowaÄ‡ naprawiÄ‡ system plikÃ³w.\n"
+"NaleÅ¼y zauwaÅ¼yÄ‡, Å¼e zniszczenie logu moÅ¼e spowodowaÄ‡ uszkodzenia danych -\n"
+"proszÄ™ najpierw sprÃ³bowaÄ‡ podmontowaÄ‡ system plikÃ³w.\n"
 
 #: ../repair/phase2.c:122
 msgid "This filesystem has an external log.  Specify log device with the -l option.\n"
-msgstr "Ten system plików ma zewnêtrzny log. Nale¿y podaæ urz±dzenie logu przy u¿yciu opcji -l.\n"
+msgstr "Ten system plikÃ³w ma zewnÄ™trzny log. NaleÅ¼y podaÄ‡ urzÄ…dzenie logu przy uÅ¼yciu opcji -l.\n"
 
 #: ../repair/phase2.c:125
 #, c-format
 msgid "Phase 2 - using external log on %s\n"
-msgstr "Faza 2 - u¿ycie zewnêtrznego logu na %s\n"
+msgstr "Faza 2 - uÅ¼ycie zewnÄ™trznego logu na %s\n"
 
 #: ../repair/phase2.c:127
 msgid "Phase 2 - using internal log\n"
-msgstr "Faza 2 - u¿ycie wewnêtrznego logu\n"
+msgstr "Faza 2 - uÅ¼ycie wewnÄ™trznego logu\n"
 
 #: ../repair/phase2.c:131
 msgid "        - zero log...\n"
@@ -7601,37 +7601,37 @@ msgstr "        - zerowanie logu...\n"
 
 #: ../repair/phase2.c:135
 msgid "        - scan filesystem freespace and inode maps...\n"
-msgstr "        - przeszukiwanie wolnego miejsca i map i-wêz³ów w systemie plików...\n"
+msgstr "        - przeszukiwanie wolnego miejsca i map i-wÄ™zÅ‚Ã³w w systemie plikÃ³w...\n"
 
 #: ../repair/phase2.c:162
 msgid "root inode chunk not found\n"
-msgstr "nie znaleziono danych g³ównego i-wêz³a\n"
+msgstr "nie znaleziono danych gÅ‚Ã³wnego i-wÄ™zÅ‚a\n"
 
 #: ../repair/phase2.c:184
 msgid "        - found root inode chunk\n"
-msgstr "        - znaleziono dane g³ównego i-wêz³a\n"
+msgstr "        - znaleziono dane gÅ‚Ã³wnego i-wÄ™zÅ‚a\n"
 
 #: ../repair/phase2.c:190
 msgid "root inode marked free, "
-msgstr "g³ówny i-wêze³ oznaczony jako wolny, "
+msgstr "gÅ‚Ã³wny i-wÄ™zeÅ‚ oznaczony jako wolny, "
 
 #: ../repair/phase2.c:199
 msgid "realtime bitmap inode marked free, "
-msgstr "i-wêze³ bitmapy realtime oznaczony jako wolny, "
+msgstr "i-wÄ™zeÅ‚ bitmapy realtime oznaczony jako wolny, "
 
 #: ../repair/phase2.c:208
 msgid "realtime summary inode marked free, "
-msgstr "i-wêze³ opisu realtime oznaczony jako wolny, "
+msgstr "i-wÄ™zeÅ‚ opisu realtime oznaczony jako wolny, "
 
 #: ../repair/phase3.c:117
 #, c-format
 msgid "cannot read agi block %lld for ag %u\n"
-msgstr "nie mo¿na odczytaæ bloku agi %lld dla ag %u\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku agi %lld dla ag %u\n"
 
 #: ../repair/phase3.c:139
 #, c-format
 msgid "error following ag %d unlinked list\n"
-msgstr "b³±d podczas pod±¿ania za od³±czon± list± ag %d\n"
+msgstr "bÅ‚Ä…d podczas podÄ…Å¼ania za odÅ‚Ä…czonÄ… listÄ… ag %d\n"
 
 #: ../repair/phase3.c:160 ../repair/phase4.c:125 ../repair/phase5.c:1438
 #: ../repair/phase6.c:3595
@@ -7641,39 +7641,39 @@ msgstr "        - agno = %d\n"
 
 #: ../repair/phase3.c:211
 msgid "Phase 3 - for each AG...\n"
-msgstr "Faza 3 - dla ka¿dej AG...\n"
+msgstr "Faza 3 - dla kaÅ¼dej AG...\n"
 
 #: ../repair/phase3.c:213
 msgid "        - scan and clear agi unlinked lists...\n"
-msgstr "        - przeszukiwanie i czyszczenie od³±czonych list agi...\n"
+msgstr "        - przeszukiwanie i czyszczenie odÅ‚Ä…czonych list agi...\n"
 
 #: ../repair/phase3.c:215
 msgid "        - scan (but don't clear) agi unlinked lists...\n"
-msgstr "        - przeszukiwanie (ale nie czyszczenie) od³±czonych list agi...\n"
+msgstr "        - przeszukiwanie (ale nie czyszczenie) odÅ‚Ä…czonych list agi...\n"
 
 #: ../repair/phase3.c:235
 msgid "        - process known inodes and perform inode discovery...\n"
-msgstr "        - przetwarzanie znanych i-wêz³ów i rozpoznawanie i-wêz³ów...\n"
+msgstr "        - przetwarzanie znanych i-wÄ™zÅ‚Ã³w i rozpoznawanie i-wÄ™zÅ‚Ã³w...\n"
 
 #: ../repair/phase3.c:246
 msgid "        - process newly discovered inodes...\n"
-msgstr "        - przetwarzanie nowo rozpoznanych i-wêz³ów...\n"
+msgstr "        - przetwarzanie nowo rozpoznanych i-wÄ™zÅ‚Ã³w...\n"
 
 #: ../repair/phase4.c:205
 msgid "Phase 4 - check for duplicate blocks...\n"
-msgstr "Faza 4 - sprawdzanie powtórzonych bloków...\n"
+msgstr "Faza 4 - sprawdzanie powtÃ³rzonych blokÃ³w...\n"
 
 #: ../repair/phase4.c:206
 msgid "        - setting up duplicate extent list...\n"
-msgstr "        - tworzenie listy powtórzonych fragmentów...\n"
+msgstr "        - tworzenie listy powtÃ³rzonych fragmentÃ³w...\n"
 
 #: ../repair/phase4.c:220
 msgid "root inode would be lost\n"
-msgstr "g³ówny i-wêze³ zosta³by utracony\n"
+msgstr "gÅ‚Ã³wny i-wÄ™zeÅ‚ zostaÅ‚by utracony\n"
 
 #: ../repair/phase4.c:222
 msgid "root inode lost\n"
-msgstr "g³ówny i-wêze³ utracony\n"
+msgstr "gÅ‚Ã³wny i-wÄ™zeÅ‚ utracony\n"
 
 #: ../repair/phase4.c:256
 #, c-format
@@ -7687,75 +7687,75 @@ msgstr "nieznany stan fragmentu rt, fragment %llu\n"
 
 #: ../repair/phase4.c:375
 msgid "        - check for inodes claiming duplicate blocks...\n"
-msgstr "        - szukanie i-wêz³ów odwo³uj±cych siê do powtórzonych bloków...\n"
+msgstr "        - szukanie i-wÄ™zÅ‚Ã³w odwoÅ‚ujÄ…cych siÄ™ do powtÃ³rzonych blokÃ³w...\n"
 
 #: ../repair/phase5.c:234
 msgid "could not set up btree block array\n"
-msgstr "nie uda³o siê utworzyæ tablicy bloków b-drzewa\n"
+msgstr "nie udaÅ‚o siÄ™ utworzyÄ‡ tablicy blokÃ³w b-drzewa\n"
 
 #: ../repair/phase5.c:246
 msgid "error - not enough free space in filesystem\n"
-msgstr "b³±d - za ma³o wolnego miejsca w systemie plików\n"
+msgstr "bÅ‚Ä…d - za maÅ‚o wolnego miejsca w systemie plikÃ³w\n"
 
 #: ../repair/phase5.c:462
 #, c-format
 msgid "can't rebuild fs trees -- not enough free space on ag %u\n"
-msgstr "nie mo¿na przebudowaæ drzew systemu plików - za ma³o wolnego miejsca w ag %u\n"
+msgstr "nie moÅ¼na przebudowaÄ‡ drzew systemu plikÃ³w - za maÅ‚o wolnego miejsca w ag %u\n"
 
 #: ../repair/phase5.c:486
 #, c-format
 msgid "ag %u - not enough free space to build freespace btrees\n"
-msgstr "ag %u - za ma³o wolnego miejsca na przebudowanie b-drzew wolnego miejsca\n"
+msgstr "ag %u - za maÅ‚o wolnego miejsca na przebudowanie b-drzew wolnego miejsca\n"
 
 #: ../repair/phase5.c:521
 #, c-format
 msgid "not enough free blocks left to describe all free blocks in AG %u\n"
-msgstr "za ma³o wolnych bloków na opisanie wszystkich wolnych bloków w AG %u\n"
+msgstr "za maÅ‚o wolnych blokÃ³w na opisanie wszystkich wolnych blokÃ³w w AG %u\n"
 
 #: ../repair/phase5.c:1334
 #, c-format
 msgid "lost %d blocks in ag %u\n"
-msgstr "utracono %d bloków w ag %u\n"
+msgstr "utracono %d blokÃ³w w ag %u\n"
 
 #: ../repair/phase5.c:1337
 #, c-format
 msgid "thought we were going to lose %d blocks in ag %u, actually lost %d\n"
-msgstr "przewidywano utracenie %d bloków w ag %u, a utracono %d\n"
+msgstr "przewidywano utracenie %d blokÃ³w w ag %u, a utracono %d\n"
 
 #: ../repair/phase5.c:1384 ../repair/xfs_repair.c:816
 msgid "couldn't get superblock\n"
-msgstr "nie uda³o siê pobraæ superbloku\n"
+msgstr "nie udaÅ‚o siÄ™ pobraÄ‡ superbloku\n"
 
 #: ../repair/phase5.c:1461
 #, c-format
 msgid "unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"
-msgstr "nie uda³o siê przebudowaæ AG %u. Za ma³o wolnego miejsca w AG na dysku.\n"
+msgstr "nie udaÅ‚o siÄ™ przebudowaÄ‡ AG %u. Za maÅ‚o wolnego miejsca w AG na dysku.\n"
 
 #: ../repair/phase5.c:1501
 #, c-format
 msgid "unable to rebuild AG %u.  No free space.\n"
-msgstr "nie uda³o siê przebudowaæ AG %u. Brak wolnego miejsca.\n"
+msgstr "nie udaÅ‚o siÄ™ przebudowaÄ‡ AG %u. Brak wolnego miejsca.\n"
 
 #: ../repair/phase5.c:1528
 #, c-format
 msgid "lost %d blocks in agno %d, sorry.\n"
-msgstr "niestety utracono %d bloków w agno %d.\n"
+msgstr "niestety utracono %d blokÃ³w w agno %d.\n"
 
 #: ../repair/phase5.c:1597
 msgid "Phase 5 - rebuild AG headers and trees...\n"
-msgstr "Faza 5 - przebudowywanie nag³ówków i drzew AG...\n"
+msgstr "Faza 5 - przebudowywanie nagÅ‚Ã³wkÃ³w i drzew AG...\n"
 
 #: ../repair/phase5.c:1627
 msgid "cannot alloc sb_icount_ag buffers\n"
-msgstr "nie mo¿na przydzieliæ buforów sb_icount_ag\n"
+msgstr "nie moÅ¼na przydzieliÄ‡ buforÃ³w sb_icount_ag\n"
 
 #: ../repair/phase5.c:1631
 msgid "cannot alloc sb_ifree_ag buffers\n"
-msgstr "nie mo¿na przydzieliæ buforów sb_ifree_ag\n"
+msgstr "nie moÅ¼na przydzieliÄ‡ buforÃ³w sb_ifree_ag\n"
 
 #: ../repair/phase5.c:1635
 msgid "cannot alloc sb_fdblocks_ag buffers\n"
-msgstr "nie mo¿na przydzieliæ buforów sb_fdblocks_ag\n"
+msgstr "nie moÅ¼na przydzieliÄ‡ buforÃ³w sb_fdblocks_ag\n"
 
 #: ../repair/phase5.c:1654
 msgid "        - generate realtime summary info and bitmap...\n"
@@ -7768,12 +7768,12 @@ msgstr "        - przestawianie superbloku...\n"
 #: ../repair/phase6.c:63
 #, c-format
 msgid "malloc failed add_dotdot_update (%u bytes)\n"
-msgstr "malloc nie powiod³o siê w add_dotdot_update (%u bajtów)\n"
+msgstr "malloc nie powiodÅ‚o siÄ™ w add_dotdot_update (%u bajtÃ³w)\n"
 
 #: ../repair/phase6.c:174
 #, c-format
 msgid "malloc failed in dir_hash_add (%u bytes)\n"
-msgstr "malloc nie powiod³o siê w dir_hash_add (%u bajtów)\n"
+msgstr "malloc nie powiodÅ‚o siÄ™ w dir_hash_add (%u bajtÃ³w)\n"
 
 #: ../repair/phase6.c:228
 msgid "ok"
@@ -7781,11 +7781,11 @@ msgstr "ok"
 
 #: ../repair/phase6.c:229
 msgid "duplicate leaf"
-msgstr "powtórzony li¶æ"
+msgstr "powtÃ³rzony liÅ›Ä‡"
 
 #: ../repair/phase6.c:230
 msgid "hash value mismatch"
-msgstr "niezgodno¶æ warto¶ci hasza"
+msgstr "niezgodnoÅ›Ä‡ wartoÅ›ci hasza"
 
 #: ../repair/phase6.c:231
 msgid "no data entry"
@@ -7793,16 +7793,16 @@ msgstr "brak wpisu danych"
 
 #: ../repair/phase6.c:232
 msgid "no leaf entry"
-msgstr "brak wpisu li¶cia"
+msgstr "brak wpisu liÅ›cia"
 
 #: ../repair/phase6.c:233
 msgid "bad stale count"
-msgstr "b³êdna liczba stale"
+msgstr "bÅ‚Ä™dna liczba stale"
 
 #: ../repair/phase6.c:241
 #, c-format
 msgid "bad hash table for directory inode %llu (%s): "
-msgstr "b³êdna tablica haszuj±ca dla i-wêz³a katalogu %llu (%s): "
+msgstr "bÅ‚Ä™dna tablica haszujÄ…ca dla i-wÄ™zÅ‚a katalogu %llu (%s): "
 
 #: ../repair/phase6.c:244
 msgid "rebuilding\n"
@@ -7810,11 +7810,11 @@ msgstr "przebudowano\n"
 
 #: ../repair/phase6.c:246
 msgid "would rebuild\n"
-msgstr "zosta³aby przebudowana\n"
+msgstr "zostaÅ‚aby przebudowana\n"
 
 #: ../repair/phase6.c:282
 msgid "calloc failed in dir_hash_init\n"
-msgstr "calloc nie powiod³o siê w dir_hash_init\n"
+msgstr "calloc nie powiodÅ‚o siÄ™ w dir_hash_init\n"
 
 #: ../repair/phase6.c:412
 msgid "ran out of disk space!\n"
@@ -7823,123 +7823,123 @@ msgstr "brak miejsca na dysku!\n"
 #: ../repair/phase6.c:414
 #, c-format
 msgid "xfs_trans_reserve returned %d\n"
-msgstr "xfs_trans_reserve zwróci³o %d\n"
+msgstr "xfs_trans_reserve zwrÃ³ciÅ‚o %d\n"
 
 #: ../repair/phase6.c:443 ../repair/phase6.c:536
 #, c-format
 msgid "couldn't iget realtime bitmap inode -- error - %d\n"
-msgstr "nie uda³o siê wykonaæ iget dla i-wêz³a bitmapy realtime - b³±d %d\n"
+msgstr "nie udaÅ‚o siÄ™ wykonaÄ‡ iget dla i-wÄ™zÅ‚a bitmapy realtime - bÅ‚Ä…d %d\n"
 
 #: ../repair/phase6.c:493
 #, c-format
 msgid "couldn't allocate realtime bitmap, error = %d\n"
-msgstr "nie uda³o siê przydzieliæ bitmapy realtime, b³±d = %d\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ bitmapy realtime, bÅ‚Ä…d = %d\n"
 
 #: ../repair/phase6.c:506
 #, c-format
 msgid "allocation of the realtime bitmap failed, error = %d\n"
-msgstr "przydzielenie bitmapy realtime nie powiod³o siê, b³±d = %d\n"
+msgstr "przydzielenie bitmapy realtime nie powiodÅ‚o siÄ™, bÅ‚Ä…d = %d\n"
 
 #: ../repair/phase6.c:549
 #, c-format
 msgid "couldn't map realtime bitmap block %llu, error = %d\n"
-msgstr "nie uda³o siê odwzorowaæ bloku bitmapy realtime %llu, b³±d = %d\n"
+msgstr "nie udaÅ‚o siÄ™ odwzorowaÄ‡ bloku bitmapy realtime %llu, bÅ‚Ä…d = %d\n"
 
 #: ../repair/phase6.c:562
 #, c-format
 msgid "can't access block %llu (fsbno %llu) of realtime bitmap inode %llu\n"
-msgstr "brak dostêpu do bloku %llu (fsbno %llu) i-wêz³a bitmapy realtime %llu\n"
+msgstr "brak dostÄ™pu do bloku %llu (fsbno %llu) i-wÄ™zÅ‚a bitmapy realtime %llu\n"
 
 #: ../repair/phase6.c:605 ../repair/phase6.c:676
 #, c-format
 msgid "couldn't iget realtime summary inode -- error - %d\n"
-msgstr "nie uda³o siê wykonaæ iget dla i-wêz³a opisu realtime - b³±d %d\n"
+msgstr "nie udaÅ‚o siÄ™ wykonaÄ‡ iget dla i-wÄ™zÅ‚a opisu realtime - bÅ‚Ä…d %d\n"
 
 #: ../repair/phase6.c:618
 #, c-format
 msgid "couldn't map realtime summary inode block %llu, error = %d\n"
-msgstr "nie uda³o siê odwzorowaæ bloku i-wêz³a opisu realtime %llu, b³±d = %d\n"
+msgstr "nie udaÅ‚o siÄ™ odwzorowaÄ‡ bloku i-wÄ™zÅ‚a opisu realtime %llu, bÅ‚Ä…d = %d\n"
 
 #: ../repair/phase6.c:631
 #, c-format
 msgid "can't access block %llu (fsbno %llu) of realtime summary inode %llu\n"
-msgstr "brak dostêpu do bloku %llu (fsbno %llu) i-wêz³a opisu realtime %llu\n"
+msgstr "brak dostÄ™pu do bloku %llu (fsbno %llu) i-wÄ™zÅ‚a opisu realtime %llu\n"
 
 #: ../repair/phase6.c:732
 #, c-format
 msgid "couldn't allocate realtime summary inode, error = %d\n"
-msgstr "nie uda³o siê przydzieliæ i-wêz³a opisu realtime, b³±d = %d\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ i-wÄ™zÅ‚a opisu realtime, bÅ‚Ä…d = %d\n"
 
 #: ../repair/phase6.c:745
 #, c-format
 msgid "allocation of the realtime summary ino failed, error = %d\n"
-msgstr "przydzielenie i-wêz³a opisu realtime nie powiod³o siê, b³±d = %d\n"
+msgstr "przydzielenie i-wÄ™zÅ‚a opisu realtime nie powiodÅ‚o siÄ™, bÅ‚Ä…d = %d\n"
 
 #: ../repair/phase6.c:775
 #, c-format
 msgid "could not iget root inode -- error - %d\n"
-msgstr "nie uda³o siê wykonaæ iget dla g³ównego i-wêz³a - b³±d %d\n"
+msgstr "nie udaÅ‚o siÄ™ wykonaÄ‡ iget dla gÅ‚Ã³wnego i-wÄ™zÅ‚a - bÅ‚Ä…d %d\n"
 
 #: ../repair/phase6.c:843
 #, c-format
 msgid "%d - couldn't iget root inode to obtain %s\n"
-msgstr "%d - nie uda³o siê wykonaæ iget dla g³ównego wêz³a, aby uzyskaæ %s\n"
+msgstr "%d - nie udaÅ‚o siÄ™ wykonaÄ‡ iget dla gÅ‚Ã³wnego wÄ™zÅ‚a, aby uzyskaÄ‡ %s\n"
 
 #: ../repair/phase6.c:874
 #, c-format
 msgid "%s inode allocation failed %d\n"
-msgstr "przydzielenie i-wêz³± %s nie powiod³o siê - %d\n"
+msgstr "przydzielenie i-wÄ™zÅ‚Ä… %s nie powiodÅ‚o siÄ™ - %d\n"
 
 #: ../repair/phase6.c:892
 #, c-format
 msgid "can't make %s, createname error %d\n"
-msgstr "nie mo¿na zrobiæ %s, b³±d createname %d\n"
+msgstr "nie moÅ¼na zrobiÄ‡ %s, bÅ‚Ä…d createname %d\n"
 
 #: ../repair/phase6.c:910
 #, c-format
 msgid "%s directory creation failed -- bmapf error %d\n"
-msgstr "tworzenie katalogu %s nie powiod³o siê - b³±d bmapf %d\n"
+msgstr "tworzenie katalogu %s nie powiodÅ‚o siÄ™ - bÅ‚Ä…d bmapf %d\n"
 
 #: ../repair/phase6.c:953
 #, c-format
 msgid "%d - couldn't iget orphanage inode\n"
-msgstr "%d - nie uda³o siê wykonaæ iget dla i-wêz³a sierociñca\n"
+msgstr "%d - nie udaÅ‚o siÄ™ wykonaÄ‡ iget dla i-wÄ™zÅ‚a sierociÅ„ca\n"
 
 #: ../repair/phase6.c:966
 #, c-format
 msgid "%d - couldn't iget disconnected inode\n"
-msgstr "%d - nie uda³o siê wykonaæ iget dla od³±czonego i-wêz³a\n"
+msgstr "%d - nie udaÅ‚o siÄ™ wykonaÄ‡ iget dla odÅ‚Ä…czonego i-wÄ™zÅ‚a\n"
 
 #: ../repair/phase6.c:986 ../repair/phase6.c:1030 ../repair/phase6.c:1087
 #: ../repair/phase6.c:1730
 #, c-format
 msgid "space reservation failed (%d), filesystem may be out of space\n"
-msgstr "nie uda³o siê zarezerwowaæ miejsca (%d), mo¿e brakowaæ miejsca w systemie plików\n"
+msgstr "nie udaÅ‚o siÄ™ zarezerwowaÄ‡ miejsca (%d), moÅ¼e brakowaÄ‡ miejsca w systemie plikÃ³w\n"
 
 #: ../repair/phase6.c:997 ../repair/phase6.c:1042 ../repair/phase6.c:1098
 #, c-format
 msgid "name create failed in %s (%d), filesystem may be out of space\n"
-msgstr "tworzenie nazwy nie powiod³o siê w %s (%d), mo¿e brakowaæ miejsca w systemie plików\n"
+msgstr "tworzenie nazwy nie powiodÅ‚o siÄ™ w %s (%d), moÅ¼e brakowaÄ‡ miejsca w systemie plikÃ³w\n"
 
 #: ../repair/phase6.c:1010
 #, c-format
 msgid "creation of .. entry failed (%d), filesystem may be out of space\n"
-msgstr "tworzenie wpisu .. nie powiod³o siê (%d), mo¿e brakowaæ miejsca w systemie plików\n"
+msgstr "tworzenie wpisu .. nie powiodÅ‚o siÄ™ (%d), moÅ¼e brakowaÄ‡ miejsca w systemie plikÃ³w\n"
 
 #: ../repair/phase6.c:1019
 #, c-format
 msgid "bmap finish failed (err - %d), filesystem may be out of space\n"
-msgstr "zakoñczenie bmap nie powiod³o siê (b³±d %d), mo¿e brakowaæ miejsca w systemie plików\n"
+msgstr "zakoÅ„czenie bmap nie powiodÅ‚o siÄ™ (bÅ‚Ä…d %d), moÅ¼e brakowaÄ‡ miejsca w systemie plikÃ³w\n"
 
 #: ../repair/phase6.c:1061
 #, c-format
 msgid "name replace op failed (%d), filesystem may be out of space\n"
-msgstr "operacja zast±pienia nazwy nie powiod³a siê (%d), mo¿e brakowaæ miejsca w systemie plików\n"
+msgstr "operacja zastÄ…pienia nazwy nie powiodÅ‚a siÄ™ (%d), moÅ¼e brakowaÄ‡ miejsca w systemie plikÃ³w\n"
 
 #: ../repair/phase6.c:1068 ../repair/phase6.c:1108 ../repair/phase6.c:1753
 #, c-format
 msgid "bmap finish failed (%d), filesystem may be out of space\n"
-msgstr "zakoñczenie bmap nie powiod³o siê (%d), mo¿e brakowaæ miejsca w systemie plików\n"
+msgstr "zakoÅ„czenie bmap nie powiodÅ‚o siÄ™ (%d), moÅ¼e brakowaÄ‡ miejsca w systemie plikÃ³w\n"
 
 #: ../repair/phase6.c:1149 ../repair/phase6.c:1548
 msgid "dir"
@@ -7948,23 +7948,23 @@ msgstr "katalogu"
 #: ../repair/phase6.c:1158 ../repair/phase6.c:1162
 #, c-format
 msgid "can't map block %d in %s inode %llu, xfs_bmapi returns %d, nmap = %d\n"
-msgstr "nie mo¿na odwzorowaæ bloku %d w i-wê¼le %s %llu, xfs_bmapi zwraca %d, nmap = %d\n"
+msgstr "nie moÅ¼na odwzorowaÄ‡ bloku %d w i-wÄ™Åºle %s %llu, xfs_bmapi zwraca %d, nmap = %d\n"
 
 #: ../repair/phase6.c:1170 ../repair/phase6.c:1173 ../repair/phase6.c:1626
 #: ../repair/phase6.c:1630
 #, c-format
 msgid "block %d in %s ino %llu doesn't exist\n"
-msgstr "blok %d w i-wê¼le %s %llu nie istnieje\n"
+msgstr "blok %d w i-wÄ™Åºle %s %llu nie istnieje\n"
 
 #: ../repair/phase6.c:1228 ../repair/phase6.c:1232
 #, c-format
 msgid "can't map block %d in %s ino %llu, xfs_bmapi returns %d, nmap = %d\n"
-msgstr "nie mo¿na odwzorowaæ bloku %d w i-wê¼le %s %llu, xfs_bmapi zwraca %d, nmap = %d\n"
+msgstr "nie moÅ¼na odwzorowaÄ‡ bloku %d w i-wÄ™Åºle %s %llu, xfs_bmapi zwraca %d, nmap = %d\n"
 
 #: ../repair/phase6.c:1240 ../repair/phase6.c:1244
 #, c-format
 msgid "block %d in %s inode %llu doesn't exist\n"
-msgstr "blok %d w i-wê¼le %s %llu nie istnieje\n"
+msgstr "blok %d w i-wÄ™Åºle %s %llu nie istnieje\n"
 
 #: ../repair/phase6.c:1267
 msgid ", marking entry to be junked\n"
@@ -7972,45 +7972,45 @@ msgstr ", zaznaczono wpis do wyrzucenia\n"
 
 #: ../repair/phase6.c:1271
 msgid ", would junk entry\n"
-msgstr ", wpis zosta³by wyrzucony\n"
+msgstr ", wpis zostaÅ‚by wyrzucony\n"
 
 #: ../repair/phase6.c:1387
 #, c-format
 msgid "entry \"%s\" in dir inode %llu points to non-existent inode %llu"
-msgstr "wpis \"%s\" w i-wê¼le katalogu %llu wskazuje na nie istniej±cy i-wêzê³ %llu"
+msgstr "wpis \"%s\" w i-wÄ™Åºle katalogu %llu wskazuje na nie istniejÄ…cy i-wÄ™zÄ™Å‚ %llu"
 
 #: ../repair/phase6.c:1405
 #, c-format
 msgid "entry \"%s\" in dir inode %llu points to free inode %llu"
-msgstr "wpis \"%s\" w i-wê¼le katalogu %llu wskazuje na wolny i-wêze³ %llu"
+msgstr "wpis \"%s\" w i-wÄ™Åºle katalogu %llu wskazuje na wolny i-wÄ™zeÅ‚ %llu"
 
 #: ../repair/phase6.c:1421 ../repair/phase6.c:2086 ../repair/phase6.c:2711
 #: ../repair/phase6.c:3038
 #, c-format
 msgid "%s (ino %llu) in root (%llu) is not a directory"
-msgstr "%s (i-wêze³ %llu) w katalogu g³ównym (%llu) nie jest katalogiem"
+msgstr "%s (i-wÄ™zeÅ‚ %llu) w katalogu gÅ‚Ã³wnym (%llu) nie jest katalogiem"
 
 #: ../repair/phase6.c:1443 ../repair/phase6.c:2107 ../repair/phase6.c:2728
 #: ../repair/phase6.c:3055
 #, c-format
 msgid "entry \"%s\" (ino %llu) in dir %llu is a duplicate name"
-msgstr "wpis \"%s\" (i-wêze³ %llu) w katalogu %llu jest powtórzon± nazw±"
+msgstr "wpis \"%s\" (i-wÄ™zeÅ‚ %llu) w katalogu %llu jest powtÃ³rzonÄ… nazwÄ…"
 
 #: ../repair/phase6.c:1474
 #, c-format
 msgid "entry \"%s\" in dir %llu points to an already connected dir inode %llu,\n"
-msgstr "wpis \"%s\" w katalogu %llu wskazuje na ju¿ pod³±czony i-wêze³ katalogu %llu,\n"
+msgstr "wpis \"%s\" w katalogu %llu wskazuje na juÅ¼ podÅ‚Ä…czony i-wÄ™zeÅ‚ katalogu %llu,\n"
 
 #: ../repair/phase6.c:1483 ../repair/phase6.c:2208 ../repair/phase6.c:2761
 #: ../repair/phase6.c:3086
 #, c-format
 msgid "entry \"%s\" in dir ino %llu doesn't have a .. entry, will set it in ino %llu.\n"
-msgstr "wpis \"%s\" w i-wê¼le katalogu %llu nie ma wpisu .., zostanie ustawiony w i-wê¼le %llu.\n"
+msgstr "wpis \"%s\" w i-wÄ™Åºle katalogu %llu nie ma wpisu .., zostanie ustawiony w i-wÄ™Åºle %llu.\n"
 
 #: ../repair/phase6.c:1491
 #, c-format
 msgid "entry \"%s\" in dir ino %llu not consistent with .. value (%llu) in ino %llu,\n"
-msgstr "wpis \"%s\" w i-wê¼le katalogu %llu niespójny z warto¶ci± .. (%llu) w i-wê¼le %llu,\n"
+msgstr "wpis \"%s\" w i-wÄ™Åºle katalogu %llu niespÃ³jny z wartoÅ›ciÄ… .. (%llu) w i-wÄ™Åºle %llu,\n"
 
 #: ../repair/phase6.c:1506 ../repair/phase6.c:2232
 #, c-format
@@ -8020,62 +8020,62 @@ msgstr "\twpis \"%s\" zostanie wyczyszczony\n"
 #: ../repair/phase6.c:1509 ../repair/phase6.c:2235
 #, c-format
 msgid "\twould clear entry \"%s\"\n"
-msgstr "\twpis \"%s\" zosta³by wyczyszczony\n"
+msgstr "\twpis \"%s\" zostaÅ‚by wyczyszczony\n"
 
 #: ../repair/phase6.c:1553
 #, c-format
 msgid "cannot map block 0 of directory inode %llu\n"
-msgstr "nie mo¿na odwzorowaæ bloku 0 i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odwzorowaÄ‡ bloku 0 i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/phase6.c:1576
 #, c-format
 msgid "bad magic # (0x%x) for dir ino %llu leaf block (bno %u fsbno %llu)\n"
-msgstr "b³êdna liczba magiczna (0x%x) dla bloku li¶cia i-wêz³a katalogu %llu (bno %u fsbno %llu)\n"
+msgstr "bÅ‚Ä™dna liczba magiczna (0x%x) dla bloku liÅ›cia i-wÄ™zÅ‚a katalogu %llu (bno %u fsbno %llu)\n"
 
 #: ../repair/phase6.c:1613 ../repair/phase6.c:1617
 #, c-format
 msgid "can't map leaf block %d in dir %llu, xfs_bmapi returns %d, nmap = %d\n"
-msgstr "nie mo¿na odwzorowaæ bloku li¶cia %d w katalogu %llu, xfs_bmapi zwraca %d, nmap = %d\n"
+msgstr "nie moÅ¼na odwzorowaÄ‡ bloku liÅ›cia %d w katalogu %llu, xfs_bmapi zwraca %d, nmap = %d\n"
 
 #: ../repair/phase6.c:1669
 #, c-format
 msgid "rebuilding directory inode %llu\n"
-msgstr "przebudowywanie i-wêz³a katalogu %llu\n"
+msgstr "przebudowywanie i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/phase6.c:1694
 #, c-format
 msgid "xfs_bmap_last_offset failed -- error - %d\n"
-msgstr "xfs_bmap_last_offset nie powiod³o siê - b³±d %d\n"
+msgstr "xfs_bmap_last_offset nie powiodÅ‚o siÄ™ - bÅ‚Ä…d %d\n"
 
 #: ../repair/phase6.c:1701
 #, c-format
 msgid "xfs_bunmapi failed -- error - %d\n"
-msgstr "xfs_bunmapi nie powiod³o siê - b³±d %d\n"
+msgstr "xfs_bunmapi nie powiodÅ‚o siÄ™ - bÅ‚Ä…d %d\n"
 
 #: ../repair/phase6.c:1743
 #, c-format
 msgid "name create failed in ino %llu (%d), filesystem may be out of space\n"
-msgstr "tworzenie nazwy nie powiod³o siê w i-wê¼le %llu (%d), mo¿e brakowaæ miejsca w systemie plików\n"
+msgstr "tworzenie nazwy nie powiodÅ‚o siÄ™ w i-wÄ™Åºle %llu (%d), moÅ¼e brakowaÄ‡ miejsca w systemie plikÃ³w\n"
 
 #: ../repair/phase6.c:1808
 #, c-format
 msgid "shrink_inode failed inode %llu block %u\n"
-msgstr "shrink_inode nie powiod³o siê dla i-wêz³a %llu bloku %u\n"
+msgstr "shrink_inode nie powiodÅ‚o siÄ™ dla i-wÄ™zÅ‚a %llu bloku %u\n"
 
 #: ../repair/phase6.c:1889
 #, c-format
 msgid "realloc failed in longform_dir2_entry_check_data (%u bytes)\n"
-msgstr "realloc nie powiod³o siê w longform_dir2_entry_check_data (%u bajtów)\n"
+msgstr "realloc nie powiodÅ‚o siÄ™ w longform_dir2_entry_check_data (%u bajtÃ³w)\n"
 
 #: ../repair/phase6.c:1946
 #, c-format
 msgid "empty data block %u in directory inode %llu: "
-msgstr "pusty blok danych %u w i-wê¼le katalogu %llu: "
+msgstr "pusty blok danych %u w i-wÄ™Åºle katalogu %llu: "
 
 #: ../repair/phase6.c:1949
 #, c-format
 msgid "corrupt block %u in directory inode %llu: "
-msgstr "uszkodzony blok %u w i-wê¼le katalogu %llu: "
+msgstr "uszkodzony blok %u w i-wÄ™Åºle katalogu %llu: "
 
 #: ../repair/phase6.c:1953
 msgid "junking block\n"
@@ -8083,50 +8083,50 @@ msgstr "wyrzucono blok\n"
 
 #: ../repair/phase6.c:1956
 msgid "would junk block\n"
-msgstr "blok zosta³by wyrzucony\n"
+msgstr "blok zostaÅ‚by wyrzucony\n"
 
 #: ../repair/phase6.c:1979
 #, c-format
 msgid "bad directory block magic # %#x for directory inode %llu block %d: "
-msgstr "b³êdna liczba magiczna bloku katalogu %#x dla i-wêz³a katalogu %llu bloku %d: "
+msgstr "bÅ‚Ä™dna liczba magiczna bloku katalogu %#x dla i-wÄ™zÅ‚a katalogu %llu bloku %d: "
 
 #: ../repair/phase6.c:1983
 #, c-format
 msgid "fixing magic # to %#x\n"
-msgstr "poprawiono liczbê magiczn± na %#x\n"
+msgstr "poprawiono liczbÄ™ magicznÄ… na %#x\n"
 
 #: ../repair/phase6.c:1987
 #, c-format
 msgid "would fix magic # to %#x\n"
-msgstr "liczba magiczna zosta³aby poprawiona na %#x\n"
+msgstr "liczba magiczna zostaÅ‚aby poprawiona na %#x\n"
 
 #: ../repair/phase6.c:2007
 #, c-format
 msgid "directory inode %llu block %u has consecutive free entries: "
-msgstr "i-wêze³ katalogu %llu blok %u ma kolejne wolne wpisy: "
+msgstr "i-wÄ™zeÅ‚ katalogu %llu blok %u ma kolejne wolne wpisy: "
 
 #: ../repair/phase6.c:2011
 msgid "joining together\n"
-msgstr "po³±czono\n"
+msgstr "poÅ‚Ä…czono\n"
 
 #: ../repair/phase6.c:2020
 msgid "would join together\n"
-msgstr "zosta³yby po³±czone\n"
+msgstr "zostaÅ‚yby poÅ‚Ä…czone\n"
 
 #: ../repair/phase6.c:2051
 #, c-format
 msgid "entry \"%s\" in directory inode %llu points to non-existent inode %llu"
-msgstr "wpis \"%s\" w i-wê¼le katalogu %llu wskazuje na nie istniej±cy i-wêze³ %llu"
+msgstr "wpis \"%s\" w i-wÄ™Åºle katalogu %llu wskazuje na nie istniejÄ…cy i-wÄ™zeÅ‚ %llu"
 
 #: ../repair/phase6.c:2068
 #, c-format
 msgid "entry \"%s\" in directory inode %llu points to free inode %llu"
-msgstr "wpis \"%s\" w i-wê¼le katalogu %llu wskazuje na wolny i-wêze³ %llu"
+msgstr "wpis \"%s\" w i-wÄ™Åºle katalogu %llu wskazuje na wolny i-wÄ™zeÅ‚ %llu"
 
 #: ../repair/phase6.c:2138
 #, c-format
 msgid "entry \"%s\" (ino %llu) in dir %llu is not in the the first block"
-msgstr "wpis \"%s\" (i-wêze³ %llu) w katalogu %llu nie jest w pierwszym bloku"
+msgstr "wpis \"%s\" (i-wÄ™zeÅ‚ %llu) w katalogu %llu nie jest w pierwszym bloku"
 
 #: ../repair/phase6.c:2164
 #, c-format
@@ -8136,97 +8136,97 @@ msgstr "wpis \"%s\" w katalogu %llu nie jest pierwszym wpisem"
 #: ../repair/phase6.c:2200
 #, c-format
 msgid "entry \"%s\" in dir %llu points to an already connected directory inode %llu\n"
-msgstr "wpis \"%s\" w katalogu %llu wskazuje na ju¿ pod³±czony i-wêze³ katalogu %llu\n"
+msgstr "wpis \"%s\" w katalogu %llu wskazuje na juÅ¼ podÅ‚Ä…czony i-wÄ™zeÅ‚ katalogu %llu\n"
 
 #: ../repair/phase6.c:2219
 #, c-format
 msgid "entry \"%s\" in dir inode %llu inconsistent with .. value (%llu) in ino %llu\n"
-msgstr "wpis \"%s\" w i-wê¼le katalogu %llu niespójny z warto¶ci± .. (%llu) w i-wê¼le %llu\n"
+msgstr "wpis \"%s\" w i-wÄ™Åºle katalogu %llu niespÃ³jny z wartoÅ›ciÄ… .. (%llu) w i-wÄ™Åºle %llu\n"
 
 #: ../repair/phase6.c:2289 ../repair/phase6.c:2367
 #, c-format
 msgid "leaf block %u for directory inode %llu bad header\n"
-msgstr "b³êdny nag³ówek bloku li¶cia %u dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dny nagÅ‚Ã³wek bloku liÅ›cia %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/phase6.c:2307
 #, c-format
 msgid "leaf block %u for directory inode %llu bad tail\n"
-msgstr "b³êdna koñcówka bloku li¶cia %u dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dna koÅ„cÃ³wka bloku liÅ›cia %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/phase6.c:2346
 #, c-format
 msgid "can't read leaf block %u for directory inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku li¶cia %u dla i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku liÅ›cia %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/phase6.c:2357
 #, c-format
 msgid "unknown magic number %#x for block %u in directory inode %llu\n"
-msgstr "nieznana liczba magiczna %#x dla bloku %u w i-wê¼le katalogu %llu\n"
+msgstr "nieznana liczba magiczna %#x dla bloku %u w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/phase6.c:2392
 #, c-format
 msgid "can't read freespace block %u for directory inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku wolnego miejsca %u dla i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku wolnego miejsca %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/phase6.c:2404
 #, c-format
 msgid "free block %u for directory inode %llu bad header\n"
-msgstr "b³êdny nag³ówek wolnego bloku %u dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dny nagÅ‚Ã³wek wolnego bloku %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/phase6.c:2417
 #, c-format
 msgid "free block %u entry %i for directory ino %llu bad\n"
-msgstr "b³êdny wpis wolnego bloku %u numer %i dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dny wpis wolnego bloku %u numer %i dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/phase6.c:2426
 #, c-format
 msgid "free block %u for directory inode %llu bad nused\n"
-msgstr "b³êdna liczba nused w wolnym bloku %u dla i-wêz³a katalogu %llu\n"
+msgstr "bÅ‚Ä™dna liczba nused w wolnym bloku %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/phase6.c:2437
 #, c-format
 msgid "missing freetab entry %u for directory inode %llu\n"
-msgstr "brak wpisu freetab %u dla i-wêz³a katalogu %llu\n"
+msgstr "brak wpisu freetab %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/phase6.c:2478
 #, c-format
 msgid "malloc failed in longform_dir2_entry_check (%u bytes)\n"
-msgstr "malloc nie powiod³o siê w longform_dir2_entry_check (%u bajtów)\n"
+msgstr "malloc nie powiodÅ‚o siÄ™ w longform_dir2_entry_check (%u bajtÃ³w)\n"
 
 #: ../repair/phase6.c:2508
 #, c-format
 msgid "realloc failed in longform_dir2_entry_check (%u bytes)\n"
-msgstr "realloc nie powiod³o siê w longform_dir2_entry_check (%u bajtów)\n"
+msgstr "realloc nie powiodÅ‚o siÄ™ w longform_dir2_entry_check (%u bajtÃ³w)\n"
 
 #: ../repair/phase6.c:2514
 #, c-format
 msgid "can't read data block %u for directory inode %llu\n"
-msgstr "nie mo¿na odczytaæ bloku danych %u dla i-wêz³a katalogu %llu\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku danych %u dla i-wÄ™zÅ‚a katalogu %llu\n"
 
 #: ../repair/phase6.c:2619
 #, c-format
 msgid "shortform dir inode %llu has null data entries \n"
-msgstr "i-wêze³ krótkiego katalogu %llu ma zerowe wpisy danych\n"
+msgstr "i-wÄ™zeÅ‚ krÃ³tkiego katalogu %llu ma zerowe wpisy danych\n"
 
 #: ../repair/phase6.c:2686
 #, c-format
 msgid "entry \"%s\" in shortform dir %llu references non-existent ino %llu"
-msgstr "wpis \"%s\" w krótkim katalogu %llu odwo³uje siê do nie istniej±cego i-wêz³a %llu"
+msgstr "wpis \"%s\" w krÃ³tkim katalogu %llu odwoÅ‚uje siÄ™ do nie istniejÄ…cego i-wÄ™zÅ‚a %llu"
 
 #: ../repair/phase6.c:2699
 #, c-format
 msgid "entry \"%s\" in shortform dir inode %llu points to free inode %llu"
-msgstr "wpis \"%s\" w i-wê¼le krótkiego katalogu %llu wskazuje na wolny i-wêze³ %llu"
+msgstr "wpis \"%s\" w i-wÄ™Åºle krÃ³tkiego katalogu %llu wskazuje na wolny i-wÄ™zeÅ‚ %llu"
 
 #: ../repair/phase6.c:2752
 #, c-format
 msgid "entry \"%s\" in dir %llu references already connected dir ino %llu,\n"
-msgstr "wpis \"%s\" w katalogu %llu odwo³uje siê do ju¿ pod³±czonego i-wêz³a katalogu %llu,\n"
+msgstr "wpis \"%s\" w katalogu %llu odwoÅ‚uje siÄ™ do juÅ¼ podÅ‚Ä…czonego i-wÄ™zÅ‚a katalogu %llu,\n"
 
 #: ../repair/phase6.c:2769
 #, c-format
 msgid "entry \"%s\" in dir %llu not consistent with .. value (%llu) in dir ino %llu"
-msgstr "wpis \"%s\" w katalogu %llu niespójny z warto¶ci± .. (%llu) w i-wê¼le katalogu %llu"
+msgstr "wpis \"%s\" w katalogu %llu niespÃ³jny z wartoÅ›ciÄ… .. (%llu) w i-wÄ™Åºle katalogu %llu"
 
 #: ../repair/phase6.c:2811 ../repair/phase6.c:3139
 msgid "junking entry\n"
@@ -8234,113 +8234,113 @@ msgstr "wyrzucono wpis\n"
 
 #: ../repair/phase6.c:2815 ../repair/phase6.c:3143
 msgid "would junk entry\n"
-msgstr "wpis zosta³by wyrzucony\n"
+msgstr "wpis zostaÅ‚by wyrzucony\n"
 
 #: ../repair/phase6.c:2854 ../repair/phase6.c:3198
 #, c-format
 msgid "setting size to %lld bytes to reflect junked entries\n"
-msgstr "ustawiono rozmiar na %lld aby odzwierciedla³ wyrzucone wpisy\n"
+msgstr "ustawiono rozmiar na %lld aby odzwierciedlaÅ‚ wyrzucone wpisy\n"
 
 #: ../repair/phase6.c:2905
 #, c-format
 msgid "would set .. in sf dir inode %llu to %llu\n"
-msgstr "wpis .. w i-wê¼le katalogu sf %llu zosta³oby ustawione na %llu\n"
+msgstr "wpis .. w i-wÄ™Åºle katalogu sf %llu zostaÅ‚oby ustawione na %llu\n"
 
 #: ../repair/phase6.c:2908
 #, c-format
 msgid "setting .. in sf dir inode %llu to %llu\n"
-msgstr "ustawiono wpis .. w i-wê¼le katalogu sf %llu na %llu\n"
+msgstr "ustawiono wpis .. w i-wÄ™Åºle katalogu sf %llu na %llu\n"
 
 #: ../repair/phase6.c:3011
 #, c-format
 msgid "entry \"%s\" in shortform directory %llu references non-existent inode %llu"
-msgstr "wpis \"%s\" w krótkim katalogu %llu odwo³uje siê do nie istniej±cego i-wêz³± %llu"
+msgstr "wpis \"%s\" w krÃ³tkim katalogu %llu odwoÅ‚uje siÄ™ do nie istniejÄ…cego i-wÄ™zÅ‚Ä… %llu"
 
 #: ../repair/phase6.c:3025
 #, c-format
 msgid "entry \"%s\" in shortform directory inode %llu points to free inode %llu"
-msgstr "wpis \"%s\" w i-wê¼le krótkiego katalogu %llu wskazuje na wolny i-wêze³ %llu"
+msgstr "wpis \"%s\" w i-wÄ™Åºle krÃ³tkiego katalogu %llu wskazuje na wolny i-wÄ™zeÅ‚ %llu"
 
 #: ../repair/phase6.c:3076
 #, c-format
 msgid "entry \"%s\" in directory inode %llu references already connected inode %llu,\n"
-msgstr "wpis \"%s\" w i-wê¼le katalogu %llu odwo³uje siê do ju¿ pod³±czonego i-wêz³a %llu,\n"
+msgstr "wpis \"%s\" w i-wÄ™Åºle katalogu %llu odwoÅ‚uje siÄ™ do juÅ¼ podÅ‚Ä…czonego i-wÄ™zÅ‚a %llu,\n"
 
 #: ../repair/phase6.c:3096
 #, c-format
 msgid "entry \"%s\" in directory inode %llu not consistent with .. value (%llu) in inode %llu,\n"
-msgstr "wpis \"%s\" w i-wê¼le katalogu %llu niespójny z warto¶ci± .. (%llu) w i-wê¼le %llu,\n"
+msgstr "wpis \"%s\" w i-wÄ™Åºle katalogu %llu niespÃ³jny z wartoÅ›ciÄ… .. (%llu) w i-wÄ™Åºle %llu,\n"
 
 #: ../repair/phase6.c:3167
 #, c-format
 msgid "would fix i8count in inode %llu\n"
-msgstr "i8count w i-wê¼le %llu zosta³oby poprawione\n"
+msgstr "i8count w i-wÄ™Åºle %llu zostaÅ‚oby poprawione\n"
 
 #: ../repair/phase6.c:3179
 #, c-format
 msgid "fixing i8count in inode %llu\n"
-msgstr "poprawiono i8count w i-wê¼le %llu\n"
+msgstr "poprawiono i8count w i-wÄ™Åºle %llu\n"
 
 #: ../repair/phase6.c:3238 ../repair/phase6.c:3241 ../repair/phase7.c:83
 #, c-format
 msgid "couldn't map inode %llu, err = %d\n"
-msgstr "nie uda³o siê odwzorowaæ i-wêz³a %llu, b³±d = %d\n"
+msgstr "nie udaÅ‚o siÄ™ odwzorowaÄ‡ i-wÄ™zÅ‚a %llu, bÅ‚Ä…d = %d\n"
 
 #: ../repair/phase6.c:3354
 msgid "missing root directory .. entry, cannot fix in V1 dir filesystem\n"
-msgstr "brak wpisu .. w g³ównym katalogu, nie mo¿na naprawiæ w systemie plików V1\n"
+msgstr "brak wpisu .. w gÅ‚Ã³wnym katalogu, nie moÅ¼na naprawiÄ‡ w systemie plikÃ³w V1\n"
 
 #: ../repair/phase6.c:3360
 #, c-format
 msgid "%d bad entries found in dir inode %llu, cannot fix in V1 dir filesystem\n"
-msgstr "znaleziono %d b³êdnych wpisów w i-wê¼le kataloug %llu, nie mo¿na naprawiæ w systemie plików V1\n"
+msgstr "znaleziono %d bÅ‚Ä™dnych wpisÃ³w w i-wÄ™Åºle kataloug %llu, nie moÅ¼na naprawiÄ‡ w systemie plikÃ³w V1\n"
 
 #: ../repair/phase6.c:3367
 #, c-format
 msgid "missing \".\" entry in dir ino %llu, cannot in fix V1 dir filesystem\n"
-msgstr "brak wpisu \".\" w i-wê¼le katalogu %llu, nie mo¿na naprawiæ w systemie plików V1\n"
+msgstr "brak wpisu \".\" w i-wÄ™Åºle katalogu %llu, nie moÅ¼na naprawiÄ‡ w systemie plikÃ³w V1\n"
 
 #: ../repair/phase6.c:3386
 msgid "recreating root directory .. entry\n"
-msgstr "ponowne tworzenie wpisu .. g³ównego katalogu\n"
+msgstr "ponowne tworzenie wpisu .. gÅ‚Ã³wnego katalogu\n"
 
 #: ../repair/phase6.c:3405
 #, c-format
 msgid "can't make \"..\" entry in root inode %llu, createname error %d\n"
-msgstr "nie mo¿na utworzyæ wpisu \"..\" w i-wê¼le g³ównego katalogu %llu, b³±d createname %d\n"
+msgstr "nie moÅ¼na utworzyÄ‡ wpisu \"..\" w i-wÄ™Åºle gÅ‚Ã³wnego katalogu %llu, bÅ‚Ä…d createname %d\n"
 
 #: ../repair/phase6.c:3417
 msgid "would recreate root directory .. entry\n"
-msgstr "wpis .. g³ównego katalogu zosta³by ponownie utworzony\n"
+msgstr "wpis .. gÅ‚Ã³wnego katalogu zostaÅ‚by ponownie utworzony\n"
 
 #: ../repair/phase6.c:3440
 #, c-format
 msgid "would create missing \".\" entry in dir ino %llu\n"
-msgstr "brakuj±cy wpis \".\" w i-wê¼le katalogu %llu zosta³by utworzony\n"
+msgstr "brakujÄ…cy wpis \".\" w i-wÄ™Åºle katalogu %llu zostaÅ‚by utworzony\n"
 
 #: ../repair/phase6.c:3446
 #, c-format
 msgid "creating missing \".\" entry in dir ino %llu\n"
-msgstr "tworzenie brakuj±cego wpisu \".\" w i-wê¼le katalogu %llu\n"
+msgstr "tworzenie brakujÄ…cego wpisu \".\" w i-wÄ™Åºle katalogu %llu\n"
 
 #: ../repair/phase6.c:3470
 #, c-format
 msgid "can't make \".\" entry in dir ino %llu, createname error %d\n"
-msgstr "nie mo¿na utworzyæ wpisu \".\" w i-wê¼le katalogu %llu, b³±d createname %d\n"
+msgstr "nie moÅ¼na utworzyÄ‡ wpisu \".\" w i-wÄ™Åºle katalogu %llu, bÅ‚Ä…d createname %d\n"
 
 #: ../repair/phase6.c:3560
 #, c-format
 msgid "disconnected dir inode %llu, "
-msgstr "od³±czony i-wêze³ katalogu %llu, "
+msgstr "odÅ‚Ä…czony i-wÄ™zeÅ‚ katalogu %llu, "
 
 #: ../repair/phase6.c:3562
 #, c-format
 msgid "disconnected inode %llu, "
-msgstr "od³±czony i-wêze³ %llu, "
+msgstr "odÅ‚Ä…czony i-wÄ™zeÅ‚ %llu, "
 
 #: ../repair/phase6.c:3564
 msgid "cannot fix in V1 dir filesystem\n"
-msgstr "nie mo¿na naprawiæ w systemie plików katalogów V1\n"
+msgstr "nie moÅ¼na naprawiÄ‡ w systemie plikÃ³w katalogÃ³w V1\n"
 
 #: ../repair/phase6.c:3568
 #, c-format
@@ -8350,88 +8350,88 @@ msgstr "przeniesiono do %s\n"
 #: ../repair/phase6.c:3571
 #, c-format
 msgid "would move to %s\n"
-msgstr "zosta³by przeniesiony do %s\n"
+msgstr "zostaÅ‚by przeniesiony do %s\n"
 
 #: ../repair/phase6.c:3662
 msgid "Phase 6 - check inode connectivity...\n"
-msgstr "Faza 6 - sprawdzanie ³±czno¶ci i-wêz³ów...\n"
+msgstr "Faza 6 - sprawdzanie Å‚Ä…cznoÅ›ci i-wÄ™zÅ‚Ã³w...\n"
 
 #: ../repair/phase6.c:3681
 msgid "need to reinitialize root directory, but not supported on V1 dir filesystem\n"
-msgstr "trzeba ponownie utworzyæ g³ówny katalog, co nie jest obs³ugiwane w systemie plików V1\n"
+msgstr "trzeba ponownie utworzyÄ‡ gÅ‚Ã³wny katalog, co nie jest obsÅ‚ugiwane w systemie plikÃ³w V1\n"
 
 #: ../repair/phase6.c:3684
 msgid "reinitializing root directory\n"
-msgstr "ponowne inicjowanie g³ównego katalogu\n"
+msgstr "ponowne inicjowanie gÅ‚Ã³wnego katalogu\n"
 
 #: ../repair/phase6.c:3689
 msgid "would reinitialize root directory\n"
-msgstr "g³ówny katalog zosta³by ponownie zainicjowany\n"
+msgstr "gÅ‚Ã³wny katalog zostaÅ‚by ponownie zainicjowany\n"
 
 #: ../repair/phase6.c:3695
 msgid "reinitializing realtime bitmap inode\n"
-msgstr "ponowne inicjowanie i-wêz³a bitmapy realtime\n"
+msgstr "ponowne inicjowanie i-wÄ™zÅ‚a bitmapy realtime\n"
 
 #: ../repair/phase6.c:3699
 msgid "would reinitialize realtime bitmap inode\n"
-msgstr "i-wêze³ bitmapy realtime zosta³by ponownie zainicjowany\n"
+msgstr "i-wÄ™zeÅ‚ bitmapy realtime zostaÅ‚by ponownie zainicjowany\n"
 
 #: ../repair/phase6.c:3705
 msgid "reinitializing realtime summary inode\n"
-msgstr "ponowne inicjowanie i-wêz³a opisu realtime\n"
+msgstr "ponowne inicjowanie i-wÄ™zÅ‚a opisu realtime\n"
 
 #: ../repair/phase6.c:3709
 msgid "would reinitialize realtime summary inode\n"
-msgstr "i-wêze³ opisu realtime zosta³by ponownie zainicjowany\n"
+msgstr "i-wÄ™zeÅ‚ opisu realtime zostaÅ‚by ponownie zainicjowany\n"
 
 #: ../repair/phase6.c:3715
 msgid "        - resetting contents of realtime bitmap and summary inodes\n"
-msgstr "        - przestawianie zawarto¶ci i-wêz³ów bitmapy i opisu realtime\n"
+msgstr "        - przestawianie zawartoÅ›ci i-wÄ™zÅ‚Ã³w bitmapy i opisu realtime\n"
 
 #: ../repair/phase6.c:3718 ../repair/phase6.c:3723
 msgid "Warning:  realtime bitmap may be inconsistent\n"
-msgstr "Uwaga: bitmapa realtime mo¿e byæ niespójna\n"
+msgstr "Uwaga: bitmapa realtime moÅ¼e byÄ‡ niespÃ³jna\n"
 
 #: ../repair/phase6.c:3729
 msgid "        - traversing filesystem ...\n"
-msgstr "        - przechodzenie systemu plików...\n"
+msgstr "        - przechodzenie systemu plikÃ³w...\n"
 
 #: ../repair/phase6.c:3752
 msgid "        - traversal finished ...\n"
-msgstr "        - przechodzenie zakoñczone...\n"
+msgstr "        - przechodzenie zakoÅ„czone...\n"
 
 #: ../repair/phase6.c:3753
 #, c-format
 msgid "        - moving disconnected inodes to %s ...\n"
-msgstr "        - przenoszenie od³±czonych i-wêz³ów do %s...\n"
+msgstr "        - przenoszenie odÅ‚Ä…czonych i-wÄ™zÅ‚Ã³w do %s...\n"
 
 #: ../repair/phase7.c:43
 #, c-format
 msgid "resetting inode %llu nlinks from %d to %d\n"
-msgstr "przestawiono nlinks i-wêz³a %llu z %d na %d\n"
+msgstr "przestawiono nlinks i-wÄ™zÅ‚a %llu z %d na %d\n"
 
 #: ../repair/phase7.c:49
 #, c-format
 msgid "nlinks %d will overflow v1 ino, ino %llu will be converted to version 2\n"
-msgstr "nlinks %d przepe³ni i-wêze³ v1, i-wêze³ %llu bêdzie skonwertowany do wersji 2\n"
+msgstr "nlinks %d przepeÅ‚ni i-wÄ™zeÅ‚ v1, i-wÄ™zeÅ‚ %llu bÄ™dzie skonwertowany do wersji 2\n"
 
 #: ../repair/phase7.c:55
 #, c-format
 msgid "would have reset inode %llu nlinks from %d to %d\n"
-msgstr "nlinks i-wêz³a %llu zosta³oby przestawione z %d na %d\n"
+msgstr "nlinks i-wÄ™zÅ‚a %llu zostaÅ‚oby przestawione z %d na %d\n"
 
 #: ../repair/phase7.c:87
 #, c-format
 msgid "couldn't map inode %llu, err = %d, can't compare link counts\n"
-msgstr "nie uda³o siê odwzorowaæ i-wêz³a %llu, b³±d %d, nie mo¿na porównaæ liczby dowi±zañ\n"
+msgstr "nie udaÅ‚o siÄ™ odwzorowaÄ‡ i-wÄ™zÅ‚a %llu, bÅ‚Ä…d %d, nie moÅ¼na porÃ³wnaÄ‡ liczby dowiÄ…zaÅ„\n"
 
 #: ../repair/phase7.c:126
 msgid "Phase 7 - verify and correct link counts...\n"
-msgstr "Faza 7 - sprawdzanie i poprawianie liczby dowi±zañ...\n"
+msgstr "Faza 7 - sprawdzanie i poprawianie liczby dowiÄ…zaÅ„...\n"
 
 #: ../repair/phase7.c:128
 msgid "Phase 7 - verify link counts...\n"
-msgstr "Faza 7 - sprawdzanie liczby dowi±zañ...\n"
+msgstr "Faza 7 - sprawdzanie liczby dowiÄ…zaÅ„...\n"
 
 #: ../repair/prefetch.c:473
 msgid "prefetch corruption\n"
@@ -8440,27 +8440,27 @@ msgstr "uszkodzenie prefetch\n"
 #: ../repair/prefetch.c:628 ../repair/prefetch.c:724
 #, c-format
 msgid "failed to create prefetch thread: %s\n"
-msgstr "nie uda³o siê utworzyæ w±tku prefetch: %s\n"
+msgstr "nie udaÅ‚o siÄ™ utworzyÄ‡ wÄ…tku prefetch: %s\n"
 
 #: ../repair/prefetch.c:762
 msgid "failed to initialize prefetch mutex\n"
-msgstr "nie uda³o siê zainicjowaæ muteksu prefetch\n"
+msgstr "nie udaÅ‚o siÄ™ zainicjowaÄ‡ muteksu prefetch\n"
 
 #: ../repair/prefetch.c:764 ../repair/prefetch.c:766
 msgid "failed to initialize prefetch cond var\n"
-msgstr "nie uda³o siê zainicjowaæ zmiennej warunkowej prefetch\n"
+msgstr "nie udaÅ‚o siÄ™ zainicjowaÄ‡ zmiennej warunkowej prefetch\n"
 
 #: ../repair/progress.c:16
 msgid "inodes"
-msgstr "i-wêz³ów"
+msgstr "i-wÄ™zÅ‚Ã³w"
 
 #: ../repair/progress.c:18
 msgid "blocks"
-msgstr "bloków"
+msgstr "blokÃ³w"
 
 #: ../repair/progress.c:20
 msgid "directories"
-msgstr "katalogów"
+msgstr "katalogÃ³w"
 
 #: ../repair/progress.c:22
 msgid "allocation groups"
@@ -8468,19 +8468,19 @@ msgstr "grup alokacji"
 
 #: ../repair/progress.c:24
 msgid "AGI unlinked buckets"
-msgstr "od³±czonych kube³ków AGI"
+msgstr "odÅ‚Ä…czonych kubeÅ‚kÃ³w AGI"
 
 #: ../repair/progress.c:26
 msgid "extents"
-msgstr "fragmentów"
+msgstr "fragmentÃ³w"
 
 #: ../repair/progress.c:28
 msgid "realtime extents"
-msgstr "fragmentów realtime"
+msgstr "fragmentÃ³w realtime"
 
 #: ../repair/progress.c:30
 msgid "unlinked lists"
-msgstr "od³±czonych list"
+msgstr "odÅ‚Ä…czonych list"
 
 #: ../repair/progress.c:37
 #, c-format
@@ -8494,27 +8494,27 @@ msgstr "        - %02d:%02d:%02d: %s - sprawdzono %llu %s\n"
 
 #: ../repair/progress.c:51
 msgid "scanning filesystem freespace"
-msgstr "przeszukiwanie wolnego miejsca w systemie plików"
+msgstr "przeszukiwanie wolnego miejsca w systemie plikÃ³w"
 
 #: ../repair/progress.c:53
 msgid "scanning agi unlinked lists"
-msgstr "przeszukiwanie od³±czonych list agi"
+msgstr "przeszukiwanie odÅ‚Ä…czonych list agi"
 
 #: ../repair/progress.c:55
 msgid "check uncertain AG inodes"
-msgstr "sprawdzanie niepewnych i-wêz³ów AG"
+msgstr "sprawdzanie niepewnych i-wÄ™zÅ‚Ã³w AG"
 
 #: ../repair/progress.c:57
 msgid "process known inodes and inode discovery"
-msgstr "przetwarzanie znanych i-wêz³ów i rozpoznawanie i-wêz³ów"
+msgstr "przetwarzanie znanych i-wÄ™zÅ‚Ã³w i rozpoznawanie i-wÄ™zÅ‚Ã³w"
 
 #: ../repair/progress.c:59
 msgid "process newly discovered inodes"
-msgstr "przetwarzanie nowo rozpoznanych i-wêz³ów"
+msgstr "przetwarzanie nowo rozpoznanych i-wÄ™zÅ‚Ã³w"
 
 #: ../repair/progress.c:61
 msgid "setting up duplicate extent list"
-msgstr "tworzenie listy powtórzonych fragmentów"
+msgstr "tworzenie listy powtÃ³rzonych fragmentÃ³w"
 
 #: ../repair/progress.c:63
 msgid "initialize realtime bitmap"
@@ -8526,55 +8526,55 @@ msgstr "ponowne tworzenie bitmapy realtime"
 
 #: ../repair/progress.c:67
 msgid "check for inodes claiming duplicate blocks"
-msgstr "szukanie i-wêz³ów odwo³uj±cych siê do powtórzonych bloków"
+msgstr "szukanie i-wÄ™zÅ‚Ã³w odwoÅ‚ujÄ…cych siÄ™ do powtÃ³rzonych blokÃ³w"
 
 #: ../repair/progress.c:69
 msgid "rebuild AG headers and trees"
-msgstr "przebudowywanie nag³ówków i drzew AG"
+msgstr "przebudowywanie nagÅ‚Ã³wkÃ³w i drzew AG"
 
 #: ../repair/progress.c:71
 msgid "traversing filesystem"
-msgstr "przechodzenie systemu plików"
+msgstr "przechodzenie systemu plikÃ³w"
 
 #: ../repair/progress.c:73
 msgid "traversing all unattached subtrees"
-msgstr "przechodzenie wszystkich od³±czonych poddrzew"
+msgstr "przechodzenie wszystkich odÅ‚Ä…czonych poddrzew"
 
 #: ../repair/progress.c:75
 msgid "moving disconnected inodes to lost+found"
-msgstr "przenoszenie od³±czonych i-wêz³ów do lost+found"
+msgstr "przenoszenie odÅ‚Ä…czonych i-wÄ™zÅ‚Ã³w do lost+found"
 
 #: ../repair/progress.c:77
 msgid "verify and correct link counts"
-msgstr "sprawdzanie i poprawianie liczby dowi±zañ"
+msgstr "sprawdzanie i poprawianie liczby dowiÄ…zaÅ„"
 
 #: ../repair/progress.c:79
 msgid "verify link counts"
-msgstr "sprawdzanie liczby dowi±zañ"
+msgstr "sprawdzanie liczby dowiÄ…zaÅ„"
 
 #: ../repair/progress.c:118
 msgid "cannot malloc pointer to done vector\n"
-msgstr "nie uda³o siê przydzieliæ wska¼nika do wektora wykonania\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ wskaÅºnika do wektora wykonania\n"
 
 #: ../repair/progress.c:134
 msgid "unable to create progress report thread\n"
-msgstr "nie uda³o siê utworzyæ w±tku raportowania postêpu\n"
+msgstr "nie udaÅ‚o siÄ™ utworzyÄ‡ wÄ…tku raportowania postÄ™pu\n"
 
 #: ../repair/progress.c:173
 msgid "progress_rpt: cannot malloc progress msg buffer\n"
-msgstr "progress_rpt: nie uda³o siê przydzieliæ bufora komunikatów postêpu\n"
+msgstr "progress_rpt: nie udaÅ‚o siÄ™ przydzieliÄ‡ bufora komunikatÃ³w postÄ™pu\n"
 
 #: ../repair/progress.c:187
 msgid "progress_rpt: cannot create timer\n"
-msgstr "progress_rpt: nie mo¿na utworzyæ zegara\n"
+msgstr "progress_rpt: nie moÅ¼na utworzyÄ‡ zegara\n"
 
 #: ../repair/progress.c:190
 msgid "progress_rpt: cannot set timer\n"
-msgstr "progress_rpt: nie mo¿na ustawiæ zegara\n"
+msgstr "progress_rpt: nie moÅ¼na ustawiÄ‡ zegara\n"
 
 #: ../repair/progress.c:214
 msgid "progress_rpt: cannot lock progress mutex\n"
-msgstr "progress_rpt: nie mo¿na zablokowaæ muteksu\n"
+msgstr "progress_rpt: nie moÅ¼na zablokowaÄ‡ muteksu\n"
 
 #: ../repair/progress.c:251 ../repair/progress.c:354
 #, c-format
@@ -8584,36 +8584,36 @@ msgstr "%s"
 #: ../repair/progress.c:259
 #, c-format
 msgid "\t- %02d:%02d:%02d: Phase %d: elapsed time %s - processed %d %s per minute\n"
-msgstr "\t- %02d:%02d:%02d: Faza %d: miniony czas %s - przetworzono %d %s na minutê\n"
+msgstr "\t- %02d:%02d:%02d: Faza %d: miniony czas %s - przetworzono %d %s na minutÄ™\n"
 
 #: ../repair/progress.c:264
 #, c-format
 msgid "\t- %02d:%02d:%02d: Phase %d: %llu%% done - estimated remaining time %s\n"
-msgstr "\t- %02d:%02d:%02d: Faza %d: %llu%% zrobione - przewidywany pozosta³y czas %s\n"
+msgstr "\t- %02d:%02d:%02d: Faza %d: %llu%% zrobione - przewidywany pozostaÅ‚y czas %s\n"
 
 #: ../repair/progress.c:272
 msgid "progress_rpt: error unlock msg mutex\n"
-msgstr "progress_rpt: b³±d odblokowywania muteksu komunikatów\n"
+msgstr "progress_rpt: bÅ‚Ä…d odblokowywania muteksu komunikatÃ³w\n"
 
 #: ../repair/progress.c:278
 msgid "cannot delete timer\n"
-msgstr "nie mo¿na usun±æ zegara\n"
+msgstr "nie moÅ¼na usunÄ…Ä‡ zegara\n"
 
 #: ../repair/progress.c:292
 msgid "set_progress_msg: cannot lock progress mutex\n"
-msgstr "set_progress_msg: nie mo¿na zablokowaæ mutekstu postêpu\n"
+msgstr "set_progress_msg: nie moÅ¼na zablokowaÄ‡ mutekstu postÄ™pu\n"
 
 #: ../repair/progress.c:302
 msgid "set_progress_msg: cannot unlock progress mutex\n"
-msgstr "set_progress_msg: nie mo¿na odblokowaæ mutekstu postêpu\n"
+msgstr "set_progress_msg: nie moÅ¼na odblokowaÄ‡ mutekstu postÄ™pu\n"
 
 #: ../repair/progress.c:322
 msgid "print_final_rpt: cannot lock progress mutex\n"
-msgstr "print_final_rpt: nie mo¿na zablokowaæ mutekstu postêpu\n"
+msgstr "print_final_rpt: nie moÅ¼na zablokowaÄ‡ mutekstu postÄ™pu\n"
 
 #: ../repair/progress.c:358
 msgid "print_final_rpt: cannot unlock progress mutex\n"
-msgstr "print_final_rpt: nie mo¿na odblokowaæ muteksu postêpu\n"
+msgstr "print_final_rpt: nie moÅ¼na odblokowaÄ‡ muteksu postÄ™pu\n"
 
 #: ../repair/progress.c:407
 #, c-format
@@ -8662,12 +8662,12 @@ msgstr ""
 
 #: ../repair/progress.c:511
 msgid "Phase\t\tStart\t\tEnd\t\tDuration\n"
-msgstr "Faza\t\tPocz±tek\tKoniec\t\tCzas trwania\n"
+msgstr "Faza\t\tPoczÄ…tek\tKoniec\t\tCzas trwania\n"
 
 #: ../repair/progress.c:516 ../repair/progress.c:519
 #, c-format
 msgid "Phase %d:\tSkipped\n"
-msgstr "Faza %d:\tPominiêta\n"
+msgstr "Faza %d:\tPominiÄ™ta\n"
 
 #: ../repair/progress.c:523
 #, c-format
@@ -8681,40 +8681,40 @@ msgid ""
 "Total run time: %s\n"
 msgstr ""
 "\n"
-"Ca³kowity czas trwania: %s\n"
+"CaÅ‚kowity czas trwania: %s\n"
 
 #: ../repair/rt.c:47
 msgid "couldn't allocate memory for incore realtime bitmap.\n"
-msgstr "nie uda³o siê przydzieliæ pamiêci dla bitmapy realtime.\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ pamiÄ™ci dla bitmapy realtime.\n"
 
 #: ../repair/rt.c:51
 msgid "couldn't allocate memory for incore realtime summary info.\n"
-msgstr "nie uda³o siê przydzieliæ pamiêci dla opisu realtime.\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ pamiÄ™ci dla opisu realtime.\n"
 
 #: ../repair/rt.c:151
 #, c-format
 msgid "rt summary mismatch, size %d block %llu, file: %d, computed: %d\n"
-msgstr "opis rt nie zgadza siê, rozmiar %d bloku %llu, plik: %d, obliczono: %d\n"
+msgstr "opis rt nie zgadza siÄ™, rozmiar %d bloku %llu, plik: %d, obliczono: %d\n"
 
 #: ../repair/rt.c:203
 #, c-format
 msgid "can't find block %d for rtbitmap inode\n"
-msgstr "nie mo¿na odnale¼æ bloku %d dla i-wêz³a bitmapy realtime\n"
+msgstr "nie moÅ¼na odnaleÅºÄ‡ bloku %d dla i-wÄ™zÅ‚a bitmapy realtime\n"
 
 #: ../repair/rt.c:211
 #, c-format
 msgid "can't read block %d for rtbitmap inode\n"
-msgstr "nie mo¿na odczytaæ bloku %d dla i-wêz³a bitmapy realtime\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku %d dla i-wÄ™zÅ‚a bitmapy realtime\n"
 
 #: ../repair/rt.c:265
 #, c-format
 msgid "block %d for rtsummary inode is missing\n"
-msgstr "brak bloku %d dla i-wêz³a opisu realtime\n"
+msgstr "brak bloku %d dla i-wÄ™zÅ‚a opisu realtime\n"
 
 #: ../repair/rt.c:273
 #, c-format
 msgid "can't read block %d for rtsummary inode\n"
-msgstr "nie mo¿na odczytaæ bloku %d dla i-wêz³a opisu realtime\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku %d dla i-wÄ™zÅ‚a opisu realtime\n"
 
 #: ../repair/sb.c:100
 msgid ""
@@ -8722,11 +8722,11 @@ msgid ""
 "attempting to find secondary superblock...\n"
 msgstr ""
 "\n"
-"próba odnalezienia zapasowego superbloku...\n"
+"prÃ³ba odnalezienia zapasowego superbloku...\n"
 
 #: ../repair/sb.c:105
 msgid "error finding secondary superblock -- failed to memalign buffer\n"
-msgstr "b³±d podczas szukania zapasowego superbloku - nie uda³o siê memalign bufora\n"
+msgstr "bÅ‚Ä…d podczas szukania zapasowego superbloku - nie udaÅ‚o siÄ™ memalign bufora\n"
 
 #: ../repair/sb.c:142
 msgid "found candidate secondary superblock...\n"
@@ -8738,81 +8738,81 @@ msgstr "sprawdzono zapasowy superblok...\n"
 
 #: ../repair/sb.c:159
 msgid "unable to verify superblock, continuing...\n"
-msgstr "nie uda³o siê sprawdziæ superbloku, kontynuacja...\n"
+msgstr "nie udaÅ‚o siÄ™ sprawdziÄ‡ superbloku, kontynuacja...\n"
 
 #: ../repair/sb.c:457
 msgid "failed to memalign superblock buffer\n"
-msgstr "nie uda³o siê wykonaæ memalign dla bufora superbloku\n"
+msgstr "nie udaÅ‚o siÄ™ wykonaÄ‡ memalign dla bufora superbloku\n"
 
 #: ../repair/sb.c:464
 msgid "couldn't seek to offset 0 in filesystem\n"
-msgstr "nie uda³o siê wykonaæ seek na offset 0 w systemie plików\n"
+msgstr "nie udaÅ‚o siÄ™ wykonaÄ‡ seek na offset 0 w systemie plikÃ³w\n"
 
 #: ../repair/sb.c:472
 msgid "primary superblock write failed!\n"
-msgstr "zapis g³ównego superbloku nie powiód³ siê!\n"
+msgstr "zapis gÅ‚Ã³wnego superbloku nie powiÃ³dÅ‚ siÄ™!\n"
 
 #: ../repair/sb.c:490
 #, c-format
 msgid "error reading superblock %u -- failed to memalign buffer\n"
-msgstr "b³±d podczas odczytu superbloku %u - nie uda³o siê wykonaæ memalign dla bufora\n"
+msgstr "bÅ‚Ä…d podczas odczytu superbloku %u - nie udaÅ‚o siÄ™ wykonaÄ‡ memalign dla bufora\n"
 
 #: ../repair/sb.c:500
 #, c-format
 msgid "error reading superblock %u -- seek to offset %lld failed\n"
-msgstr "b³±d podczas odczytu superbloku %u - seek na offset %lld nie powiód³ siê\n"
+msgstr "bÅ‚Ä…d podczas odczytu superbloku %u - seek na offset %lld nie powiÃ³dÅ‚ siÄ™\n"
 
 #: ../repair/sb.c:508
 #, c-format
 msgid "superblock read failed, offset %lld, size %d, ag %u, rval %d\n"
-msgstr "odczyt superbloku nie powiód³ siê, offset %lld, rozmiar %d, ag %u, rval %d\n"
+msgstr "odczyt superbloku nie powiÃ³dÅ‚ siÄ™, offset %lld, rozmiar %d, ag %u, rval %d\n"
 
 #: ../repair/sb.c:556
 msgid "couldn't malloc geometry structure\n"
-msgstr "nie uda³o siê przydzieliæ struktury geometrii\n"
+msgstr "nie udaÅ‚o siÄ™ przydzieliÄ‡ struktury geometrii\n"
 
 #: ../repair/sb.c:701
 msgid "calloc failed in verify_set_primary_sb\n"
-msgstr "calloc nie powiod³o siê w verify_set_primary_sb\n"
+msgstr "calloc nie powiodÅ‚o siÄ™ w verify_set_primary_sb\n"
 
 #: ../repair/sb.c:772
 msgid ""
 "Only two AGs detected and they do not match - cannot validate filesystem geometry.\n"
 "Use the -o force_geometry option to proceed.\n"
 msgstr ""
-"Wykryto tylko dwie AG i nie zgadzaj± siê - nie mo¿na sprawdziæ poprawno¶ci geometrii systemu plików.\n"
-"Proszê u¿yæ opcji -o force_geometry, aby kontynuowaæ.\n"
+"Wykryto tylko dwie AG i nie zgadzajÄ… siÄ™ - nie moÅ¼na sprawdziÄ‡ poprawnoÅ›ci geometrii systemu plikÃ³w.\n"
+"ProszÄ™ uÅ¼yÄ‡ opcji -o force_geometry, aby kontynuowaÄ‡.\n"
 
 #: ../repair/sb.c:788
 msgid ""
 "Only one AG detected - cannot validate filesystem geometry.\n"
 "Use the -o force_geometry option to proceed.\n"
 msgstr ""
-"Wykryto tylko dwie AG - nie mo¿na sprawdziæ poprawno¶ci geometrii systemu plików.\n"
-"Proszê u¿yæ opcji -o force_geometry, aby kontynuowaæ.\n"
+"Wykryto tylko dwie AG - nie moÅ¼na sprawdziÄ‡ poprawnoÅ›ci geometrii systemu plikÃ³w.\n"
+"ProszÄ™ uÅ¼yÄ‡ opcji -o force_geometry, aby kontynuowaÄ‡.\n"
 
 #: ../repair/sb.c:803
 msgid "Not enough matching superblocks - cannot proceed.\n"
-msgstr "Za ma³o pasuj±cych superbloków - nie mo¿na kontynuowaæ.\n"
+msgstr "Za maÅ‚o pasujÄ…cych superblokÃ³w - nie moÅ¼na kontynuowaÄ‡.\n"
 
 #: ../repair/sb.c:818
 msgid "could not read superblock\n"
-msgstr "nie uda³o siê odczytaæ superbloku\n"
+msgstr "nie udaÅ‚o siÄ™ odczytaÄ‡ superbloku\n"
 
 #: ../repair/scan.c:63 ../repair/scan.c:107
 #, c-format
 msgid "can't read btree block %d/%d\n"
-msgstr "nie mo¿na odczytaæ bloku b-drzewa %d/%d\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku b-drzewa %d/%d\n"
 
 #: ../repair/scan.c:165
 #, c-format
 msgid "bad magic # %#x in inode %llu (%s fork) bmbt block %llu\n"
-msgstr "b³êdna liczba magiczna %#x w i-wê¼le %llu (ga³±¼ %s) blok bmbt %llu\n"
+msgstr "bÅ‚Ä™dna liczba magiczna %#x w i-wÄ™Åºle %llu (gaÅ‚Ä…Åº %s) blok bmbt %llu\n"
 
 #: ../repair/scan.c:171
 #, c-format
 msgid "expected level %d got %d in inode %llu, (%s fork) bmbt block %llu\n"
-msgstr "oczekiwano poziomu %d, a uzyskano %d w i-wê¼le %llu, (ga³êzi %s) blok bmbt %llu\n"
+msgstr "oczekiwano poziomu %d, a uzyskano %d w i-wÄ™Åºle %llu, (gaÅ‚Ä™zi %s) blok bmbt %llu\n"
 
 #: ../repair/scan.c:191
 #, c-format
@@ -8820,8 +8820,8 @@ msgid ""
 "bad fwd (right) sibling pointer (saw %llu parent block says %llu)\n"
 "\tin inode %llu (%s fork) bmap btree block %llu\n"
 msgstr ""
-"b³êdny wska¼nik w przód (prawy) (widziano %llu, blok nadrzêdny mówi %llu)\n"
-"\tw i-wê¼le %llu (ga³êzi %s) bloku bmap btree %llu\n"
+"bÅ‚Ä™dny wskaÅºnik w przÃ³d (prawy) (widziano %llu, blok nadrzÄ™dny mÃ³wi %llu)\n"
+"\tw i-wÄ™Åºle %llu (gaÅ‚Ä™zi %s) bloku bmap btree %llu\n"
 
 #: ../repair/scan.c:201
 #, c-format
@@ -8829,8 +8829,8 @@ msgid ""
 "bad back (left) sibling pointer (saw %llu parent block says %llu)\n"
 "\tin inode %llu (%s fork) bmap btree block %llu\n"
 msgstr ""
-"b³êdny wska¼nik wstecz (lewy) (widziano %llu, blok nadrzêdny mówi %llu)\n"
-"\tw i-wê¼le %llu (ga³êzi %s) bloku bmap btree %llu\n"
+"bÅ‚Ä™dny wskaÅºnik wstecz (lewy) (widziano %llu, blok nadrzÄ™dny mÃ³wi %llu)\n"
+"\tw i-wÄ™Åºle %llu (gaÅ‚Ä™zi %s) bloku bmap btree %llu\n"
 
 #: ../repair/scan.c:215
 #, c-format
@@ -8838,28 +8838,28 @@ msgid ""
 "bad back (left) sibling pointer (saw %llu should be NULL (0))\n"
 "\tin inode %llu (%s fork) bmap btree block %llu\n"
 msgstr ""
-"b³êdny wska¼nik wstecz (lewy) (widziano %llu, powinien byæ NULL (0))\n"
-"\tw i-wê¼le %llu (ga³êzi %s) bloku bmap btree %llu\n"
+"bÅ‚Ä™dny wskaÅºnik wstecz (lewy) (widziano %llu, powinien byÄ‡ NULL (0))\n"
+"\tw i-wÄ™Åºle %llu (gaÅ‚Ä™zi %s) bloku bmap btree %llu\n"
 
 #: ../repair/scan.c:250 ../repair/scan.c:258
 #, c-format
 msgid "inode 0x%llx bmap block 0x%llx claimed, state is %d\n"
-msgstr "i-wêze³ 0x%llx blok bmap 0x%llx przypisany, stan to %d\n"
+msgstr "i-wÄ™zeÅ‚ 0x%llx blok bmap 0x%llx przypisany, stan to %d\n"
 
 #: ../repair/scan.c:274
 #, c-format
 msgid "bad state %d, inode 0x%llx bmap block 0x%llx\n"
-msgstr "b³êdny stan %d, i-wêze³ 0x%llx blok bmap 0x%llx\n"
+msgstr "bÅ‚Ä™dny stan %d, i-wÄ™zeÅ‚ 0x%llx blok bmap 0x%llx\n"
 
 #: ../repair/scan.c:300 ../repair/scan.c:350
 #, c-format
 msgid "inode 0x%llx bad # of bmap records (%u, min - %u, max - %u)\n"
-msgstr "b³êdna liczba rekordów bmap w i-wê¼le 0x%llx (%u, minimum - %u, maksimum - %u)\n"
+msgstr "bÅ‚Ä™dna liczba rekordÃ³w bmap w i-wÄ™Åºle 0x%llx (%u, minimum - %u, maksimum - %u)\n"
 
 #: ../repair/scan.c:330
 #, c-format
 msgid "out-of-order bmap key (file offset) in inode %llu, %s fork, fsbno %llu\n"
-msgstr "uszkodzony klucz bmap (offset pliku) w i-wê¼le %llu, ga³êzi %s, fsbno %llu\n"
+msgstr "uszkodzony klucz bmap (offset pliku) w i-wÄ™Åºle %llu, gaÅ‚Ä™zi %s, fsbno %llu\n"
 
 #: ../repair/scan.c:393
 #, c-format
@@ -8867,8 +8867,8 @@ msgid ""
 "correcting bt key (was %llu, now %llu) in inode %llu\n"
 "\t\t%s fork, btree block %llu\n"
 msgstr ""
-"poprawiono klucz bt (by³o %llu, jest %llu) w i-wê¼le %llu\n"
-"\t\tga³±¼ %s, blok b-drzewa %llu\n"
+"poprawiono klucz bt (byÅ‚o %llu, jest %llu) w i-wÄ™Åºle %llu\n"
+"\t\tgaÅ‚Ä…Åº %s, blok b-drzewa %llu\n"
 
 #: ../repair/scan.c:404
 #, c-format
@@ -8876,8 +8876,8 @@ msgid ""
 "bad btree key (is %llu, should be %llu) in inode %llu\n"
 "\t\t%s fork, btree block %llu\n"
 msgstr ""
-"b³êdny klucz b-drzewa (by³o %llu, powinno byæ %llu) w i-wê¼le %llu\n"
-"\t\tga³±¼ %s, blok b-drzewa %llu\n"
+"bÅ‚Ä™dny klucz b-drzewa (byÅ‚o %llu, powinno byÄ‡ %llu) w i-wÄ™Åºle %llu\n"
+"\t\tgaÅ‚Ä…Åº %s, blok b-drzewa %llu\n"
 
 #: ../repair/scan.c:421
 #, c-format
@@ -8885,13 +8885,13 @@ msgid ""
 "bad fwd (right) sibling pointer (saw %llu should be NULLDFSBNO)\n"
 "\tin inode %llu (%s fork) bmap btree block %llu\n"
 msgstr ""
-"b³êdny wska¼nik w przód (prawy) (widziano %llu, powinien byæ NULLDFSBNO)\n"
-"\tw i-wê¼le %llu (ga³êzi %s) bloku bmap btree %llu\n"
+"bÅ‚Ä™dny wskaÅºnik w przÃ³d (prawy) (widziano %llu, powinien byÄ‡ NULLDFSBNO)\n"
+"\tw i-wÄ™Åºle %llu (gaÅ‚Ä™zi %s) bloku bmap btree %llu\n"
 
 #: ../repair/scan.c:460
 #, c-format
 msgid "bad magic # %#x in btbno block %d/%d\n"
-msgstr "b³êdna liczba magiczna %#x w bloku btbno %d/%d\n"
+msgstr "bÅ‚Ä™dna liczba magiczna %#x w bloku btbno %d/%d\n"
 
 #: ../repair/scan.c:467
 #, c-format
@@ -8911,7 +8911,7 @@ msgstr "blok (%d,%d) wielokrotnie przypisany do drzewa bno miejsca, stan - %d\n"
 #: ../repair/scan.c:604
 #, c-format
 msgid "bad magic # %#x in btcnt block %d/%d\n"
-msgstr "b³êdna liczba magiczna %#x w bloku btcbt %d/%d\n"
+msgstr "bÅ‚Ä™dna liczba magiczna %#x w bloku btcbt %d/%d\n"
 
 #: ../repair/scan.c:611
 #, c-format
@@ -8926,12 +8926,12 @@ msgstr "blok b-drzewa bcnt wolnego miejsca przypisany (stan %d), agno %d, bno %d
 #: ../repair/scan.c:680
 #, c-format
 msgid "block (%d,%d) already used, state %d\n"
-msgstr "blok (%d,%d) ju¿ u¿ywany, stan %d\n"
+msgstr "blok (%d,%d) juÅ¼ uÅ¼ywany, stan %d\n"
 
 #: ../repair/scan.c:768
 #, c-format
 msgid "bad magic # %#x in inobt block %d/%d\n"
-msgstr "b³êdna liczba magiczna %#x w bloku inobt %d/%d\n"
+msgstr "bÅ‚Ä™dna liczba magiczna %#x w bloku inobt %d/%d\n"
 
 #: ../repair/scan.c:776
 #, c-format
@@ -8941,52 +8941,52 @@ msgstr "oczekiwano poziomu %d, a uzyskano %d w bloku inobt %d/%d\n"
 #: ../repair/scan.c:799
 #, c-format
 msgid "inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"
-msgstr "blok b-drzewa i-wêz³ów przypisany (stan %d), agno %d, bno %d, podejrzany %d\n"
+msgstr "blok b-drzewa i-wÄ™zÅ‚Ã³w przypisany (stan %d), agno %d, bno %d, podejrzany %d\n"
 
 #: ../repair/scan.c:822
 #, c-format
 msgid "dubious inode btree block header %d/%d\n"
-msgstr "w±tpliwy nag³ówek bloku b-drzewa i-wêz³ów %d/%d\n"
+msgstr "wÄ…tpliwy nagÅ‚Ã³wek bloku b-drzewa i-wÄ™zÅ‚Ã³w %d/%d\n"
 
 #: ../repair/scan.c:859
 #, c-format
 msgid "badly aligned inode rec (starting inode = %llu)\n"
-msgstr "b³êdnie wyrównany rekord i-wêz³a (pocz±tkowy i-wêze³ = %llu)\n"
+msgstr "bÅ‚Ä™dnie wyrÃ³wnany rekord i-wÄ™zÅ‚a (poczÄ…tkowy i-wÄ™zeÅ‚ = %llu)\n"
 
 #: ../repair/scan.c:875
 #, c-format
 msgid "bad starting inode # (%llu (0x%x 0x%x)) in ino rec, skipping rec\n"
-msgstr "b³êdny numer pocz±tkowego i-wêz³a (%llu (0x%x 0x%x)) w rekordzie i-wêz³a, pominiêto rekord\n"
+msgstr "bÅ‚Ä™dny numer poczÄ…tkowego i-wÄ™zÅ‚a (%llu (0x%x 0x%x)) w rekordzie i-wÄ™zÅ‚a, pominiÄ™to rekord\n"
 
 #: ../repair/scan.c:884
 #, c-format
 msgid "bad ending inode # (%llu (0x%x 0x%x)) in ino rec, skipping rec\n"
-msgstr "b³êdny numer koñcowego i-wêz³a (%llu (0x%x 0x%x)) w rekordzie i-wêz³a, pominiêto rekord\n"
+msgstr "bÅ‚Ä™dny numer koÅ„cowego i-wÄ™zÅ‚a (%llu (0x%x 0x%x)) w rekordzie i-wÄ™zÅ‚a, pominiÄ™to rekord\n"
 
 #: ../repair/scan.c:913
 #, c-format
 msgid "inode chunk claims used block, inobt block - agno %d, bno %d, inopb %d\n"
-msgstr "czê¶æ i-wêz³a odwo³uje siê do u¿ywanego bloku, blok inobt - agno %d, bno %d, inopb %d\n"
+msgstr "czÄ™Å›Ä‡ i-wÄ™zÅ‚a odwoÅ‚uje siÄ™ do uÅ¼ywanego bloku, blok inobt - agno %d, bno %d, inopb %d\n"
 
 #: ../repair/scan.c:938
 #, c-format
 msgid "inode rec for ino %llu (%d/%d) overlaps existing rec (start %d/%d)\n"
-msgstr "rekord i-wêz³a dla i-wêz³a %llu (%d/%d) nachodzi na istniej±cy rekord (pocz±tek %d/%d)\n"
+msgstr "rekord i-wÄ™zÅ‚a dla i-wÄ™zÅ‚a %llu (%d/%d) nachodzi na istniejÄ…cy rekord (poczÄ…tek %d/%d)\n"
 
 #: ../repair/scan.c:990
 #, c-format
 msgid "ir_freecount/free mismatch, inode chunk %d/%d, freecount %d nfree %d\n"
-msgstr "niezgodno¶æ ir_freecount/free, czê¶æ i-wêz³a %d/%d, freecount %d nfree %d\n"
+msgstr "niezgodnoÅ›Ä‡ ir_freecount/free, czÄ™Å›Ä‡ i-wÄ™zÅ‚a %d/%d, freecount %d nfree %d\n"
 
 #: ../repair/scan.c:1061
 #, c-format
 msgid "can't read agfl block for ag %d\n"
-msgstr "nie mo¿na odczytaæ bloku agfl dla ag %d\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku agfl dla ag %d\n"
 
 #: ../repair/scan.c:1074
 #, c-format
 msgid "bad agbno %u in agfl, agno %d\n"
-msgstr "b³êdne agbno %u w agfl, agno %d\n"
+msgstr "bÅ‚Ä™dne agbno %u w agfl, agno %d\n"
 
 #: ../repair/scan.c:1083
 #, c-format
@@ -8996,110 +8996,110 @@ msgstr "liczba freeblk %d != flcount %d w ag %d\n"
 #: ../repair/scan.c:1110
 #, c-format
 msgid "can't get root superblock for ag %d\n"
-msgstr "nie mo¿na uzyskaæ g³ównego superbloku dla ag %d\n"
+msgstr "nie moÅ¼na uzyskaÄ‡ gÅ‚Ã³wnego superbloku dla ag %d\n"
 
 #: ../repair/scan.c:1116
 msgid "can't allocate memory for superblock\n"
-msgstr "nie mo¿na przydzieliæ pamiêci dla superbloku\n"
+msgstr "nie moÅ¼na przydzieliÄ‡ pamiÄ™ci dla superbloku\n"
 
 #: ../repair/scan.c:1126
 #, c-format
 msgid "can't read agf block for ag %d\n"
-msgstr "nie mo¿na odczytaæ bloku agf dla ag %d\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku agf dla ag %d\n"
 
 #: ../repair/scan.c:1137
 #, c-format
 msgid "can't read agi block for ag %d\n"
-msgstr "nie mo¿na odczytaæ bloku agi dla ag %d\n"
+msgstr "nie moÅ¼na odczytaÄ‡ bloku agi dla ag %d\n"
 
 #: ../repair/scan.c:1161
 #, c-format
 msgid "reset bad sb for ag %d\n"
-msgstr "przestawiono b³êdny superbloku dla ag %d\n"
+msgstr "przestawiono bÅ‚Ä™dny superbloku dla ag %d\n"
 
 #: ../repair/scan.c:1164
 #, c-format
 msgid "would reset bad sb for ag %d\n"
-msgstr "b³êdny superblok dla ag %d zosta³by przestawiony\n"
+msgstr "bÅ‚Ä™dny superblok dla ag %d zostaÅ‚by przestawiony\n"
 
 #: ../repair/scan.c:1169
 #, c-format
 msgid "reset bad agf for ag %d\n"
-msgstr "przestawiono b³êdne agf dla ag %d\n"
+msgstr "przestawiono bÅ‚Ä™dne agf dla ag %d\n"
 
 #: ../repair/scan.c:1172
 #, c-format
 msgid "would reset bad agf for ag %d\n"
-msgstr "b³êdne agf dla ag %d zosta³oby przestawione\n"
+msgstr "bÅ‚Ä™dne agf dla ag %d zostaÅ‚oby przestawione\n"
 
 #: ../repair/scan.c:1177
 #, c-format
 msgid "reset bad agi for ag %d\n"
-msgstr "przestawiono b³êdne agi dla ag %d\n"
+msgstr "przestawiono bÅ‚Ä™dne agi dla ag %d\n"
 
 #: ../repair/scan.c:1180
 #, c-format
 msgid "would reset bad agi for ag %d\n"
-msgstr "b³êdna agi dla ag %d zosta³oby przestawione\n"
+msgstr "bÅ‚Ä™dna agi dla ag %d zostaÅ‚oby przestawione\n"
 
 #: ../repair/scan.c:1190
 #, c-format
 msgid "bad uncorrected agheader %d, skipping ag...\n"
-msgstr "b³êdny nie poprawiony agheader %d, pominiêto ag...\n"
+msgstr "bÅ‚Ä™dny nie poprawiony agheader %d, pominiÄ™to ag...\n"
 
 #: ../repair/scan.c:1204
 #, c-format
 msgid "bad agbno %u for btbno root, agno %d\n"
-msgstr "b³êdne agbno %u dla g³ównego btbno, agno %d\n"
+msgstr "bÅ‚Ä™dne agbno %u dla gÅ‚Ã³wnego btbno, agno %d\n"
 
 #: ../repair/scan.c:1214
 #, c-format
 msgid "bad agbno %u for btbcnt root, agno %d\n"
-msgstr "b³êdne agbno %u dla g³ównego btbcnt, agno %d\n"
+msgstr "bÅ‚Ä™dne agbno %u dla gÅ‚Ã³wnego btbcnt, agno %d\n"
 
 #: ../repair/scan.c:1223
 #, c-format
 msgid "bad agbno %u for inobt root, agno %d\n"
-msgstr "b³êdne agbno %u dla g³ównego inobt, agno %d\n"
+msgstr "bÅ‚Ä™dne agbno %u dla gÅ‚Ã³wnego inobt, agno %d\n"
 
 #: ../repair/threads.c:90
 #, c-format
 msgid "cannot create worker threads, error = [%d] %s\n"
-msgstr "nie mo¿na utworzyæ w±tków pracuj±cych, b³±d: [%d] %s\n"
+msgstr "nie moÅ¼na utworzyÄ‡ wÄ…tkÃ³w pracujÄ…cych, bÅ‚Ä…d: [%d] %s\n"
 
 #: ../repair/threads.c:108
 #, c-format
 msgid "cannot allocate worker item, error = [%d] %s\n"
-msgstr "nie mo¿na przydzieliæ elementu pracuj±cego, b³±d: [%d] %s\n"
+msgstr "nie moÅ¼na przydzieliÄ‡ elementu pracujÄ…cego, bÅ‚Ä…d: [%d] %s\n"
 
 #: ../repair/versions.c:73
 #, c-format
 msgid "bogus quota flags 0x%x set in superblock"
-msgstr "niepoprawne flagi limitów 0x%x ustawione w superbloku"
+msgstr "niepoprawne flagi limitÃ³w 0x%x ustawione w superbloku"
 
 #: ../repair/versions.c:86
 msgid ", bogus flags will be cleared\n"
-msgstr ", b³êdne flagi zostan± wyczyszczone\n"
+msgstr ", bÅ‚Ä™dne flagi zostanÄ… wyczyszczone\n"
 
 #: ../repair/versions.c:88
 msgid ", bogus flags would be cleared\n"
-msgstr ", b³êdne flagi zosta³yby wyczyszczone\n"
+msgstr ", bÅ‚Ä™dne flagi zostaÅ‚yby wyczyszczone\n"
 
 #: ../repair/versions.c:141
 msgid "This filesystem has uninitialized extent flags.\n"
-msgstr "Ten system plików ma niezainicjowane flagi fragmentów.\n"
+msgstr "Ten system plikÃ³w ma niezainicjowane flagi fragmentÃ³w.\n"
 
 #: ../repair/versions.c:149
 msgid "This filesystem is marked shared.\n"
-msgstr "Ten system plików jest oznaczony jako wspó³dzielony.\n"
+msgstr "Ten system plikÃ³w jest oznaczony jako wspÃ³Å‚dzielony.\n"
 
 #: ../repair/versions.c:155
 msgid ""
 "This filesystem uses feature(s) not yet supported in this release.\n"
 "Please run a more recent version of xfs_repair.\n"
 msgstr ""
-"Ten system plików u¿ywa mo¿liwo¶ci jeszcze nie obs³ugiwanych w tym wydaniu.\n"
-"Proszê uruchomiæ nowsz± wersjê xfs_repair.\n"
+"Ten system plikÃ³w uÅ¼ywa moÅ¼liwoÅ›ci jeszcze nie obsÅ‚ugiwanych w tym wydaniu.\n"
+"ProszÄ™ uruchomiÄ‡ nowszÄ… wersjÄ™ xfs_repair.\n"
 
 #: ../repair/versions.c:161
 #, c-format
@@ -9108,7 +9108,7 @@ msgstr "UWAGA: nieznana wersja superbloku %d\n"
 
 #: ../repair/versions.c:164
 msgid "This filesystem contains features not understood by this program.\n"
-msgstr "Ten system plików zawiera cechê nie rozumian± przez ten program.\n"
+msgstr "Ten system plikÃ³w zawiera cechÄ™ nie rozumianÄ… przez ten program.\n"
 
 #: ../repair/versions.c:172
 msgid ""
@@ -9118,7 +9118,7 @@ msgid ""
 msgstr ""
 "UWAGA: zabroniono superblock-feature-bits-allowed, ale ten\n"
 "\tsuperblok ma ustawione bity cech. Superblok zostanie zdegradowany.\n"
-"\tMo¿e to spowodowaæ utratê metadanych systemu plików.\n"
+"\tMoÅ¼e to spowodowaÄ‡ utratÄ™ metadanych systemu plikÃ³w.\n"
 
 #: ../repair/versions.c:177
 msgid ""
@@ -9128,8 +9128,8 @@ msgid ""
 "\tmeta-data.\n"
 msgstr ""
 "UWAGA: zabroniono superblock-feature-bits-allowed, ale ten\n"
-"\tsuperblok ma ustawione bity cech. Superblok zosta³by zdegradowany.\n"
-"\tMog³oby to spowodowaæ utratê metadanych systemu plików.\n"
+"\tsuperblok ma ustawione bity cech. Superblok zostaÅ‚by zdegradowany.\n"
+"\tMogÅ‚oby to spowodowaÄ‡ utratÄ™ metadanych systemu plikÃ³w.\n"
 
 #: ../repair/versions.c:191
 msgid ""
@@ -9137,9 +9137,9 @@ msgid ""
 "\thas attributes.  The filesystem will be downgraded and\n"
 "\tall attributes will be removed.\n"
 msgstr ""
-"UWAGA: zabroniono u¿ywania atrybutów, ale ten system plików zawiera\n"
-"\tatrybuty. System plików zostanie zdegradowany, a wszystkie\n"
-"\tatrybuty usuniête.\n"
+"UWAGA: zabroniono uÅ¼ywania atrybutÃ³w, ale ten system plikÃ³w zawiera\n"
+"\tatrybuty. System plikÃ³w zostanie zdegradowany, a wszystkie\n"
+"\tatrybuty usuniÄ™te.\n"
 
 #: ../repair/versions.c:196
 msgid ""
@@ -9147,9 +9147,9 @@ msgid ""
 "\thas attributes.  The filesystem would be downgraded and\n"
 "\tall attributes would be removed.\n"
 msgstr ""
-"UWAGA: zabroniono u¿ywania atrybutów, ale ten system plików zawiera\n"
-"\tatrybuty. System plików zosta³by zdegradowany, a wszystkie\n"
-"\tatrybuty usuniête.\n"
+"UWAGA: zabroniono uÅ¼ywania atrybutÃ³w, ale ten system plikÃ³w zawiera\n"
+"\tatrybuty. System plikÃ³w zostaÅ‚by zdegradowany, a wszystkie\n"
+"\tatrybuty usuniÄ™te.\n"
 
 #: ../repair/versions.c:209
 msgid ""
@@ -9157,9 +9157,9 @@ msgid ""
 "\thas attributes.  The filesystem will be downgraded and\n"
 "\tall attr2 attributes will be removed.\n"
 msgstr ""
-"UWAGA: zabroniono u¿ywania atrybutów attr2, ale ten system plików\n"
-"\tzawiera atrybuty. System plików zostanie zdegradowany, a wszystkie\n"
-"\tatrybuty attr2 usuniête.\n"
+"UWAGA: zabroniono uÅ¼ywania atrybutÃ³w attr2, ale ten system plikÃ³w\n"
+"\tzawiera atrybuty. System plikÃ³w zostanie zdegradowany, a wszystkie\n"
+"\tatrybuty attr2 usuniÄ™te.\n"
 
 #: ../repair/versions.c:214
 msgid ""
@@ -9167,9 +9167,9 @@ msgid ""
 "\thas attributes.  The filesystem would be downgraded and\n"
 "\tall attr2 attributes would be removed.\n"
 msgstr ""
-"UWAGA: zabroniono u¿ywania atrybutów attr2, ale ten system plików\n"
-"\tzawiera atrybuty. System plików zosta³by zdegradowany, a wszystkie\n"
-"\tatrybuty attr2 usuniête.\n"
+"UWAGA: zabroniono uÅ¼ywania atrybutÃ³w attr2, ale ten system plikÃ³w\n"
+"\tzawiera atrybuty. System plikÃ³w zostaÅ‚by zdegradowany, a wszystkie\n"
+"\tatrybuty attr2 usuniÄ™te.\n"
 
 #: ../repair/versions.c:227
 msgid ""
@@ -9178,11 +9178,11 @@ msgid ""
 "\tall version 2 inodes will be converted to version 1 inodes.\n"
 "\tThis may cause some hard links to files to be destroyed\n"
 msgstr ""
-"UWAGA: zabroniono u¿ywania i-wêz³ów w wersji 2, ale ten system plików\n"
-"\tzawiera i-wêz³y w wersji 2. System plików zostanie zdegradowany,\n"
-"\ta wszystkie i-wêz³y w wersji 2 zostan± przekonwertowane do wersji 1.\n"
-"\tMo¿e to spowodowaæ zniszczenie niektórych twardych dowi±zañ do\n"
-"\tplików.\n"
+"UWAGA: zabroniono uÅ¼ywania i-wÄ™zÅ‚Ã³w w wersji 2, ale ten system plikÃ³w\n"
+"\tzawiera i-wÄ™zÅ‚y w wersji 2. System plikÃ³w zostanie zdegradowany,\n"
+"\ta wszystkie i-wÄ™zÅ‚y w wersji 2 zostanÄ… przekonwertowane do wersji 1.\n"
+"\tMoÅ¼e to spowodowaÄ‡ zniszczenie niektÃ³rych twardych dowiÄ…zaÅ„ do\n"
+"\tplikÃ³w.\n"
 
 #: ../repair/versions.c:233
 msgid ""
@@ -9191,11 +9191,11 @@ msgid ""
 "\tall version 2 inodes would be converted to version 1 inodes.\n"
 "\tThis might cause some hard links to files to be destroyed\n"
 msgstr ""
-"UWAGA: zabroniono u¿ywania i-wêz³ów w wersji 2, ale ten system plików\n"
-"\tzawiera i-wêz³y w wersji 2. System plików zosta³by zdegradowany,\n"
-"\ta wszystkie i-wêz³y w wersji 2 zosta³yby przekonwertowane do\n"
-"\twersji 1. Mog³oby to spowodowaæ zniszczenie niektórych twardych\n"
-"\tdowi±zañ do plików.\n"
+"UWAGA: zabroniono uÅ¼ywania i-wÄ™zÅ‚Ã³w w wersji 2, ale ten system plikÃ³w\n"
+"\tzawiera i-wÄ™zÅ‚y w wersji 2. System plikÃ³w zostaÅ‚by zdegradowany,\n"
+"\ta wszystkie i-wÄ™zÅ‚y w wersji 2 zostaÅ‚yby przekonwertowane do\n"
+"\twersji 1. MogÅ‚oby to spowodowaÄ‡ zniszczenie niektÃ³rych twardych\n"
+"\tdowiÄ…zaÅ„ do plikÃ³w.\n"
 
 #: ../repair/versions.c:247
 msgid ""
@@ -9203,9 +9203,9 @@ msgid ""
 "\thas quotas.  The filesystem will be downgraded and\n"
 "\tall quota information will be removed.\n"
 msgstr ""
-"UWAGA: zabroniono u¿ywania limitów (quot), ale ten system plików\n"
-"\tzawiera limity. System plików zostanie zdegradowany, a wszystkie\n"
-"\tinformacje o limitach usuniête.\n"
+"UWAGA: zabroniono uÅ¼ywania limitÃ³w (quot), ale ten system plikÃ³w\n"
+"\tzawiera limity. System plikÃ³w zostanie zdegradowany, a wszystkie\n"
+"\tinformacje o limitach usuniÄ™te.\n"
 
 #: ../repair/versions.c:252
 msgid ""
@@ -9213,9 +9213,9 @@ msgid ""
 "\thas quotas.  The filesystem would be downgraded and\n"
 "\tall quota information would be removed.\n"
 msgstr ""
-"UWAGA: zabroniono u¿ywania limitów (quot), ale ten system plików\n"
-"\tzawiera limity. System plików zosta³by zdegradowany, a wszystkie\n"
-"\tinformacje o limitach usuniête.\n"
+"UWAGA: zabroniono uÅ¼ywania limitÃ³w (quot), ale ten system plikÃ³w\n"
+"\tzawiera limity. System plikÃ³w zostaÅ‚by zdegradowany, a wszystkie\n"
+"\tinformacje o limitach usuniÄ™te.\n"
 
 #: ../repair/versions.c:276
 msgid ""
@@ -9223,9 +9223,9 @@ msgid ""
 "\thas aligned inodes.  The filesystem will be downgraded.\n"
 "\tThis will permanently degrade the performance of this filesystem.\n"
 msgstr ""
-"UWAGA: zabroniono u¿ywania wyrównanych i-wêz³ów, ale ten system plików\n"
-"\tzawiera wyrównane i-wêz³y. System plików zostanie zdegradowany.\n"
-"\tTrwale zdegraduje to wydajno¶æ tego systemu plików.\n"
+"UWAGA: zabroniono uÅ¼ywania wyrÃ³wnanych i-wÄ™zÅ‚Ã³w, ale ten system plikÃ³w\n"
+"\tzawiera wyrÃ³wnane i-wÄ™zÅ‚y. System plikÃ³w zostanie zdegradowany.\n"
+"\tTrwale zdegraduje to wydajnoÅ›Ä‡ tego systemu plikÃ³w.\n"
 
 #: ../repair/versions.c:281
 msgid ""
@@ -9233,9 +9233,9 @@ msgid ""
 "\thas aligned inodes.  The filesystem would be downgraded.\n"
 "\tThis would permanently degrade the performance of this filesystem.\n"
 msgstr ""
-"UWAGA: zabroniono u¿ywania wyrównanych i-wêz³ów, ale ten system plików\n"
-"\tzawiera wyrównane i-wêz³y. System plików zosta³by zdegradowany.\n"
-"\tTrwale zdegradowa³oby to wydajno¶æ tego systemu plików.\n"
+"UWAGA: zabroniono uÅ¼ywania wyrÃ³wnanych i-wÄ™zÅ‚Ã³w, ale ten system plikÃ³w\n"
+"\tzawiera wyrÃ³wnane i-wÄ™zÅ‚y. System plikÃ³w zostaÅ‚by zdegradowany.\n"
+"\tTrwale zdegradowaÅ‚oby to wydajnoÅ›Ä‡ tego systemu plikÃ³w.\n"
 
 #: ../repair/xfs_repair.c:89
 #, c-format
@@ -9257,120 +9257,120 @@ msgid ""
 "  -d           Repair dangerously.\n"
 "  -V           Reports version and exits.\n"
 msgstr ""
-"Sk³adnia: %s [opcje] urz±dzenie\n"
+"SkÅ‚adnia: %s [opcje] urzÄ…dzenie\n"
 "\n"
 "Opcje:\n"
-"  -f           Urz±dzenie jest plikiem\n"
-"  -L           Wymuszenie wyzerowania logu. Wykonywaæ tylko w ostateczno¶ci.\n"
-"  -l urz_logu  Okre¶lenie urz±dzenia z zewnêtrznym logiem.\n"
-"  -m maks_pam  Maksymalna ilo¶æ pamiêci do u¿ycia w megabajtach.\n"
-"  -n           Tryb bez modyfikacji, tylko sprawdzenie systemu plików.\n"
-"  -P           Wy³±czenie prefetch.\n"
-"  -r urz_rt    Okre¶lenie urz±dzenia z sekcj± realtime.\n"
-"  -v           Szczegó³owe wyj¶cie.\n"
-"  -c podopcje  Zmiana parametrów systemu plików przy u¿yciu xfs_admina.\n"
-"  -o podopcje  Zmiana domy¶lnego zachowania, wiêcej na stronie manuala.\n"
-"  -t czas      Okres informowania o postêpach w minutach.\n"
-"  -d           Naprawianie w sposób niebezpieczny.\n"
-"  -V           Wypisanie informacji o wersji i zakoñczenie.\n"
+"  -f           UrzÄ…dzenie jest plikiem\n"
+"  -L           Wymuszenie wyzerowania logu. WykonywaÄ‡ tylko w ostatecznoÅ›ci.\n"
+"  -l urz_logu  OkreÅ›lenie urzÄ…dzenia z zewnÄ™trznym logiem.\n"
+"  -m maks_pam  Maksymalna iloÅ›Ä‡ pamiÄ™ci do uÅ¼ycia w megabajtach.\n"
+"  -n           Tryb bez modyfikacji, tylko sprawdzenie systemu plikÃ³w.\n"
+"  -P           WyÅ‚Ä…czenie prefetch.\n"
+"  -r urz_rt    OkreÅ›lenie urzÄ…dzenia z sekcjÄ… realtime.\n"
+"  -v           SzczegÃ³Å‚owe wyjÅ›cie.\n"
+"  -c podopcje  Zmiana parametrÃ³w systemu plikÃ³w przy uÅ¼yciu xfs_admina.\n"
+"  -o podopcje  Zmiana domyÅ›lnego zachowania, wiÄ™cej na stronie manuala.\n"
+"  -t czas      Okres informowania o postÄ™pach w minutach.\n"
+"  -d           Naprawianie w sposÃ³b niebezpieczny.\n"
+"  -V           Wypisanie informacji o wersji i zakoÅ„czenie.\n"
 
 #: ../repair/xfs_repair.c:115
 msgid "no error"
-msgstr "brak b³êdu"
+msgstr "brak bÅ‚Ä™du"
 
 #: ../repair/xfs_repair.c:116
 msgid "bad magic number"
-msgstr "b³êdna liczba magiczna"
+msgstr "bÅ‚Ä™dna liczba magiczna"
 
 #: ../repair/xfs_repair.c:117
 msgid "bad blocksize field"
-msgstr "b³êdne pole blocksize"
+msgstr "bÅ‚Ä™dne pole blocksize"
 
 #: ../repair/xfs_repair.c:118
 msgid "bad blocksize log field"
-msgstr "b³êdne pole logu blocksize"
+msgstr "bÅ‚Ä™dne pole logu blocksize"
 
 #: ../repair/xfs_repair.c:119
 msgid "bad or unsupported version"
-msgstr "b³êdna lub nie obs³ugiwana wersja"
+msgstr "bÅ‚Ä™dna lub nie obsÅ‚ugiwana wersja"
 
 #: ../repair/xfs_repair.c:121
 msgid "filesystem mkfs-in-progress bit set"
-msgstr "ustawiony bit mkfs-in-progress systemu plików"
+msgstr "ustawiony bit mkfs-in-progress systemu plikÃ³w"
 
 #: ../repair/xfs_repair.c:123
 msgid "inconsistent filesystem geometry information"
-msgstr "niespójne informacje o geometrii systemu plików"
+msgstr "niespÃ³jne informacje o geometrii systemu plikÃ³w"
 
 #: ../repair/xfs_repair.c:125
 msgid "bad inode size or inconsistent with number of inodes/block"
-msgstr "b³êdny rozmiar i-wêz³a lub niespójno¶æ z liczb± i-wêz³ów/blok"
+msgstr "bÅ‚Ä™dny rozmiar i-wÄ™zÅ‚a lub niespÃ³jnoÅ›Ä‡ z liczbÄ… i-wÄ™zÅ‚Ã³w/blok"
 
 #: ../repair/xfs_repair.c:126
 msgid "bad sector size"
-msgstr "b³êdny rozmiar sektora"
+msgstr "bÅ‚Ä™dny rozmiar sektora"
 
 #: ../repair/xfs_repair.c:128
 msgid "AGF geometry info conflicts with filesystem geometry"
-msgstr "informacje o geometrii AGF s± w konflikcie z geometri± systemu plików"
+msgstr "informacje o geometrii AGF sÄ… w konflikcie z geometriÄ… systemu plikÃ³w"
 
 #: ../repair/xfs_repair.c:130
 msgid "AGI geometry info conflicts with filesystem geometry"
-msgstr "informacje o geometrii AGI s± w konflikcie z geometri± systemu plików"
+msgstr "informacje o geometrii AGI sÄ… w konflikcie z geometriÄ… systemu plikÃ³w"
 
 #: ../repair/xfs_repair.c:132
 msgid "AG superblock geometry info conflicts with filesystem geometry"
-msgstr "informacje o geometrii superbloku AG s± w konflikcie z geometri± systemu plików"
+msgstr "informacje o geometrii superbloku AG sÄ… w konflikcie z geometriÄ… systemu plikÃ³w"
 
 #: ../repair/xfs_repair.c:133
 msgid "attempted to perform I/O beyond EOF"
-msgstr "próbowano wykonaæ operacjê we/wy poza koñcem pliku"
+msgstr "prÃ³bowano wykonaÄ‡ operacjÄ™ we/wy poza koÅ„cem pliku"
 
 #: ../repair/xfs_repair.c:135
 msgid "inconsistent filesystem geometry in realtime filesystem component"
-msgstr "niespójna geometria systemu plików w sk³adniku realtime"
+msgstr "niespÃ³jna geometria systemu plikÃ³w w skÅ‚adniku realtime"
 
 #: ../repair/xfs_repair.c:137
 msgid "maximum indicated percentage of inodes > 100%"
-msgstr "okre¶lono maksymalny procent i-wêz³ów > 100%"
+msgstr "okreÅ›lono maksymalny procent i-wÄ™zÅ‚Ã³w > 100%"
 
 #: ../repair/xfs_repair.c:139
 msgid "inconsistent inode alignment value"
-msgstr "niespójna warto¶æ wyrównania i-wêz³a"
+msgstr "niespÃ³jna wartoÅ›Ä‡ wyrÃ³wnania i-wÄ™zÅ‚a"
 
 #: ../repair/xfs_repair.c:141
 msgid "not enough secondary superblocks with matching geometry"
-msgstr "za ma³o zapasowych superbloków o pasuj±cej geometrii"
+msgstr "za maÅ‚o zapasowych superblokÃ³w o pasujÄ…cej geometrii"
 
 #: ../repair/xfs_repair.c:143
 msgid "bad stripe unit in superblock"
-msgstr "b³êdna jednostka pasa w superbloku"
+msgstr "bÅ‚Ä™dna jednostka pasa w superbloku"
 
 #: ../repair/xfs_repair.c:145
 msgid "bad stripe width in superblock"
-msgstr "b³êdna szeroko¶æ pasa w superbloku"
+msgstr "bÅ‚Ä™dna szerokoÅ›Ä‡ pasa w superbloku"
 
 #: ../repair/xfs_repair.c:147
 msgid "bad shared version number in superblock"
-msgstr "b³êdny numer wersji wspó³dzielenia w superbloku"
+msgstr "bÅ‚Ä™dny numer wersji wspÃ³Å‚dzielenia w superbloku"
 
 #: ../repair/xfs_repair.c:152
 #, c-format
 msgid "bad error code - %d\n"
-msgstr "b³êdny kod b³êdu - %d\n"
+msgstr "bÅ‚Ä™dny kod bÅ‚Ä™du - %d\n"
 
 #: ../repair/xfs_repair.c:160
 #, c-format
 msgid "-%c %s option cannot have a value\n"
-msgstr "opcja -%c %s nie przyjmuje warto¶ci\n"
+msgstr "opcja -%c %s nie przyjmuje wartoÅ›ci\n"
 
 #: ../repair/xfs_repair.c:256
 msgid "-o bhash option cannot be used with -m option\n"
-msgstr "opcja -o bhash nie mo¿e byæ u¿yta wraz z opcj± -m\n"
+msgstr "opcja -o bhash nie moÅ¼e byÄ‡ uÅ¼yta wraz z opcjÄ… -m\n"
 
 #: ../repair/xfs_repair.c:305
 msgid "-m option cannot be used with -o bhash option\n"
-msgstr "opcja -m nie mo¿e byæ u¿yta wraz z opcj± -o bhash\n"
+msgstr "opcja -m nie moÅ¼e byÄ‡ uÅ¼yta wraz z opcjÄ… -o bhash\n"
 
 #: ../repair/xfs_repair.c:359
 #, c-format
@@ -9379,52 +9379,52 @@ msgid ""
 "fatal error -- "
 msgstr ""
 "\n"
-"b³±d krytyczny - "
+"bÅ‚Ä…d krytyczny - "
 
 #: ../repair/xfs_repair.c:461
 #, c-format
 msgid "sb root inode value %llu %sinconsistent with calculated value %lu\n"
-msgstr "warto¶æ i-wêz³a g³ównego superbloku %llu %sniespójna z obliczon± warto¶ci± %lu\n"
+msgstr "wartoÅ›Ä‡ i-wÄ™zÅ‚a gÅ‚Ã³wnego superbloku %llu %sniespÃ³jna z obliczonÄ… wartoÅ›ciÄ… %lu\n"
 
 #: ../repair/xfs_repair.c:468
 #, c-format
 msgid "resetting superblock root inode pointer to %lu\n"
-msgstr "przestawiono wska¼nik i-wêz³a g³ównego superbloku na %lu\n"
+msgstr "przestawiono wskaÅºnik i-wÄ™zÅ‚a gÅ‚Ã³wnego superbloku na %lu\n"
 
 #: ../repair/xfs_repair.c:472
 #, c-format
 msgid "would reset superblock root inode pointer to %lu\n"
-msgstr "wska¼nik i-wêz³a g³ównego superbloku zosta³by przestawiony na %lu\n"
+msgstr "wskaÅºnik i-wÄ™zÅ‚a gÅ‚Ã³wnego superbloku zostaÅ‚by przestawiony na %lu\n"
 
 #: ../repair/xfs_repair.c:484
 #, c-format
 msgid "sb realtime bitmap inode %llu %sinconsistent with calculated value %lu\n"
-msgstr "i-wêze³ bitmapy realtime superbloku %llu %sniespójny z obliczon± warto¶ci± %lu\n"
+msgstr "i-wÄ™zeÅ‚ bitmapy realtime superbloku %llu %sniespÃ³jny z obliczonÄ… wartoÅ›ciÄ… %lu\n"
 
 #: ../repair/xfs_repair.c:491
 #, c-format
 msgid "resetting superblock realtime bitmap ino pointer to %lu\n"
-msgstr "przestawiono wska¼nik i-wêz³a bitmapy realtime superbloku na %lu\n"
+msgstr "przestawiono wskaÅºnik i-wÄ™zÅ‚a bitmapy realtime superbloku na %lu\n"
 
 #: ../repair/xfs_repair.c:495
 #, c-format
 msgid "would reset superblock realtime bitmap ino pointer to %lu\n"
-msgstr "wska¼nik i-wêz³a bitmapy realtime superbloku zosta³by przestawiony na %lu\n"
+msgstr "wskaÅºnik i-wÄ™zÅ‚a bitmapy realtime superbloku zostaÅ‚by przestawiony na %lu\n"
 
 #: ../repair/xfs_repair.c:507
 #, c-format
 msgid "sb realtime summary inode %llu %sinconsistent with calculated value %lu\n"
-msgstr "i-wêze³ opisu realtime superbloku %llu %sniespójny z obliczon± warto¶ci± %lu\n"
+msgstr "i-wÄ™zeÅ‚ opisu realtime superbloku %llu %sniespÃ³jny z obliczonÄ… wartoÅ›ciÄ… %lu\n"
 
 #: ../repair/xfs_repair.c:514
 #, c-format
 msgid "resetting superblock realtime summary ino pointer to %lu\n"
-msgstr "przestawiono wska¼nik i-wêz³a opisu realtime superbloku na %lu\n"
+msgstr "przestawiono wskaÅºnik i-wÄ™zÅ‚a opisu realtime superbloku na %lu\n"
 
 #: ../repair/xfs_repair.c:518
 #, c-format
 msgid "would reset superblock realtime summary ino pointer to %lu\n"
-msgstr "wska¼nik i-wêz³a opisu realtime superbloku zosta³by przestawiony na %lu\n"
+msgstr "wskaÅºnik i-wÄ™zÅ‚a opisu realtime superbloku zostaÅ‚by przestawiony na %lu\n"
 
 #: ../repair/xfs_repair.c:566
 msgid ""
@@ -9432,19 +9432,19 @@ msgid ""
 "Cannot proceed further in no_modify mode.\n"
 "Exiting now.\n"
 msgstr ""
-"G³ówny superblok zosta³by zmodyfikowany.\n"
-"Nie mo¿na kontynuowaæ w trybie bez modyfikacji.\n"
-"Zakoñczono.\n"
+"GÅ‚Ã³wny superblok zostaÅ‚by zmodyfikowany.\n"
+"Nie moÅ¼na kontynuowaÄ‡ w trybie bez modyfikacji.\n"
+"ZakoÅ„czono.\n"
 
 #: ../repair/xfs_repair.c:582
 #, c-format
 msgid "%s: cannot repair this filesystem.  Sorry.\n"
-msgstr "%s: niestety nie mo¿na naprawiæ tego systemu plików.\n"
+msgstr "%s: niestety nie moÅ¼na naprawiÄ‡ tego systemu plikÃ³w.\n"
 
 #: ../repair/xfs_repair.c:607
 #, c-format
 msgid "        - reporting progress in intervals of %s\n"
-msgstr "        - informowanie o postêpie w odstêpach %s\n"
+msgstr "        - informowanie o postÄ™pie w odstÄ™pach %s\n"
 
 #: ../repair/xfs_repair.c:653
 #, c-format
@@ -9454,97 +9454,97 @@ msgstr "        - max_mem = %lu, icount = %llu, imem = %llu, dblock = %llu, dmem
 #: ../repair/xfs_repair.c:666
 #, c-format
 msgid "Required memory for repair is greater that the maximum specified with the -m option. Please increase it to at least %lu.\n"
-msgstr "Pamiêæ wymagana do naprawy przekracza maksimum okre¶lone opcj± -m. Proszê j± zwiêkszyæ do co najmniej %lu.\n"
+msgstr "PamiÄ™Ä‡ wymagana do naprawy przekracza maksimum okreÅ›lone opcjÄ… -m. ProszÄ™ jÄ… zwiÄ™kszyÄ‡ do co najmniej %lu.\n"
 
 #: ../repair/xfs_repair.c:684
 #, c-format
 msgid "        - block cache size set to %d entries\n"
-msgstr "        - rozmiar bufora bloku ustawiony na %d wpisów\n"
+msgstr "        - rozmiar bufora bloku ustawiony na %d wpisÃ³w\n"
 
 #: ../repair/xfs_repair.c:708
 msgid "Found unsupported filesystem features.  Exiting now.\n"
-msgstr "Znaleziono nie obs³ugiwane cechy systemu plików. Zakoñczono.\n"
+msgstr "Znaleziono nie obsÅ‚ugiwane cechy systemu plikÃ³w. ZakoÅ„czono.\n"
 
 #: ../repair/xfs_repair.c:726
 #, c-format
 msgid "No modify flag set, skipping phase 5\n"
-msgstr "Ustawiono flagê braku modyfikacji, pominiêto fazê 5\n"
+msgstr "Ustawiono flagÄ™ braku modyfikacji, pominiÄ™to fazÄ™ 5\n"
 
 #: ../repair/xfs_repair.c:740
 msgid "Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"
-msgstr "B-drzewa alokacji i-wêz³ów s± zbyt uszkodzone, pominiêto fazy 6 i 7\n"
+msgstr "B-drzewa alokacji i-wÄ™zÅ‚Ã³w sÄ… zbyt uszkodzone, pominiÄ™to fazy 6 i 7\n"
 
 #: ../repair/xfs_repair.c:746
 msgid "Warning:  no quota inodes were found.  Quotas disabled.\n"
-msgstr "Uwaga: nie znaleziono i-wêz³ów limitów (quot). Limity wy³±czone.\n"
+msgstr "Uwaga: nie znaleziono i-wÄ™zÅ‚Ã³w limitÃ³w (quot). Limity wyÅ‚Ä…czone.\n"
 
 #: ../repair/xfs_repair.c:749
 msgid "Warning:  no quota inodes were found.  Quotas would be disabled.\n"
-msgstr "Uwaga: nie znaleziono i-wêz³ów limitów (quot). Limity zosta³yby wy³±czone.\n"
+msgstr "Uwaga: nie znaleziono i-wÄ™zÅ‚Ã³w limitÃ³w (quot). Limity zostaÅ‚yby wyÅ‚Ä…czone.\n"
 
 #: ../repair/xfs_repair.c:754
 msgid "Warning:  quota inodes were cleared.  Quotas disabled.\n"
-msgstr "Uwaga: i-wêz³y limitów (quot) by³y wyczyszczone. Limity wy³±czone.\n"
+msgstr "Uwaga: i-wÄ™zÅ‚y limitÃ³w (quot) byÅ‚y wyczyszczone. Limity wyÅ‚Ä…czone.\n"
 
 #: ../repair/xfs_repair.c:757
 msgid "Warning:  quota inodes would be cleared.  Quotas would be disabled.\n"
-msgstr "Uwaga: i-wêz³y limitów (quot) zosta³yby wyczyszczone. Limity zosta³yby wy³±czone.\n"
+msgstr "Uwaga: i-wÄ™zÅ‚y limitÃ³w (quot) zostaÅ‚yby wyczyszczone. Limity zostaÅ‚yby wyÅ‚Ä…czone.\n"
 
 #: ../repair/xfs_repair.c:763
 msgid ""
 "Warning:  user quota information was cleared.\n"
 "User quotas can not be enforced until limit information is recreated.\n"
 msgstr ""
-"Uwaga: informacje o limitach u¿ytkowników by³y wyczyszczone.\n"
-"Limity u¿ytkowników nie mog± byæ wymuszone do czasu odtworzenia informacji.\n"
+"Uwaga: informacje o limitach uÅ¼ytkownikÃ³w byÅ‚y wyczyszczone.\n"
+"Limity uÅ¼ytkownikÃ³w nie mogÄ… byÄ‡ wymuszone do czasu odtworzenia informacji.\n"
 
 #: ../repair/xfs_repair.c:767
 msgid ""
 "Warning:  user quota information would be cleared.\n"
 "User quotas could not be enforced until limit information was recreated.\n"
 msgstr ""
-"Uwaga: informacje o limitach u¿ytkowników zosta³yby wyczyszczone.\n"
-"Limity u¿ytkowników nie mog³yby byæ wymuszone do czasu odtworzenia informacji.\n"
+"Uwaga: informacje o limitach uÅ¼ytkownikÃ³w zostaÅ‚yby wyczyszczone.\n"
+"Limity uÅ¼ytkownikÃ³w nie mogÅ‚yby byÄ‡ wymuszone do czasu odtworzenia informacji.\n"
 
 #: ../repair/xfs_repair.c:775
 msgid ""
 "Warning:  group quota information was cleared.\n"
 "Group quotas can not be enforced until limit information is recreated.\n"
 msgstr ""
-"Uwaga: informacje o limitach grup by³y wyczyszczone.\n"
-"Limity grup nie mog± byæ wymuszone do czasu odtworzenia informacji.\n"
+"Uwaga: informacje o limitach grup byÅ‚y wyczyszczone.\n"
+"Limity grup nie mogÄ… byÄ‡ wymuszone do czasu odtworzenia informacji.\n"
 
 #: ../repair/xfs_repair.c:779
 msgid ""
 "Warning:  group quota information would be cleared.\n"
 "Group quotas could not be enforced until limit information was recreated.\n"
 msgstr ""
-"Uwaga: informacje o limitach grup zosta³yby wyczyszczone.\n"
-"Limity grup nie mog³yby byæ wymuszone do czasu odtworzenia informacji.\n"
+"Uwaga: informacje o limitach grup zostaÅ‚yby wyczyszczone.\n"
+"Limity grup nie mogÅ‚yby byÄ‡ wymuszone do czasu odtworzenia informacji.\n"
 
 #: ../repair/xfs_repair.c:787
 msgid ""
 "Warning:  project quota information was cleared.\n"
 "Project quotas can not be enforced until limit information is recreated.\n"
 msgstr ""
-"Uwaga: informacje o limitach projektów by³y wyczyszczone.\n"
-"Limity projektów nie mog± byæ wymuszone do czasu odtworzenia informacji.\n"
+"Uwaga: informacje o limitach projektÃ³w byÅ‚y wyczyszczone.\n"
+"Limity projektÃ³w nie mogÄ… byÄ‡ wymuszone do czasu odtworzenia informacji.\n"
 
 #: ../repair/xfs_repair.c:791
 msgid ""
 "Warning:  project quota information would be cleared.\n"
 "Project quotas could not be enforced until limit information was recreated.\n"
 msgstr ""
-"Uwaga: informacje o limitach projektów zosta³yby wyczyszczone.\n"
-"Limity projektów nie mog³yby byæ wymuszone do czasu odtworzenia informacji.\n"
+"Uwaga: informacje o limitach projektÃ³w zostaÅ‚yby wyczyszczone.\n"
+"Limity projektÃ³w nie mogÅ‚yby byÄ‡ wymuszone do czasu odtworzenia informacji.\n"
 
 #: ../repair/xfs_repair.c:802
 msgid "No modify flag set, skipping filesystem flush and exiting.\n"
-msgstr "Flaga braku modyfikacji ustawiona, pominiêto zrzucanie systemu plików, zakoñczono.\n"
+msgstr "Flaga braku modyfikacji ustawiona, pominiÄ™to zrzucanie systemu plikÃ³w, zakoÅ„czono.\n"
 
 #: ../repair/xfs_repair.c:821
 msgid "Note - quota info will be regenerated on next quota mount.\n"
-msgstr "Uwaga - informacje o limitach zostan± ponownie wygenerowane przy nastêpnym montowaniu.\n"
+msgstr "Uwaga - informacje o limitach zostanÄ… ponownie wygenerowane przy nastÄ™pnym montowaniu.\n"
 
 #: ../repair/xfs_repair.c:829
 #, c-format
@@ -9552,8 +9552,8 @@ msgid ""
 "Note - stripe unit (%d) and width (%d) fields have been reset.\n"
 "Please set with mount -o sunit=<value>,swidth=<value>\n"
 msgstr ""
-"Uwaga - pola jednostki pasa (%d) i szeroko¶ci pasa (%d) zosta³y przestawione.\n"
-"Proszê ustawiæ przy u¿yciu mount -o sunit=<warto¶æ>,swidth=<warto¶æ>\n"
+"Uwaga - pola jednostki pasa (%d) i szerokoÅ›ci pasa (%d) zostaÅ‚y przestawione.\n"
+"ProszÄ™ ustawiÄ‡ przy uÅ¼yciu mount -o sunit=<wartoÅ›Ä‡>,swidth=<wartoÅ›Ä‡>\n"
 
 #: ../repair/xfs_repair.c:852
 msgid "done\n"
@@ -9562,17 +9562,17 @@ msgstr "gotowe\n"
 #: ../rtcp/xfs_rtcp.c:30
 #, c-format
 msgid "%s [-e extsize] [-p] source target\n"
-msgstr "%s [-e rozm_fragmentu] [-p] ¼ród³o cel\n"
+msgstr "%s [-e rozm_fragmentu] [-p] ÅºrÃ³dÅ‚o cel\n"
 
 #: ../rtcp/xfs_rtcp.c:71
 #, c-format
 msgid "%s: must specify files to copy\n"
-msgstr "%s: trzeba podaæ pliki do skopiowania\n"
+msgstr "%s: trzeba podaÄ‡ pliki do skopiowania\n"
 
 #: ../rtcp/xfs_rtcp.c:86
 #, c-format
 msgid "%s: stat64 of %s failed\n"
-msgstr "%s: stat64 na %s nie powiod³o siê\n"
+msgstr "%s: stat64 na %s nie powiodÅ‚o siÄ™\n"
 
 #: ../rtcp/xfs_rtcp.c:93
 #, c-format
@@ -9582,27 +9582,27 @@ msgstr "%s: ostatni argument nie jest katalogiem\n"
 #: ../rtcp/xfs_rtcp.c:140
 #, c-format
 msgid "%s: failed stat64 on %s: %s\n"
-msgstr "%s: nie uda³o siê wykonaæ stat64 na %s: %s\n"
+msgstr "%s: nie udaÅ‚o siÄ™ wykonaÄ‡ stat64 na %s: %s\n"
 
 #: ../rtcp/xfs_rtcp.c:161
 #, c-format
 msgid "%s: %s filesystem has no realtime partition\n"
-msgstr "%s: system plików %s nie ma partycji realtime\n"
+msgstr "%s: system plikÃ³w %s nie ma partycji realtime\n"
 
 #: ../rtcp/xfs_rtcp.c:182 ../rtcp/xfs_rtcp.c:210
 #, c-format
 msgid "%s: open of %s failed: %s\n"
-msgstr "%s: otwarcie %s nie powiod³o siê: %s\n"
+msgstr "%s: otwarcie %s nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../rtcp/xfs_rtcp.c:199
 #, c-format
 msgid "%s: set attributes on %s failed: %s\n"
-msgstr "%s: ustawienie atrybutów dla %s nie powiod³o siê: %s\n"
+msgstr "%s: ustawienie atrybutÃ³w dla %s nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../rtcp/xfs_rtcp.c:217
 #, c-format
 msgid "%s: get attributes of %s failed: %s\n"
-msgstr "%s: pobranie atrybutów %s nie powiod³o siê: %s\n"
+msgstr "%s: pobranie atrybutÃ³w %s nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../rtcp/xfs_rtcp.c:227 ../rtcp/xfs_rtcp.c:262
 #, c-format
@@ -9617,39 +9617,39 @@ msgstr "%s: plik %s ma rozmiar fragmentu %d zamiast %d.\n"
 #: ../rtcp/xfs_rtcp.c:248 ../rtcp/xfs_rtcp.c:271
 #, c-format
 msgid "%s: open of %s source failed: %s\n"
-msgstr "%s: otwarcie ¼ród³a %s nie powiod³o siê: %s\n"
+msgstr "%s: otwarcie ÅºrÃ³dÅ‚a %s nie powiodÅ‚o siÄ™: %s\n"
 
 #: ../rtcp/xfs_rtcp.c:285
 #, c-format
 msgid "%s: couldn't get direct I/O information: %s\n"
-msgstr "%s: nie uda³o siê uzyskaæ informacji o bezpo¶rednim we/wy: %s\n"
+msgstr "%s: nie udaÅ‚o siÄ™ uzyskaÄ‡ informacji o bezpoÅ›rednim we/wy: %s\n"
 
 #: ../rtcp/xfs_rtcp.c:295
 #, c-format
 msgid "%s: extent size %d not a multiple of %d.\n"
-msgstr "%s: rozmiar fragmentu %d nie jest wielokrotno¶ci± %d.\n"
+msgstr "%s: rozmiar fragmentu %d nie jest wielokrotnoÅ›ciÄ… %d.\n"
 
 #: ../rtcp/xfs_rtcp.c:309
 #, c-format
 msgid "The size of %s is not a multiple of %d.\n"
-msgstr "Rozmiar %s nie jest wielokrotno¶ci± %d.\n"
+msgstr "Rozmiar %s nie jest wielokrotnoÅ›ciÄ… %d.\n"
 
 #: ../rtcp/xfs_rtcp.c:312
 #, c-format
 msgid "%s will be padded to %lld bytes.\n"
-msgstr "%s: zostanie dope³niony do %lld bajtów.\n"
+msgstr "%s: zostanie dopeÅ‚niony do %lld bajtÃ³w.\n"
 
 #: ../rtcp/xfs_rtcp.c:318
 #, c-format
 msgid "Use the -p option to pad %s to a size which is a multiple of %d bytes.\n"
-msgstr "Mo¿na u¿yæ opcji -p do dope³nienia %s do rozmiaru bêd±cego wielokrotno¶ci± %d bajtów.\n"
+msgstr "MoÅ¼na uÅ¼yÄ‡ opcji -p do dopeÅ‚nienia %s do rozmiaru bÄ™dÄ…cego wielokrotnoÅ›ciÄ… %d bajtÃ³w.\n"
 
 #: ../rtcp/xfs_rtcp.c:360
 #, c-format
 msgid "%s: write error: %s\n"
-msgstr "%s: b³±d zapisu: %s\n"
+msgstr "%s: bÅ‚Ä…d zapisu: %s\n"
 
 #: ../rtcp/xfs_rtcp.c:388
 #, c-format
 msgid "%s: could not open %s: %s\n"
-msgstr "%s: nie uda³o siê otworzyæ %s: %s\n"
+msgstr "%s: nie udaÅ‚o siÄ™ otworzyÄ‡ %s: %s\n"
-- 
1.6.1.1


--===============7460526303391746058==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7460526303391746058==--
