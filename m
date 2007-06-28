Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 01:00:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5S7xstL015990
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 00:59:56 -0700
Subject: TAKE 961297 - dmapi-devel RPM should Require: xfsprogs-devel
Message-Id: <20070628075951.8BE6358C38F1@chook.melbourne.sgi.com>
Date: Thu, 28 Jun 2007 17:59:51 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Update dmapi specfile for dmapi-devel requiring xfsprogs-devel


Date:  Thu Jun 28 17:59:03 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29012a
dmapi/build/rpm/dmapi.spec.in - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/dmapi/build/rpm/dmapi.spec.in.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- dmapi-devel RPM should Require: xfsprogs-devel
