Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 23:09:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m41699Ui000836
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 23:09:12 -0700
Subject: TAKE update xfstests/dmapi....Makefile.in
Message-Id: <20080501060949.2664358C4C15@chook.melbourne.sgi.com>
Date: Thu,  1 May 2008 16:09:49 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

regenerate dmapi Makefile in using automake

Date:  Thu May  1 16:07:18 AEST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31014a
xfstests/dmapi/aclocal.m4 - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/aclocal.m4.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- regenerate using aclocal

xfstests/dmapi/src/suite1/cmd/Makefile.in - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/suite1/Makefile.in.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- regenerate using automake
