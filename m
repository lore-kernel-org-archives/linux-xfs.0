Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Apr 2007 21:00:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3G40DfB007691
	for <xfs@oss.sgi.com>; Sun, 15 Apr 2007 21:00:15 -0700
Subject: TAKE 963465 - export xfs_buftarg_list for xfsidbg (using func)
Message-Id: <20070416040007.0A0415903EDB@chook.melbourne.sgi.com>
Date: Mon, 16 Apr 2007 14:00:06 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Export via a function xfs_buftarg_list for use by kdb/xfsidbg.


Date:  Mon Apr 16 13:58:41 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28414a
fs/xfs/xfsidbg.c - 1.313 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.313&r2=text&tr2=1.312&f=h
	- Export via a function xfs_buftarg_list for use by kdb/xfsidbg.

fs/xfs/linux-2.6/xfs_buf.h - 1.119 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.119&r2=text&tr2=1.118&f=h
	- Export via a function xfs_buftarg_list for use by kdb/xfsidbg.

fs/xfs/linux-2.6/xfs_buf.c - 1.235 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.235&r2=text&tr2=1.234&f=h
	- Export via a function xfs_buftarg_list for use by kdb/xfsidbg.

fs/xfs/linux-2.4/xfs_buf.h - 1.118 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_buf.h.diff?r1=text&tr1=1.118&r2=text&tr2=1.117&f=h
	- Export via a function xfs_buftarg_list for use by kdb/xfsidbg.

fs/xfs/linux-2.4/xfs_buf.c - 1.219 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_buf.c.diff?r1=text&tr1=1.219&r2=text&tr2=1.218&f=h
	- Export via a function xfs_buftarg_list for use by kdb/xfsidbg.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.57 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.57&r2=text&tr2=1.56&f=h
	- Export via a function xfs_buftarg_list for use by kdb/xfsidbg.

fs/xfs/linux-2.4/xfs_ksyms.c - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_ksyms.c.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
	- Export via a function xfs_buftarg_list for use by kdb/xfsidbg.
