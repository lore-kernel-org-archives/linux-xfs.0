Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBA5Gxsc014051 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 23:16:59 -0600
Subject: PARTIAL TAKE 990768 - setattr perm check test - 193
Message-Id: <20081210051652.CB97F58AE1F6@chook.melbourne.sgi.com>
Date: Wed, 10 Dec 2008 16:16:52 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
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

Test out the perm checks in xfs_setattr - chmod, chown, etc..

--Tim

Date:  Wed Dec 10 16:12:22 EST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  hch@lst.de (authored by)

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32713a
xfstests/193 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/193
xfstests/193.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/193.out
	- Test out the perm checks in xfs_setattr - chmod, chown, etc..

xfstests/group - 1.130 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.130&r2=text&tr2=1.129&f=h
	- Add 193 for setattr permission testing.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
