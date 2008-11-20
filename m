Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP
	id mAK70NWf031567
	for <xfs@oss.sgi.com>; Thu, 20 Nov 2008 01:00:23 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by netops-testserver-3.corp.sgi.com (Postfix) with SMTP id C833D90887
	for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 23:00:19 -0800 (PST)
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com
	[134.14.54.237]) by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA26546 for
	<xfs@oss.sgi.com>; Thu, 20 Nov 2008 18:00:18 +1100
Subject: TAKE - xfstests: fix nr of args in open calls
Message-Id: <20081120070017.ECA1C58AE1E9@chook.melbourne.sgi.com>
Date: Thu, 20 Nov 2008 18:00:17 +1100 (EST)
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
To: xfs@oss.sgi.com

xfstests: fix nr of args in open calls


Date:  Thu Nov 20 17:59:50 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  "Eric Sandeen" <sandeen@sandeen.net>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32509a
xfstests/ltp/iogen.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/ltp/iogen.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfstests/src/enospc_unlink.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/enospc_unlink.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfstests/src/multi_open_unlink.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/multi_open_unlink.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfstests/src/dmiperf.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/dmiperf.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- fix nr of args in open calls


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
