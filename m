Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9M2k1Cq116593 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 21:46:01 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3E4511A449
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 19:47:15 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Rz9xCRrGqSvHD2gz
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 19:47:15 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id ED09B6C102
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 21:47:14 -0500 (CDT)
Message-ID: <4CC0FB32.1040107@hardwarefreak.com>
Date: Thu, 21 Oct 2010 21:47:14 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Best filesystems ?
References: <4CBE2403.8070108@hardwarefreak.com>	<20101019234217.GD12506@dastard>	<19646.55189.843933.481529@tree.ty.sabi.co.uk>	<20101021020009.GG12506@dastard>	<19648.27859.799400.168394@tree.ty.sabi.co.uk>
	<Pine.LNX.4.64.1010211258070.24449@andrew.triumf.ca>
In-Reply-To: <Pine.LNX.4.64.1010211258070.24449@andrew.triumf.ca>
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

Andrew Daviel put forth on 10/21/2010 3:06 PM:

> Has someone documented (recently, and correctly) what filesystems (XFS,
> ext3, ext4, reiser, JFS, VFAT etc.) are best for what tasks (mailboxes,
> database, general computing, video streaming etc.) ?

http://btrfs.boxacle.net/repository/raid/2.6.35-rc5/2.6.35-rc5/

That's the most recent set of tests I'm aware of.  The testing was
performed against an IBM DS4500 with 136 drives in a multilevel combo
hardware/software stripe setup.  Complete hardware description and test
details are here:

http://btrfs.boxacle.net/


-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
