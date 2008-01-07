Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jan 2008 20:39:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130] (may be forged))
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m074cnem021042
	for <xfs@oss.sgi.com>; Sun, 6 Jan 2008 20:38:53 -0800
From: donaldd@sgi.com
Subject: PARTIAL TAKE 971186 - dmapi: kill last 2.4 compat leftovers
Message-Id: <20080107043834.9B272323C8EA@linuxbuild.melbourne.sgi.com>
Date: Mon,  7 Jan 2008 15:38:34 +1100 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: sgi.bugs.xfs@engr.sgi.com

dmapi: kill last 2.4 compat leftovers

Signed-off-by: Christoph Hellwig <hch@xxxxxx>

Date:  Mon Jan  7 15:37:20 AEDT 2008
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  linux-melb:dmapi:30299a
fs/dmapi/dmapi_sysent.c - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/dmapi/dmapi_sysent.c.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
	- kill last 2.4 compat leftovers

fs/dmapi/dmapi_register.c - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/dmapi/dmapi_register.c.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
	- kill last 2.4 compat leftovers
