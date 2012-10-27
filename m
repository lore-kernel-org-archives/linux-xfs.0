Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9RMVK5A115696 for <xfs@oss.sgi.com>; Sat, 27 Oct 2012 17:31:20 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id UFd4r1xkpxCo6oWT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 27 Oct 2012 15:33:07 -0700 (PDT)
MIME-Version: 1.0
From: owner@bugs.debian.org (Debian Bug Tracking System)
Subject: Bug#691630: marked as done (xfsprogs doesn't include the program
	xfsctl)
Message-ID: <handler.691630.D691630.135137697329310.ackdone@bugs.debian.org>
References: <715033190.18087010.1351376970098.JavaMail.root@redhat.com>
	<20121027183300.8033.65529.reportbug@logan-VirtualBox>
Date: Sat, 27 Oct 2012 22:33:04 +0000
Content-Type: multipart/mixed; boundary="----------=_1351377184-31289-0"
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

------------=_1351377184-31289-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf-8

Your message dated Sat, 27 Oct 2012 18:29:30 -0400 (EDT)
with message-id <715033190.18087010.1351376970098.JavaMail.root@redhat.com>
and subject line Re: Bug#691630: xfsprogs doesn't include the program xfsctl
has caused the Debian Bug report #691630,
regarding xfsprogs doesn't include the program xfsctl
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
691630: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D691630
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1351377184-31289-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 27 Oct 2012 18:33:37 +0000
X-Spam-Checker-Version: SpamAssassin 3.3.1-bugs.debian.org_2005_01_02
	(2010-03-16) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,HAS_PACKAGE,RCVD_IN_DNSWL_LOW,SPF_PASS,
	WORD_WITHOUT_VOWELS,XMAILER_REPORTBUG autolearn=ham
	version=3.3.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 23; hammy, 151; neutral, 79; spammy,
	0. spammytokens: hammytokens:0.000-+--(unknown), 0.000-+--(unknown),
	0.000-+--(unknown), 0.000-+--(unknown), 0.000-+--(unknown)
Return-path: <logatronico@gmail.com>
Received: from mail-vb0-f52.google.com ([209.85.212.52])
	by buxtehude.debian.org with esmtps (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.72)
	(envelope-from <logatronico@gmail.com>)
	id 1TSBCS-0007qF-UN
	for submit@bugs.debian.org; Sat, 27 Oct 2012 18:33:37 +0000
Received: by mail-vb0-f52.google.com with SMTP id k17so3760929vbj.11
        for <submit@bugs.debian.org>; Sat, 27 Oct 2012 11:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=content-type:mime-version:content-transfer-encoding:from:to:subject
         :message-id:x-mailer:date;
        bh=C+X+ygZiNiQiQUnM0CYyzQMi6rtFaalH2wr6DL9PP/8=;
        b=OhmTeigDAaTolBbiV0V+jbLAzN5O8WCMAqqbSWRO4t7tOgQChZ1B3Hf6wpYRsQ9LPh
         u8/pzJL/ESNyADyVuwXaPl78hYcsG79GcKEFkgQN6rj9oXgbe/FzuGHqZI11fpPIXSQA
         EPLFDydy/2Uxt2a/tP0bki6ItibXGEY088lTcCFNvE2dhikUYyaK93uRtWoVCXjSvp0m
         V3pRqziTKVNBDAyEEESoeZoeQ9UxA1rXr4pzrO1eW6aAaGJdmuolNsNpoYZyrIl2o9yi
         0rply4EvbI0tb7n2O66VRlFeH3qHGEBAZO48yxXI3oN4edUkCOrx9AaGfuD1TGB7th6e
         9FKA==
Received: by 10.221.12.9 with SMTP id pg9mr2400532vcb.68.1351362809781;
        Sat, 27 Oct 2012 11:33:29 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-84-124-0-1000.cit.cornell.edu. [128.84.127.232])
        by mx.google.com with ESMTPS id y7sm2851257vdt.1.2012.10.27.11.33.27
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sat, 27 Oct 2012 11:33:28 -0700 (PDT)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Logan Rosen <logatronico@gmail.com>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfsprogs doesn't include the program xfsctl
Message-ID: <20121027183300.8033.65529.reportbug@logan-VirtualBox>
X-Mailer: reportbug 6.4.3ubuntu1
Date: Sat, 27 Oct 2012 14:33:00 -0400
Delivered-To: submit@bugs.debian.org

Package: xfsprogs
Version: 3.1.7build1
Severity: important
User: ubuntu-devel@lists.ubuntu.com
Usertags: origin-ubuntu raring

Dear Maintainer,

This bug report was also filed in Ubuntu and can be found at
http://launchpad.net/bugs/1071800
The description, from Austin S. Hemmelgarn, follows:

Multiple other manpages in the package reference this program, and some of the
functionality of the XFS filesystem is only availible through it.  I believe
that it was included in a previous package version, as it shows up in the list
obtained from `apropos xfs`

ProblemType: Bug
DistroRelease: Ubuntu 12.10
Package: xfsprogs 3.1.7build1
ProcVersionSignature:

Uname: Linux 3.5.7-local x86_64
ApportVersion: 2.6.1-0ubuntu6
Architecture: amd64
Date: Fri Oct 26 11:34:06 2012
InstallationDate: Installed on 2012-06-14 (133 days ago)
InstallationMedia: Xubuntu 12.04 LTS "Precise Pangolin" - Release amd64
(20120425)
MarkForUpload: True
SourcePackage: xfsprogs
UpgradeStatus: Upgraded to quantal on 2012-10-20 (6 days ago)

-- System Information:
Debian Release: wheezy/sid
  APT prefers raring-updates
  APT policy: (500, 'raring-updates'), (500, 'raring-security'), (500,
'raring'), (100, 'raring-backports')
Architecture: amd64 (x86_64)
Foreign Architectures: i386

Kernel: Linux 3.5.0-17-generic (SMP w/1 CPU core)

------------=_1351377184-31289-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 691630-done) by bugs.debian.org; 27 Oct 2012 22:29:33 +0000
X-Spam-Checker-Version: SpamAssassin 3.3.1-bugs.debian.org_2005_01_02
	(2010-03-16) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	HAS_BUG_NUMBER,RCVD_IN_DNSWL_HI,SPF_HELO_PASS,SPF_PASS,WORD_WITHOUT_VOWELS
	autolearn=ham version=3.3.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 16; hammy, 45; neutral, 38; spammy, 0.
	spammytokens: hammytokens:0.000-+--(unknown), 0.000-+--(unknown),
	0.000-+--(unknown), 0.001-+--(unknown), 0.001-+--(unknown)
Return-path: <nscott@redhat.com>
Received: from mx4-phx2.redhat.com ([209.132.183.25])
	by buxtehude.debian.org with esmtp (Exim 4.72)
	(envelope-from <nscott@redhat.com>)
	id 1TSEsm-0007cW-Lb
	for 691630-done@bugs.debian.org; Sat, 27 Oct 2012 22:29:33 +0000
Received: from zmail20.collab.prod.int.phx2.redhat.com (zmail20.collab.prod.int.phx2.redhat.com [10.5.83.23])
	by mx4-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q9RMTUqt015897
	for <691630-done@bugs.debian.org>; Sat, 27 Oct 2012 18:29:30 -0400
Date: Sat, 27 Oct 2012 18:29:30 -0400 (EDT)
From: Nathan Scott <nathans@debian.org>
Reply-To: Nathan Scott <nathans@debian.org>
To: 691630-done@bugs.debian.org
Message-ID: <715033190.18087010.1351376970098.JavaMail.root@redhat.com>
In-Reply-To: <508C5237.4010904@sandeen.net>
Subject: Re: Bug#691630: xfsprogs doesn't include the program xfsctl
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.50.2]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)

Not a bug, no such program ever existed.
------------=_1351377184-31289-0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------------=_1351377184-31289-0--
