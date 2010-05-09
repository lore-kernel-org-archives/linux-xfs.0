Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49J55R0233142 for <xfs@oss.sgi.com>; Sun, 9 May 2010 14:05:05 -0500
Received: from mx02.kabsi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAAB213957BB
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 12:07:16 -0700 (PDT)
Received: from mx02.kabsi.at (mx02.kabsi.at [62.40.128.130]) by cuda.sgi.com
	with ESMTP id B3upRdCDNJR3fPnx for <xfs@oss.sgi.com>;
	Sun, 09 May 2010 12:07:16 -0700 (PDT)
Received: from 192.168.5.201 (h081217058120.dyn.cm.kabsi.at [81.217.58.120])
	by mx02.kabsi.at (8.13.6/8.13.6) with ESMTP id o49J798r025155
	for <xfs@oss.sgi.com>; Sun, 9 May 2010 21:07:10 +0200
Date: Sun, 9 May 2010 21:07:10 +0200
From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Message-ID: <462402327.20100509210710@kaneda.iguw.tuwien.ac.at>
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
In-Reply-To: <1816344475.20100509204800@kaneda.iguw.tuwien.ac.at>
References: <1816344475.20100509204800@kaneda.iguw.tuwien.ac.at>
MIME-Version: 1.0
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

addendum - xfsprogs is of version:

xfsprogs-2.9.4-1.el5.centos


RF> today in the morning some daemon processes terminated because of
RF> errors in the xfs file system on top of a software raid5, consisting
RF> of 4*1.5TB WD caviar green SATA disks.

[...]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
