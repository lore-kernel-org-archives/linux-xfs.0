Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o47JopUm172499 for <xfs@oss.sgi.com>; Fri, 7 May 2010 14:50:52 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 35FAA8F80AD
	for <xfs@oss.sgi.com>; Fri,  7 May 2010 12:53:00 -0700 (PDT)
Subject: [ANNOUNCE] xfsprogs v3.1.2
From: Alex Elder <aelder@sgi.com>
Date: Fri, 07 May 2010 14:52:14 -0500
Message-ID: <1273261934.2971.30.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS Mailing List <xfs@oss.sgi.com>

Version 3.1.2 of xfsprogs has been released.

A gzipped-tar archive of the source code is available here:

    ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.1.2.tar.gz

The source code can be accessed via git using this URL:

    git://oss.sgi.com/xfs/cmds/xfsprogs.git

Below is a summary (from the doc/CHANGES file) of changes
since release 3.1.1:

xfsprogs-3.1.2 (6 May 2010)
	- Fix missing thread synchronization in xfs_repair duplicate
	  extent tracking.
	- Fix handling of dynamic attribute fork roots in xfs_fsr.
	- Fix sb_bad_features2 manipulations when tweaking the lazy
          count flag.
	- Add support for building on Debian GNU/kFreeBSD, thanks
	  to Petr Salinger.
	- Improvements to the mkfs.xfs manpage, thanks to Wengang Wang.
	- Various small blkid integration fixes in mkfs.xfs.
	- Fix build against stricter system headers.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
