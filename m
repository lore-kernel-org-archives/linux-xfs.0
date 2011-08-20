Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7KML5OI178363 for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 17:21:06 -0500
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F2DB1377591
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 15:23:31 -0700 (PDT)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id JZVi2MANTDhFqlFL for
	<xfs@oss.sgi.com>; Sat, 20 Aug 2011 15:23:31 -0700 (PDT)
MIME-Version: 1.0
From: owner@bugs.debian.org (Debian Bug Tracking System)
Subject: Bug#553875: marked as done (replacing libreadline5-dev build
	dependency with libreadline-dev)
Message-ID: <handler.553875.D553875.131387866128226.ackdone@bugs.debian.org>
References: <E1QutrH-00060P-Uy@franck.debian.org>
	<200911020111.nA21BMV5011421@bolero.cs.tu-berlin.de>
Date: Sat, 20 Aug 2011 22:21:03 +0000
Content-Type: multipart/mixed; boundary="----------=_1313878863-29327-0"
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
To: Aurelien Jarno <aurel32@debian.org>

This is a multi-part message in MIME format...

------------=_1313878863-29327-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf-8

Your message dated Sat, 20 Aug 2011 22:17:39 +0000
with message-id <E1QutrH-00060P-Uy@franck.debian.org>
and subject line Bug#553875: fixed in xfsprogs 3.1.5+nmu1
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

------------=_1313878863-29327-0
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



------------=_1313878863-29327-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 553875-close) by bugs.debian.org; 20 Aug 2011 22:17:41 +0000
X-Spam-Checker-Version: SpamAssassin 3.3.1-bugs.debian.org_2005_01_02
	(2010-03-16) on busoni.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,IMPRONONCABLE_2,MURPHY_WRONG_WORD1,
	MURPHY_WRONG_WORD2,PGPSIGNATURE autolearn=ham
	version=3.3.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 32; hammy, 151; neutral, 147; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--H*MI:franck, 0.000-+--H*RU:128.148.34.3
Return-path: <envelope@ftp-master.debian.org>
Received: from franck.debian.org ([128.148.34.3])
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=franck.debian.org,EMAIL=hostmaster@franck.debian.org (verified)
	by busoni.debian.org with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1QutrI-0007L7-SF
	for 553875-close@bugs.debian.org; Sat, 20 Aug 2011 22:17:40 +0000
Received: from dak by franck.debian.org with local (Exim 4.72)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1QutrH-00060P-Uy; Sat, 20 Aug 2011 22:17:39 +0000
Date: Sat, 20 Aug 2011 22:17:39 +0000
Message-Id: <E1QutrH-00060P-Uy@franck.debian.org>
From: Aurelien Jarno <aurel32@debian.org>
To: 553875-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#553875: fixed in xfsprogs 3.1.5+nmu1
Sender: Archive Administrator <dak@franck.debian.org>

Source: xfsprogs
Source-Version: 3.1.5+nmu1

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive:

xfslibs-dev_3.1.5+nmu1_amd64.deb
  to main/x/xfsprogs/xfslibs-dev_3.1.5+nmu1_amd64.deb
xfsprogs-udeb_3.1.5+nmu1_amd64.udeb
  to main/x/xfsprogs/xfsprogs-udeb_3.1.5+nmu1_amd64.udeb
xfsprogs_3.1.5+nmu1.dsc
  to main/x/xfsprogs/xfsprogs_3.1.5+nmu1.dsc
xfsprogs_3.1.5+nmu1.tar.gz
  to main/x/xfsprogs/xfsprogs_3.1.5+nmu1.tar.gz
xfsprogs_3.1.5+nmu1_amd64.deb
  to main/x/xfsprogs/xfsprogs_3.1.5+nmu1_amd64.deb



A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 553875@bugs.debian.org,
and the maintainer will reopen the bug report if appropriate.

Debian distribution maintenance software
pp.
Aurelien Jarno <aurel32@debian.org> (supplier of updated xfsprogs package)

(This message was generated automatically at their request; if you
believe that there is a problem with it please contact the archive
administrators by mailing ftpmaster@debian.org)


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 1.8
Date: Sat, 20 Aug 2011 23:14:01 +0200
Source: xfsprogs
Binary: xfsprogs xfslibs-dev xfsprogs-udeb
Architecture: source amd64
Version: 3.1.5+nmu1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <xfs@oss.sgi.com>
Changed-By: Aurelien Jarno <aurel32@debian.org>
Description: 
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Closes: 553875
Changes: 
 xfsprogs (3.1.5+nmu1) unstable; urgency=low
 .
   * Non-maintainer upload, breaking the assumption: "the upstream
     release is also the Debian release" (see bug#144876).
   * Build-depends on libreadline-gplv2-dev instead of libreadline5-dev
     as the code is not compatible with GPL v3 (closes: #553875).
Checksums-Sha1: 
 98e7a109be5e1ee07a0671913358e86148fc993c 967 xfsprogs_3.1.5+nmu1.dsc
 b80b563d4b79bed51f3bbc99dadb26c6467b812c 1416150 xfsprogs_3.1.5+nmu1.tar.gz
 8d2dde1caf26a639b2f98aa77e39ec04871cd4e7 1437206 xfsprogs_3.1.5+nmu1_amd64.deb
 5c85b0fe7cf36de44aca85ff4854646647abf671 31814 xfslibs-dev_3.1.5+nmu1_amd64.deb
 2da52f92652f21455f1ca42f49bcb5848aa3b30f 119136 xfsprogs-udeb_3.1.5+nmu1_amd64.udeb
Checksums-Sha256: 
 397d45a400ffc473421dc44908875a88306c5bbc9e3d9b46f36d37314eefda2c 967 xfsprogs_3.1.5+nmu1.dsc
 68905b4361d6a4a822dc87eb3999657a7583374f49feca9a4d370a1b478f6eaf 1416150 xfsprogs_3.1.5+nmu1.tar.gz
 3422bd3a92a0727444cf5b9e66d9f24546acc8470e91c24133b67ba7cb3b0ff8 1437206 xfsprogs_3.1.5+nmu1_amd64.deb
 4ce1ade7a95428f9fd0358be91b10653116ef940b10b9c5ea8b49fc402c98c26 31814 xfslibs-dev_3.1.5+nmu1_amd64.deb
 ed665979201d8d9e0eba48708c2754d5a6ac16a2ac9ae5b78c5a2fab6b1815a0 119136 xfsprogs-udeb_3.1.5+nmu1_amd64.udeb
Files: 
 16eaa98172892fc4419da32a094fadc5 967 admin optional xfsprogs_3.1.5+nmu1.dsc
 169074ee4075ed13e06ee00299e1bcbe 1416150 admin optional xfsprogs_3.1.5+nmu1.tar.gz
 b612d0d9452be60a4815bab0b905ff83 1437206 admin optional xfsprogs_3.1.5+nmu1_amd64.deb
 1237d195b1da0af528d0cca22c05a4de 31814 libdevel extra xfslibs-dev_3.1.5+nmu1_amd64.deb
 53fd0a552800696bc757ba12792ced88 119136 debian-installer optional xfsprogs-udeb_3.1.5+nmu1_amd64.udeb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOUCw5w3ao2vG823MRAndCAJ95sPcb7t+Xrk8JQkGkYKVkUKAr7wCfdhd6
oP0QR84GmpWKkPZHrXd7dQs=
=a8ld
-----END PGP SIGNATURE-----



------------=_1313878863-29327-0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------------=_1313878863-29327-0--
