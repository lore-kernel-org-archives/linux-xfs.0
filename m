Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IEommE117877 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 09:50:49 -0500
Received: from out75.rilinfo.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C63DD4E1663
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 07:51:17 -0700 (PDT)
Received: from out75.rilinfo.net (out75.rilinfo.net [202.138.96.75]) by
	cuda.sgi.com with ESMTP id y6Pl6nzRXfDRxz5b for
	<xfs@oss.sgi.com>; Wed, 18 Aug 2010 07:51:17 -0700 (PDT)
Date: Wed, 18 Aug 2010 20:21:31 +0530 (IST)
From: Nohez <nohez@cmie.com>
Subject: Re: kernel bug in xfs_lrw.c (centos v5.5, directio, aio)
In-Reply-To: <20100818114305.GR10429@dastard>
Message-ID: <alpine.LNX.2.00.1008181715380.12207@sangam.cmie.ernet.in>
References: <alpine.LNX.2.00.1008171906220.21398@mahi.cmie.ernet.in>
	<20100818114305.GR10429@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


Thank you for your reply.

I checked the archives and found a bug report. The function names in
the call trace report are different from the ones I have reported.

Since it's an application bug, it does not matter which filesystem
is being used. Can I assume that the data corruption can happen on
ext3 too?

Nohez

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
