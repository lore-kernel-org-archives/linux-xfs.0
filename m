Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p35AaIke234551 for <xfs@oss.sgi.com>; Tue, 5 Apr 2011 05:36:18 -0500
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 393E53A0E0C
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2011 03:39:32 -0700 (PDT)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id PhtuzhlwSSPnF492 for
	<xfs@oss.sgi.com>; Tue, 05 Apr 2011 03:39:32 -0700 (PDT)
MIME-Version: 1.0
From: owner@bugs.debian.org (Debian Bug Tracking System)
Subject: Bug#618730: marked as done (xfsprogs: xfs_quota -xc "report -Nt
	/xfs_test" i.e. cause error "XFS_GETQUOTA: No such process")
Message-ID: <handler.618730.D618730.130199986821901.ackdone@bugs.debian.org>
References: <E1Q73dh-0001s6-E4@franck.debian.org>
	<20110317233011.23073.36060.reportbug@store1b.math.uni-bielefeld.de>
Date: Tue, 05 Apr 2011 10:39:13 +0000
Content-Type: multipart/mixed; boundary="----------=_1301999953-22089-0"
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

------------=_1301999953-22089-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf-8

Your message dated Tue, 05 Apr 2011 10:37:37 +0000
with message-id <E1Q73dh-0001s6-E4@franck.debian.org>
and subject line Bug#618730: fixed in xfsprogs 3.1.5
has caused the Debian Bug report #618730,
regarding xfsprogs: xfs_quota -xc "report -Nt /xfs_test" i.e. cause error "=
XFS_GETQUOTA: No such process"
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
618730: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D618730
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1301999953-22089-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 17 Mar 2011 23:37:07 +0000
X-Spam-Checker-Version: SpamAssassin 3.2.5-bugs.debian.org_2005_01_02
	(2008-06-10) on busoni.debian.org
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 37; hammy, 151; neutral, 116; spammy,
	0. spammytokens: hammytokens:0.000-+--H*M:reportbug, 0.000-+--H*MI:reportbug,
	0.000-+--H*x:reportbug, 0.000-+--H*UA:reportbug, 0.000-+--H*x:4.12.6
X-Spam-Status: No, score=-10.4 required=4.0 tests=BAYES_00,FOURLA,
	FVGT_m_MULTI_ODD,HAS_PACKAGE,MURPHY_DRUGS_REL8,SPF_PASS,URIBL_CNKR,
	XMAILER_REPORTBUG autolearn=ham version=3.2.5-bugs.debian.org_2005_01_02
Return-path: <tblomenk@math.uni-bielefeld.de>
Received: from mail1.math.uni-bielefeld.de ([129.70.14.32])
	by busoni.debian.org with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <tblomenk@math.uni-bielefeld.de>)
	id 1Q0MkX-0007Id-3L
	for submit@bugs.debian.org; Thu, 17 Mar 2011 23:37:07 +0000
Received: from store1b.math.uni-bielefeld.de (store1b.math.uni-bielefeld.de [129.70.14.42])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail1.math.uni-bielefeld.de (Postfix) with ESMTPSA id AC8CB123726;
	Fri, 18 Mar 2011 00:30:20 +0100 (CET)
Content-Type: multipart/mixed; boundary="===============7436659676756291069=="
MIME-Version: 1.0
From: Thomas Blomenkamp <tblomenk@math.uni-bielefeld.de>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfsprogs: xfs_quota -xc "report -Nt /xfs_test" i.e. cause error
 "XFS_GETQUOTA: No such process"
Message-ID: <20110317233011.23073.36060.reportbug@store1b.math.uni-bielefeld.de>
X-Mailer: reportbug 4.12.6
Date: Fri, 18 Mar 2011 00:30:11 +0100
X-Greylist: delayed 390 seconds by postgrey-1.31 at busoni; Thu, 17 Mar 2011 23:37:00 UTC
Delivered-To: submit@bugs.debian.org

This is a multi-part MIME message sent by reportbug.


--===============7436659676756291069==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Package: xfsprogs
Version: 3.1.4
Severity: normal
Tags: squeeze patch

Consider the following situation:

A block-device with xfs-filesystem is mounted on /xfs_test and the xfs_quota option is enabled (i.e. by mounting with option uqnoenforce).

Then if you use the prog. xfs_quota to get a report of the user quota on /xfs, you get sth. like this:

foobar:~#xfs_quota -xc "report -Nt /xfs_test"

root          2019836          0          0     00 [--------]

XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process

I have attached a patch which worked fine for me.

I want to thank Eric Sandeen for fixing this bug and refer to http://patchwork.xfs.org/patch/1714/


Regards, Thomas


-- System Information:
Debian Release: 6.0
  APT prefers squeeze-updates
  APT policy: (500, 'squeeze-updates'), (500, 'stable')
Architecture: amd64 (x86_64)

Kernel: Linux 2.6.32-5-amd64 (SMP w/8 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash

Versions of packages xfsprogs depends on:
ii  libblkid1                     2.17.2-9   block device id library
ii  libc6                         2.11.2-10  Embedded GNU C Library: Shared lib
ii  libreadline5                  5.2-7      GNU readline and history libraries
ii  libuuid1                      2.17.2-9   Universally Unique ID library

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
pn  acl                           <none>     (no description available)
pn  attr                          <none>     (no description available)
pn  quota                         <none>     (no description available)
ii  xfsdump                       3.0.4      Administrative utilities for the X

-- no debconf information

--===============7436659676756291069==
Content-Type: text/x-diff; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="xfsprogs_quota_report_fix.patch"

diff -crB xfsprogs-3.1.4/quota/report.c xfsprogs-3.1.4_quota_fix/quota/report.c
*** xfsprogs-3.1.4/quota/report.c	2009-04-27 07:48:02.000000000 +0200
--- xfsprogs-3.1.4_quota_fix/quota/report.c	2011-03-17 23:03:06.479607647 +0100
***************
*** 302,308 ****
  	int		count;
  
  	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
! 		if (errno != ENOENT && errno != ENOSYS)
  			perror("XFS_GETQUOTA");
  		return 0;
  	}
--- 302,308 ----
  	int		count;
  
  	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
! 		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH)
  			perror("XFS_GETQUOTA");
  		return 0;
  	}

--===============7436659676756291069==--



------------=_1301999953-22089-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 618730-close) by bugs.debian.org; 5 Apr 2011 10:37:48 +0000
X-Spam-Checker-Version: SpamAssassin 3.3.1-bugs.debian.org_2005_01_02
	(2010-03-16) on busoni.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,IMPRONONCABLE_2,MURPHY_WRONG_WORD2,
	PGPSIGNATURE,URIBL_CNKR autolearn=ham version=3.3.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 46; hammy, 151; neutral, 116; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--H*MI:franck, 0.000-+--H*RU:128.148.34.3
Return-path: <envelope@ftp-master.debian.org>
Received: from franck.debian.org ([128.148.34.3])
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=franck.debian.org,EMAIL=hostmaster@franck.debian.org (verified)
	by busoni.debian.org with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1Q73di-0005gr-Cj
	for 618730-close@bugs.debian.org; Tue, 05 Apr 2011 10:37:41 +0000
Received: from dak by franck.debian.org with local (Exim 4.72)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1Q73dh-0001s6-E4; Tue, 05 Apr 2011 10:37:37 +0000
Date: Tue, 05 Apr 2011 10:37:37 +0000
Message-Id: <E1Q73dh-0001s6-E4@franck.debian.org>
From: Nathan Scott <nathans@debian.org>
To: 618730-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: Bug#618730: fixed in xfsprogs 3.1.5
Sender: Archive Administrator <dak@franck.debian.org>
Content-Transfer-Encoding: quoted-printable

Source: xfsprogs
Source-Version: 3.1.5

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive:

xfslibs-dev_3.1.5_i386.deb
  to main/x/xfsprogs/xfslibs-dev_3.1.5_i386.deb
xfsprogs-udeb_3.1.5_i386.udeb
  to main/x/xfsprogs/xfsprogs-udeb_3.1.5_i386.udeb
xfsprogs_3.1.5.dsc
  to main/x/xfsprogs/xfsprogs_3.1.5.dsc
xfsprogs_3.1.5.tar.gz
  to main/x/xfsprogs/xfsprogs_3.1.5.tar.gz
xfsprogs_3.1.5_i386.deb
  to main/x/xfsprogs/xfsprogs_3.1.5_i386.deb



A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 618730@bugs.debian.org,
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
Date: Wed, 31 Mar 2011 09:00:00 +1100
Source: xfsprogs
Binary: xfsprogs xfslibs-dev xfsprogs-udeb
Architecture: source i386
Version: 3.1.5
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <xfs@oss.sgi.com>
Changed-By: Nathan Scott <nathans@debian.org>
Description:=20
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installe=
r (udeb)
Closes: 618730
Changes:=20
 xfsprogs (3.1.5) unstable; urgency=3Dlow
 .
   * New upstream release
   * No more xfsquota error message for non-quota mounts (closes: #618730=
)
Checksums-Sha1:=20
 f1089452856d2cad4242c5ac95365c8dbf97c447 950 xfsprogs_3.1.5.dsc
 d14fc72b02d6af12050ee2dde253173cfc238dec 1413716 xfsprogs_3.1.5.tar.gz
 661b1922b958c2aa6ba7dbd93e8e4cea1e1d651b 1506078 xfsprogs_3.1.5_i386.deb
 2956ad2b34096a986ce3d5012c3c469237eceb92 31484 xfslibs-dev_3.1.5_i386.de=
b
 a9c575dbcecce83c8c4b467d882bee3902c51cec 119956 xfsprogs-udeb_3.1.5_i386=
.udeb
Checksums-Sha256:=20
 1a5e10ea5e005647c102daa7773fada995d4743c77611c9a886b59c9ebd9cc08 950 xfs=
progs_3.1.5.dsc
 88d52d58c28b702936f629e913f8e1a2890e35af3a488f557f16b273f7cac2a6 1413716=
 xfsprogs_3.1.5.tar.gz
 24578e5287698fbe403f0b0aecd62fc5fb9eaabb606e9d50c5d874c25d357826 1506078=
 xfsprogs_3.1.5_i386.deb
 aaca2a2955278b7e577bac75366d54187e29a68d84b99a32b2195b72bddfd83c 31484 x=
fslibs-dev_3.1.5_i386.deb
 fe4c61bb40407498631e6297320b41e5be8064750ba40c59db7fe54f164bee2d 119956 =
xfsprogs-udeb_3.1.5_i386.udeb
Files:=20
 d3716a2b168ff2bed94d8a8a7531e343 950 admin optional xfsprogs_3.1.5.dsc
 3d496cfc155d9be9bfae6d6d8413f305 1413716 admin optional xfsprogs_3.1.5.t=
ar.gz
 d57a2ecf3da808792631fae5f387129e 1506078 admin optional xfsprogs_3.1.5_i=
386.deb
 5c2b80c1bb05c2e5b8a1eaf86fec6126 31484 libdevel extra xfslibs-dev_3.1.5_=
i386.deb
 9e5913a15d1023ccdc78e2574ba3ad2b 119956 debian-installer optional xfspro=
gs-udeb_3.1.5_i386.udeb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2a7CYACgkQm8fl3HSIa2PqogCgmXO7v497byit6ARD3aaHwrhE
kuQAnApXKzkxic3bpG33wVX30H7t917/
=3DM+/F
-----END PGP SIGNATURE-----



------------=_1301999953-22089-0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------------=_1301999953-22089-0--
