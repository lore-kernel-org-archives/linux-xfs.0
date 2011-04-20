Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3KBNX0R091551 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 06:23:33 -0500
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 803B93FAFA6
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 04:27:00 -0700 (PDT)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	Cf4cPUfvmPZew5nm for <xfs@oss.sgi.com>;
	Wed, 20 Apr 2011 04:27:00 -0700 (PDT)
Received: by vxb39 with SMTP id 39so601046vxb.26
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 04:26:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikBSadR7K2RfiS2k60nEOPncaDfyw@mail.gmail.com>
References: <BANLkTikBSadR7K2RfiS2k60nEOPncaDfyw@mail.gmail.com>
Date: Wed, 20 Apr 2011 16:56:59 +0530
Message-ID: <BANLkTi=2yrp5poJzeHD+u=2zY0nRgxX21g@mail.gmail.com>
Subject: Re: [patch] xfsprogs: fixes a regression hang in xfs_repair phase 4
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>

I guess the patch is not reviewed because of patch subject, but the
problem is related to btree code.
Can anyone please take out time to understand the problem

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
