Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAK43USt010955 for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 22:03:30 -0600
Subject: TAKE 989944 - mkfs.xfs ignores -i maxpct option
Message-Id: <20081120040321.E731658AE1E9@chook.melbourne.sgi.com>
Date: Thu, 20 Nov 2008 15:03:21 +1100 (EST)
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

Make sure mkfs.xfs doesn't ignore -i maxpct option


Date:  Thu Nov 20 15:02:45 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  peter@cordes.ca

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32500a
xfsprogs/mkfs/xfs_mkfs.c - 1.94 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.94&r2=text&tr2=1.93&f=h
	- Fix mkfs.xfs so it doesn't ignore the -i maxpct option


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
