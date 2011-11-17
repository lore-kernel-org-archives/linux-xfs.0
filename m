Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAHNVNBt076877 for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 17:31:23 -0600
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4485D8F8039
	for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 15:31:20 -0800 (PST)
Date: Thu, 17 Nov 2011 17:31:39 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [ANNOUNCE] xfsprogs v3.1.7
Message-ID: <20111117233139.GL29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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

Version 3.1.7 of xfsprogs has been released.

The source code can be accessed via git using this URL:

    git://oss.sgi.com/xfs/cmds/xfsprogs.git

A gzipped-tar archive of the source code is available here:

    ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.1.7.tar.gz

The development tree for this code (not available at
the moment) is normally published here as well:

    git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

Below is a summary (from the doc/CHANGES file) of changes
since release 3.1.6:

xfsprogs-3.1.7 (16 November 2011)
	- Pull in fix for debian/control
	- Polish translation update, thanks to Jakub Bogusz
	- Fix xfs_repair link count on lost+found, thanks to Carlos Maiolino
	- Fix various incorrect printf formats

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
