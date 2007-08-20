Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 22:42:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7K5glbm009021
	for <linux-xfs@oss.sgi.com>; Sun, 19 Aug 2007 22:42:48 -0700
Message-ID: <46C92A4D.6010201@sgi.com>
Date: Mon, 20 Aug 2007 15:44:45 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 969372 - [PATCH] optimize dmapi event tests w/o dmapi config
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

optimize dmapi event tests w/o dmapi config
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Mon Aug 20 15:39:31 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-patch-reviews
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29444a
fs/xfs/xfs_dmapi.h - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dmapi.h.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
    - pv 969372, rv vapo - optimize dmapi event tests w/o dmapi config

fs/xfs/xfs_vfsops.c - 1.525 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.525&r2=text&tr2=1.524&f=h
    - pv 969372, rv vapo - optimize dmapi event tests w/o dmapi config
