Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAIMa97h211081 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 16:36:09 -0600
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E408263549
	for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 14:36:07 -0800 (PST)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id 8x0gIZV2kYdrlnux for
	<xfs@oss.sgi.com>; Fri, 18 Nov 2011 14:36:07 -0800 (PST)
MIME-Version: 1.0
From: owner@bugs.debian.org (Debian Bug Tracking System)
Subject: Bug#553875: marked as done (replacing libreadline5-dev build
	dependency with libreadline-dev)
Message-ID: <handler.553875.D553875.132165558114693.ackdone@bugs.debian.org>
References: <E1RRWzT-0006Hh-Om@franck.debian.org>
	<200911020111.nA21BMV5011421@bolero.cs.tu-berlin.de>
Date: Fri, 18 Nov 2011 22:36:03 +0000
Content-Type: multipart/mixed; boundary="----------=_1321655763-15725-0"
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

------------=_1321655763-15725-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf-8

Your message dated Fri, 18 Nov 2011 22:32:59 +0000
with message-id <E1RRWzT-0006Hh-Om@franck.debian.org>
and subject line Bug#553875: fixed in xfsprogs 3.1.7
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

------------=_1321655763-15725-0
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



------------=_1321655763-15725-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 553875-close) by bugs.debian.org; 18 Nov 2011 22:33:01 +0000
X-Spam-Checker-Version: SpamAssassin 3.3.1-bugs.debian.org_2005_01_02
	(2010-03-16) on busoni.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,IMPRONONCABLE_1,IMPRONONCABLE_2,
	MURPHY_WRONG_WORD1,MURPHY_WRONG_WORD2,PGPSIGNATURE autolearn=ham
	version=3.3.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 34; hammy, 151; neutral, 130; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--H*RU:128.148.34.3, 0.000-+--HX-Spam-Relays-External:128.148.34.3
Return-path: <envelope@ftp-master.debian.org>
Received: from franck.debian.org ([128.148.34.3])
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=franck.debian.org,EMAIL=hostmaster@franck.debian.org (verified)
	by busoni.debian.org with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1RRWzU-0003oA-UV
	for 553875-close@bugs.debian.org; Fri, 18 Nov 2011 22:33:01 +0000
Received: from dak by franck.debian.org with local (Exim 4.72)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1RRWzT-0006Hh-Om; Fri, 18 Nov 2011 22:32:59 +0000
Date: Fri, 18 Nov 2011 22:32:59 +0000
Message-Id: <E1RRWzT-0006Hh-Om@franck.debian.org>
From: Nathan Scott <nathans@debian.org>
To: 553875-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#553875: fixed in xfsprogs 3.1.7
Sender: Archive Administrator <dak@franck.debian.org>

Source: xfsprogs
Source-Version: 3.1.7

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive:

xfslibs-dev_3.1.7_i386.deb
  to main/x/xfsprogs/xfslibs-dev_3.1.7_i386.deb
xfsprogs-udeb_3.1.7_i386.udeb
  to main/x/xfsprogs/xfsprogs-udeb_3.1.7_i386.udeb
xfsprogs_3.1.7.dsc
  to main/x/xfsprogs/xfsprogs_3.1.7.dsc
xfsprogs_3.1.7.tar.gz
  to main/x/xfsprogs/xfsprogs_3.1.7.tar.gz
xfsprogs_3.1.7_i386.deb
  to main/x/xfsprogs/xfsprogs_3.1.7_i386.deb



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
Date: Thu, 17 Nov 2011 08:47:00 +1100
Source: xfsprogs
Binary: xfsprogs xfslibs-dev xfsprogs-udeb
Architecture: source i386
Version: 3.1.7
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
 xfsprogs (3.1.7) unstable; urgency=low
 .
   * New upstream release
   * Fix libreadline build dependency (closes: #553875)
Checksums-Sha1: 
 f5474e00d0ca22e7aef74110aaeefcbfd10b90fb 1096 xfsprogs_3.1.7.dsc
 ca305727a106d1d13a736d691f8666a4732e89e1 1398644 xfsprogs_3.1.7.tar.gz
 1ce72599c11e80ec52ac32d4e73608b85a5ddf64 1543174 xfsprogs_3.1.7_i386.deb
 2abf0dfd9f9ba3d9e8dce6c9148566968c24e3a8 32126 xfslibs-dev_3.1.7_i386.deb
 49cabd6c61461057493370a6855a4601b0dff19a 138904 xfsprogs-udeb_3.1.7_i386.udeb
Checksums-Sha256: 
 2a723a34e14eb263803772789809eb7563fbea68e224c28c10bd660e9ac76ec1 1096 xfsprogs_3.1.7.dsc
 1c529e623bc26bd7987229d55397562339a8cb5cd3aeeef7fc36a2ec47d6e7f7 1398644 xfsprogs_3.1.7.tar.gz
 b977e9ab6f8e2bc4e2508984adca16fa89b27f5ac88a4cfab5fb81374babef79 1543174 xfsprogs_3.1.7_i386.deb
 560f812d9acab6beb3d0270d895ea70d924246701eda77c578e6decfbdcff344 32126 xfslibs-dev_3.1.7_i386.deb
 c0b20e3908c6070a2820b12fbb80cccb24dfd7179007c1c36632e829088bc9d3 138904 xfsprogs-udeb_3.1.7_i386.udeb
Files: 
 11d43a6eed718c4bf736081b829c25b1 1096 admin optional xfsprogs_3.1.7.dsc
 535e5282887840eaab5a902bef0e4fcf 1398644 admin optional xfsprogs_3.1.7.tar.gz
 49999d460519278d15da6ca86adb246a 1543174 admin optional xfsprogs_3.1.7_i386.deb
 6cdaeafa9246d04b484c417fd358da9a 32126 libdevel extra xfslibs-dev_3.1.7_i386.deb
 e2798dd5fd325b32c0e70e4e443b537f 138904 debian-installer optional xfsprogs-udeb_3.1.7_i386.udeb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7G1oQACgkQm8fl3HSIa2NNvQCeLpkMJqIFcqia6nlRfHNYyeza
EnQAniDSRUz8r2kjkaImScPzi7cT3OjU
=LJb8
-----END PGP SIGNATURE-----



------------=_1321655763-15725-0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------------=_1321655763-15725-0--
