Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Jul 2006 19:36:45 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k712aBDW006361
	for <linux-xfs@oss.sgi.com>; Mon, 31 Jul 2006 19:36:21 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with SMTP id k710NGnx029951
	for <linux-xfs@oss.sgi.com>; Mon, 31 Jul 2006 19:23:17 -0500
Message-ID: <44CE9F23.7000605@sgi.com>
Date: Tue, 01 Aug 2006 10:24:03 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 953687 - [SUSE#182691]The current XFS kernel does not pass the
 file mode on remove events
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

pass file mode on DMAPI remove events



Date:  Tue Aug  1 09:32:45 AEST 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  nathans

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:26639a
fs/xfs/xfs_vnodeops.c - 1.682 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.682&r2=text&tr2=1.681&f=h
