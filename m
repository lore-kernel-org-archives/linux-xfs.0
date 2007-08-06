Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 05 Aug 2007 23:43:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l766h4bm012069
	for <linux-xfs@oss.sgi.com>; Sun, 5 Aug 2007 23:43:07 -0700
Message-ID: <46B6C374.8000808@sgi.com>
Date: Mon, 06 Aug 2007 16:45:08 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 968691 - dmapi: simplify slab cache creation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Date:  Mon Aug  6 16:40:14 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-patch-reviews
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  linux-melb:dmapi:29343a
fs/dmapi/dmapi_mountinfo.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/dmapi/dmapi_mountinfo.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
        - pv 968691, author Christoph Hellwig <hch@lst.de>, rv vapo - 
dmapi: simplify slab cache creation

fs/dmapi/dmapi_sysent.c - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/dmapi/dmapi_sysent.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
        - pv 968691, author Christoph Hellwig <hch@lst.de>, rv vapo - 
dmapi: simplify slab cache creation
