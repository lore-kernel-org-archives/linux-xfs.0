Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 19:43:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l782hCbm025043
	for <linux-xfs@oss.sgi.com>; Tue, 7 Aug 2007 19:43:15 -0700
Message-ID: <46B92E3B.7060908@sgi.com>
Date: Wed, 08 Aug 2007 12:45:15 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 968773 - minor fixes for XFS DMAPI tests
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Date:  Wed Aug  8 12:41:15 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/xfs-cmds-patches
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29348a
xfstests/dmapi/src/suite2/src/dm_test_daemon.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/suite2/src/dm_test_daemon.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfstests/dmapi/src/suite1/cmd/print_event.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/suite1/print_event.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfstests/dmapi/src/simple/dm_getall_tokens.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/simple/dm_getall_tokens.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfstests/dmapi/src/common/lib/util.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/common/lib/util.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
    - pv 968773, author Chris Pascoe <c.pascoe@itee.uq.edu.au>, rv vapo 
- minor fixes for XFS DMAPI tests
