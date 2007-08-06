Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 05 Aug 2007 23:31:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l766VQbm008584
	for <linux-xfs@oss.sgi.com>; Sun, 5 Aug 2007 23:31:28 -0700
Message-ID: <46B6C0B9.2050503@sgi.com>
Date: Mon, 06 Aug 2007 16:33:29 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 968690 - remove unessecary vfs argument to DM_EVENT_ENABLED
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Date:  Mon Aug  6 16:27:33 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-patch-reviews
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29340a
fs/xfs/xfs_vnodeops.c - 1.705 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.705&r2=text&tr2=1.704&f=h
        - pv 968690, author Christoph Hellwig <hch@lst.de>, rv vapo - 
remove unessecary vfs argument to DM_EVENT_ENABLED

fs/xfs/xfs_dmapi.h - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dmapi.h.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
        - pv 968690, author Christoph Hellwig <hch@lst.de>, rv vapo - 
remove unessecary vfs argument to DM_EVENT_ENABLED

fs/xfs/xfs_bmap.c - 1.376 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.376&r2=text&tr2=1.375&f=h
        - pv 968690, author Christoph Hellwig <hch@lst.de>, rv vapo - 
remove unessecary vfs argument to DM_EVENT_ENABLED

fs/xfs/xfs_rename.c - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
        - pv 968690, author Christoph Hellwig <hch@lst.de>, rv vapo - 
remove unessecary vfs argument to DM_EVENT_ENABLED

fs/xfs/linux-2.6/xfs_lrw.c - 1.262 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.262&r2=text&tr2=1.261&f=h
        - pv 968690, author Christoph Hellwig <hch@lst.de>, rv vapo - 
remove unessecary vfs argument to DM_EVENT_ENABLED.

fs/xfs/linux-2.6/xfs_file.c - 1.151 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.151&r2=text&tr2=1.150&f=h
        - pv 968690, author Christoph Hellwig <hch@lst.de>, rv vapo - 
remove unessecary vfs argument to DM_EVENT_ENABLED

fs/xfs/dmapi/xfs_dm.c - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
        - pv 968690, author Christoph Hellwig <hch@lst.de>, rv vapo - 
remove unessecary vfs argument to DM_EVENT_ENABLED
