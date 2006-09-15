Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Sep 2006 23:56:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8F6uLZd027652
	for <linux-xfs@oss.sgi.com>; Thu, 14 Sep 2006 23:56:33 -0700
Message-ID: <450A4E87.4030005@sgi.com>
Date: Fri, 15 Sep 2006 16:56:07 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 956240: fixup greedy allocator
References: <44CE9F23.7000605@sgi.com> <44EE9DF7.1080904@sgi.com> <44F66CA0.4080008@sgi.com>
In-Reply-To: <44F66CA0.4080008@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

pv 956240, author: nathans, rv: vapo - Minor fixes in kmem_zalloc_greedy()

Date:  Fri Sep 15 16:53:00 AEST 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-nathan
Inspected by:  vapo
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:26983a
fs/xfs/linux-2.4/kmem.c - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/kmem.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
fs/xfs/linux-2.6/kmem.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
        - pv 956240, author: nathans, rv: vapo - Minor fixes in 
kmem_zalloc_greedy()
