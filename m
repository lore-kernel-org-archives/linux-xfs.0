Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9EETc4Y004823 for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 09:29:38 -0500
Subject: [ANNOUNCE] xfsdump v3.0.6
From: Alex Elder <aelder@sgi.com>
Date: Fri, 14 Oct 2011 09:29:32 -0500
Message-ID: <1318602572.3827.17.camel@doink>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Version 3.0.6 of xfsdump has been released.

The source code can be accessed via git using this URL:

    git://oss.sgi.com/xfs/cmds/xfsdump.git

A gzipped-tar archive of the source code is available here:

    ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.0.6.tar.gz

The development tree for this code (not available at
the moment) is normally published here as well:

    git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

Below is a summary (from the doc/CHANGES file) of changes
since release 3.0.5:

xfsdump-3.0.6 (14 October 2011)
	- Unconditionally add checksums to various dump headers in
	  xfsdump.
	- Verify dump header checksums if present in xfsrestore.
	- Convert to using the POSIX signal API.
	- Remove restriction of 8 options in dialogs.
	- Various refactoring and internal cleanups to xfsdump and
	  xfsrestore.
	- Build system fixes, thanks to Ted Ts'o.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
