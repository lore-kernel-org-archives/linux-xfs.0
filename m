Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 18:49:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l781nWbm013414
	for <linux-xfs@oss.sgi.com>; Tue, 7 Aug 2007 18:49:34 -0700
Message-ID: <46B921A8.1080102@sgi.com>
Date: Wed, 08 Aug 2007 11:51:36 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: PARTIAL TAKE 966845 - XFSQA 168: test fails on i386 TOT 26x_xfs due
 to garbaged output
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Date:  Wed Aug  8 11:38:19 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/xfs-cmds
Inspected by:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29347a
xfstests/dmapi/src/suite1/cmd/print_event.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/suite1/print_event.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
        - pv 966845, rv lachlan - terminate attribute name string
