Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 01:21:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8Q8LQgv030237
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 01:21:29 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 971050 - Remove linux-2.4 build support
Message-Id: <20070926082120.86D772FB966D@linuxbuild.melbourne.sgi.com>
Date: Wed, 26 Sep 2007 18:21:20 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove linux-2.4 Makefile wrappers from fs/xfs/quota, fs/xfs/dmapi and fs/dmapi.

Date:  Wed Sep 26 18:20:13 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  tes,vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29784a
fs/xfs/quota/Makefile - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/Makefile.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- Remove linux-2.4 Makefile wrappers fs/xfs/quota, fs/xfs/dmapi and fs/dmapi.

fs/xfs/dmapi/Makefile - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/Makefile.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
	- Remove linux-2.4 Makefile wrappers fs/xfs/quota, fs/xfs/dmapi and fs/dmapi.

fs/xfs/dmapi/Makefile-linux-2.4 - 1.6 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/Makefile-linux-2.4.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- Remove linux-2.4 Makefile wrappers fs/xfs/quota, fs/xfs/dmapi and fs/dmapi.

fs/xfs/quota/Makefile-linux-2.4 - 1.7 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/Makefile-linux-2.4.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- Remove linux-2.4 Makefile wrappers fs/xfs/quota, fs/xfs/dmapi and fs/dmapi.

fs/xfs/quota/Makefile-linux-2.6 - 1.6 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/Makefile-linux-2.6.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- Remove linux-2.4 Makefile wrappers fs/xfs/quota, fs/xfs/dmapi and fs/dmapi.

fs/xfs/dmapi/Makefile-linux-2.6 - 1.7 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/Makefile-linux-2.6.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- Remove linux-2.4 Makefile wrappers fs/xfs/quota, fs/xfs/dmapi and fs/dmapi.




Modid:  linux-melb:dmapi:29784b
fs/dmapi/Makefile-linux-2.4 - 1.4 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/fs/dmapi/Makefile-linux-2.4.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Remove linux-2.4 Makefile wrappers fs/xfs/quota, fs/xfs/dmapi and fs/dmapi.

fs/dmapi/Makefile-linux-2.6 - 1.4 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/fs/dmapi/Makefile-linux-2.6.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Remove linux-2.4 Makefile wrappers fs/xfs/quota, fs/xfs/dmapi and fs/dmapi.

fs/dmapi/Makefile - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/fs/dmapi/Makefile.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
	- Remove linux-2.4 Makefile wrappers fs/xfs/quota, fs/xfs/dmapi and fs/dmapi.
