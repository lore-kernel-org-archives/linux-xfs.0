Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAB5pIZi174093 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 23:51:19 -0600
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 219FA10507E0
	for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 21:51:16 -0800 (PST)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id zkgAlt23iQErg971 for
	<xfs@oss.sgi.com>; Thu, 10 Nov 2011 21:51:16 -0800 (PST)
MIME-Version: 1.0
From: owner@bugs.debian.org (Debian Bug Tracking System)
Subject: Bug#553875: marked as done (replacing libreadline5-dev build
	dependency with libreadline-dev)
Message-ID: <handler.553875.D553875.132099044311074.ackdone@bugs.debian.org>
References: <E1ROjxS-0007Tc-0c@franck.debian.org>
	<200911020111.nA21BMV5011421@bolero.cs.tu-berlin.de>
Date: Fri, 11 Nov 2011 05:51:12 +0000
Content-Type: multipart/mixed; boundary="----------=_1320990672-12238-0"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nathan Scott <nathans@debian.org>

This is a multi-part message in MIME format...

------------=_1320990672-12238-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf-8

Your message dated Fri, 11 Nov 2011 05:47:22 +0000
with message-id <E1ROjxS-0007Tc-0c@franck.debian.org>
and subject line Bug#553875: fixed in xfsprogs 3.1.6
has caused the Debian Bug report #553875,
regarding replacing libreadline5-dev build dependency with libreadline-dev
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
553875: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D553875
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1320990672-12238-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at maintonly) by bugs.debian.org; 2 Nov 2009 01:19:24 +0000
X-Spam-Checker-Version: SpamAssassin 3.2.3-bugs.debian.org_2005_01_02
	(2007-08-08) on rietz.debian.org
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 10; hammy, 94; neutral, 43; spammy, 0.
	spammytokens: hammytokens:0.000-+--Usertags, 0.000-+--Severity,
	0.000-+--usertags, 0.000-+--sk:lists.d, 0.000-+--severity
X-Spam-Status: No, score=-9.3 required=4.0 tests=AWL,BAYES_00,HAS_PACKAGE,
	RCVD_IN_DNSWL_MED autolearn=ham version=3.2.3-bugs.debian.org_2005_01_02
Return-path: <doko@cs.tu-berlin.de>
Received: from mail.cs.tu-berlin.de ([130.149.17.13])
	by rietz.debian.org with esmtp (Exim 4.63)
	(envelope-from <doko@cs.tu-berlin.de>)
	id 1N4lZs-00065m-Ks
	for maintonly@bugs.debian.org; Mon, 02 Nov 2009 01:19:24 +0000
Received: from localhost (localhost [127.0.0.1])
	by localhost-12225.cs.tu-berlin.de (Postfix) with ESMTP id 66CE62A5A4
	for <maintonly@bugs.debian.org>; Mon,  2 Nov 2009 02:11:32 +0100 (MET)
X-Virus-Scanned: amavisd-new at cs.tu-berlin.de (including SpamAssassin)
Received: from mailhost.cs.tu-berlin.de ([127.0.0.1])
	by localhost (mail.cs.tu-berlin.de [127.0.0.1]) (amavisd-new, port 12224)
	with ESMTP id b+HXJT2HkfTf 06852-17 for <maintonly@bugs.debian.org>;
	Mon,  2 Nov 2009 02:11:23 +0100 (MET) 16504
Received: from bolero.cs.tu-berlin.de (bolero.cs.tu-berlin.de [130.149.19.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhost.cs.tu-berlin.de (Postfix) with ESMTPS
	for <maintonly@bugs.debian.org>; Mon,  2 Nov 2009 02:11:23 +0100 (MET)
Received: (from doko@localhost)
	by bolero.cs.tu-berlin.de (8.13.8+Sun/8.13.3/Submit) id nA21BMV5011421
	for maintonly@bugs.debian.org; Mon, 2 Nov 2009 02:11:22 +0100 (MET)
Date: Mon, 2 Nov 2009 02:11:22 +0100 (MET)
From: Matthias Klose <doko@cs.tu-berlin.de>
Message-Id: <200911020111.nA21BMV5011421@bolero.cs.tu-berlin.de>
To: maintonly@bugs.debian.org
Subject: replacing libreadline5-dev build dependency with libreadline-dev
Delivered-To: maintonly@bugs.debian.org

Package: xfsprogs
Version: 3.0.4
Severity: important
User: doko@debian.org
Usertags: readline6

Sent to http://lists.debian.org/debian-devel/2009/09/msg00549.html
As a package maintainer you got this email directly as well.

Both libreadline-dev (>= 6.0) and libreadline6-dev are now available
in unstable and testing. If possible, please replace the libreadline5-dev
build dependency with libreadline-dev, so that in future changes of the
libreadline soname binNMU's can be used for this kind of update.



------------=_1320990672-12238-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 553875-close) by bugs.debian.org; 11 Nov 2011 05:47:23 +0000
X-Spam-Checker-Version: SpamAssassin 3.3.1-bugs.debian.org_2005_01_02
	(2010-03-16) on busoni.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,IMPRONONCABLE_2,MURPHY_WRONG_WORD1,
	MURPHY_WRONG_WORD2,PGPSIGNATURE autolearn=ham
	version=3.3.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 33; hammy, 151; neutral, 127; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--H*RU:128.148.34.3, 0.000-+--HX-Spam-Relays-External:128.148.34.3
Return-path: <envelope@ftp-master.debian.org>
Received: from franck.debian.org ([128.148.34.3])
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=franck.debian.org,EMAIL=hostmaster@franck.debian.org (verified)
	by busoni.debian.org with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1ROjxT-0002sT-Ee
	for 553875-close@bugs.debian.org; Fri, 11 Nov 2011 05:47:23 +0000
Received: from dak by franck.debian.org with local (Exim 4.72)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1ROjxS-0007Tc-0c; Fri, 11 Nov 2011 05:47:22 +0000
Date: Fri, 11 Nov 2011 05:47:22 +0000
Message-Id: <E1ROjxS-0007Tc-0c@franck.debian.org>
From: Nathan Scott <nathans@debian.org>
To: 553875-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#553875: fixed in xfsprogs 3.1.6
Sender: Archive Administrator <dak@franck.debian.org>

Source: xfsprogs
Source-Version: 3.1.6

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive:

xfslibs-dev_3.1.6_i386.deb
  to main/x/xfsprogs/xfslibs-dev_3.1.6_i386.deb
xfsprogs-udeb_3.1.6_i386.udeb
  to main/x/xfsprogs/xfsprogs-udeb_3.1.6_i386.udeb
xfsprogs_3.1.6.dsc
  to main/x/xfsprogs/xfsprogs_3.1.6.dsc
xfsprogs_3.1.6.tar.gz
  to main/x/xfsprogs/xfsprogs_3.1.6.tar.gz
xfsprogs_3.1.6_i386.deb
  to main/x/xfsprogs/xfsprogs_3.1.6_i386.deb



A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 553875@bugs.debian.org,
and the maintainer will reopen the bug report if appropriate.

Debian distribution maintenance software
pp.
Nathan Scott <nathans@debian.org> (supplier of updated xfsprogs package)

(This message was generated automatically at their request; if you
believe that there is a problem with it please contact the archive
administrators by mailing ftpmaster@debian.org)


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 1.8
Date: Wed, 11 Oct 2011 16:47:10 +1100
Source: xfsprogs
Binary: xfsprogs xfslibs-dev xfsprogs-udeb
Architecture: source i386
Version: 3.1.6
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <xfs@oss.sgi.com>
Changed-By: Nathan Scott <nathans@debian.org>
Description: 
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Closes: 553875
Changes: 
 xfsprogs (3.1.6) unstable; urgency=low
 .
   * New upstream release
   * Handle upcoming libreadline5-dev removal (closes: #553875)
Checksums-Sha1: 
 e1070da20fbf627efca4046f0a82c497387c487e 1096 xfsprogs_3.1.6.dsc
 8f4c7382f831ec7e859891637b80e0aea712f38f 1396825 xfsprogs_3.1.6.tar.gz
 775e379f700c0a948a2207ad164d887763d2ed56 1540184 xfsprogs_3.1.6_i386.deb
 cefbdc132ccb48a2b2fde783c55fdb713a0363bf 32116 xfslibs-dev_3.1.6_i386.deb
 33012c0d6e8a9a7258cb626b1dc20cc996e6aadf 138900 xfsprogs-udeb_3.1.6_i386.udeb
Checksums-Sha256: 
 78ed9662b8a20614bd3b5852560fd0a0ad2fa855b6c20688d9fe47dd19123e17 1096 xfsprogs_3.1.6.dsc
 23cd7fc21c7b060e049c060d233260a1e3d47c5f1b2611b56210207b011d148e 1396825 xfsprogs_3.1.6.tar.gz
 768c4a7dfa63271071bd949b361c558821ac13bdbeeee96ad0cb82ac5d698fd7 1540184 xfsprogs_3.1.6_i386.deb
 18a40d519d85c0ee9577ed690926c20cf4146eec5e0f458c6188e50ed0d40c59 32116 xfslibs-dev_3.1.6_i386.deb
 948c8c0b8ef364975d955773f99b4a0e3458fb691f0b097030943333c29ac7b2 138900 xfsprogs-udeb_3.1.6_i386.udeb
Files: 
 f20785000c4ed79e504d4cbefeda4101 1096 admin optional xfsprogs_3.1.6.dsc
 f8b42126ebb35dcd832d1d51931e4aef 1396825 admin optional xfsprogs_3.1.6.tar.gz
 4a7464d5f08bca49d2454b14bcaf4db1 1540184 admin optional xfsprogs_3.1.6_i386.deb
 c51bcfb8378e8d071c419444cf98ff12 32116 libdevel extra xfslibs-dev_3.1.6_i386.deb
 a1ab7c3b5000f5ed29e59d8d2d939a03 138900 debian-installer optional xfsprogs-udeb_3.1.6_i386.udeb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk68s6gACgkQm8fl3HSIa2P8AACeMwht68MBbiXrf2oAaVlBTaAw
EXYAnAqYaH2qWOwy5Mfh5WWJ5gFGhRWJ
=3oaG
-----END PGP SIGNATURE-----



------------=_1320990672-12238-0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------------=_1320990672-12238-0--
