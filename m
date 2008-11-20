Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAK4AOpW011326 for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 22:10:24 -0600
Subject: TAKE 989945 - mkfs.xfs: -d agcount doesn't work with su/sw options
Message-Id: <20081120041015.176B258AE1E9@chook.melbourne.sgi.com>
Date: Thu, 20 Nov 2008 15:10:15 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix mkfs.xfs to allow agcount to be used with su/sw options


Date:  Thu Nov 20 15:08:27 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  peter@cordes.ca

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32501a
xfsprogs/mkfs/xfs_mkfs.c - 1.95 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.95&r2=text&tr2=1.94&f=h
	- Fix mkfs.xfs to allow -d agcount to be use with su/sw options


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
