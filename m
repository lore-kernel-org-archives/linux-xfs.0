Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 18:24:27 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q1OL4p015376
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 18:24:21 -0700
Subject: TAKE 907752 - xfs_stats.pl: xs_log_blocks counts in basic blocks
Message-Id: <20080926012548.7316158C52AE@chook.melbourne.sgi.com>
Date: Fri, 26 Sep 2008 11:25:48 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

xfs_stats.pl: xs_log_blocks counts in basic blocks.
Fix up documentation to match reality as discussed on #xfs .


Date:  Fri Sep 26 11:24:23 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  "KELEMEN Peter" <Peter.Kelemen@cern.ch>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32212a
xfsmisc/xfs_stats.pl - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsmisc/xfs_stats.pl.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	  Fix up xs_log_blocks documentation to match reality
