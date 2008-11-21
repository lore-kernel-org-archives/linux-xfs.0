Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP
	id mAL1S6Xl012150
	for <xfs@oss.sgi.com>; Thu, 20 Nov 2008 19:28:07 -0600
Subject: TAKE 990014 - xfs-cmds: Add parallel build support
Message-Id: <20081121012758.5901D59391F4@chook.melbourne.sgi.com>
Date: Fri, 21 Nov 2008 12:27:58 +1100 (EST)
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

Allow parallel builds of the xfstests package




Date:  Fri Nov 21 12:27:36 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  "Eric Sandeen" <sandeen@sandeen.net>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32515a
xfstests/Makefile - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/Makefile.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfstests/include/buildrules - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/include/buildrules.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfstests/include/buildmacros - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/include/buildmacros.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- Allow parallel builds of the xfstests package


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
