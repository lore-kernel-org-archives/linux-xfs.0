Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 21:39:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8P4dhQ3019615
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 21:39:47 -0700
Message-ID: <46F89177.6040303@sgi.com>
Date: Tue, 25 Sep 2007 14:41:27 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 970979: [PATCH] cleanup vnode useage in xfs_dm.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

cleanup vnode useage in xfs_dm.c

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Sep 25 14:36:51 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-patch-reviews
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29769a
fs/xfs/dmapi/xfs_dm.c - 1.56 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.56&r2=text&tr2=1.55&f=h
    - pv 970979, author hch@lst.de, rv vapo - cleanup vnode useage in 
xfs_dm.c
