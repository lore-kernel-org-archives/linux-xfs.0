Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Feb 2007 15:42:42 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1JNgYm7024609
	for <xfs@oss.sgi.com>; Mon, 19 Feb 2007 15:42:37 -0800
Subject: TAKE 961289 - Clean up old LBS cruft in xfs-cmds root makefile
Message-Id: <20070219234229.B9BA258CA547@chook.melbourne.sgi.com>
Date: Tue, 20 Feb 2007 10:42:29 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove old SGI build stuff from root makefile.


Date:  Tue Feb 20 10:41:45 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28135a
GNUmakefile - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/GNUmakefile.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Remove old SGI build stuff and set final RPM location from the environment.
