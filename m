Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB95PFuo028603 for <xfs@oss.sgi.com>; Mon, 8 Dec 2008 23:25:16 -0600
Subject: PARITAL TAKE 988581 - atime testing xfstests/192
Message-Id: <20081209052505.9FC4C1C033D@chapter11.melbourne.sgi.com>
Date: Tue,  9 Dec 2008 16:25:05 +1100 (EST)
From: tes@sgi.com (Timothy Shimmin)
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
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Test out that access time is updated correctly in memory and on disk.

Date:  Tue Dec  9 16:12:48 EST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  Dave Chinner (with unused recommendations:)
Author:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32647a
xfstests/192 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/192
	- Test out that access time is updated correctly in memory and on disk.

xfstests/192.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/192.out
	- atime output for 192

xfstests/group - 1.129 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.129&r2=text&tr2=1.128&f=h
	- add 192 and atime group

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
