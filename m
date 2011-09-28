Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SI5n1u123198 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 13:05:49 -0500
Received: from mta31.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B5631C4EDDA
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 11:05:47 -0700 (PDT)
Received: from mta31.charter.net (mta31.charter.net [216.33.127.82]) by
	cuda.sgi.com with ESMTP id 01YVwsFhZIWAEJRJ for
	<xfs@oss.sgi.com>; Wed, 28 Sep 2011 11:05:47 -0700 (PDT)
Received: from imp10 ([10.20.200.15]) by mta31.charter.net
	(InterMail vM.7.09.02.04 201-2219-117-106-20090629) with ESMTP
	id <20110928180547.DCLF3994.mta31.charter.net@imp10>
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 14:05:47 -0400
Received: from [172.17.100.41] (unknown [67.130.187.94])
	by cchtml.com (Postfix) with ESMTPSA id 650E0C0287BED
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 13:05:46 -0500 (CDT)
Message-ID: <4E8361F8.2040706@cchtml.com>
Date: Wed, 28 Sep 2011 13:05:44 -0500
From: Michael Cronenworth <mike@cchtml.com>
MIME-Version: 1.0
Subject: Re: 64-bit inodes and back again
References: <4E825C25.6050804@cchtml.com> <20110928011020.GE3159@dastard>
	<4E8278D8.9060309@cchtml.com> <4E828BE1.8030003@cchtml.com>
	<20110928053539.GF3159@dastard> <4E82C5AF.8040203@cchtml.com>
	<20110928110726.GG3159@dastard> <4E831D81.6070102@cchtml.com>
	<4E835B6F.5040500@hardwarefreak.com>
In-Reply-To: <4E835B6F.5040500@hardwarefreak.com>
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
To: xfs@oss.sgi.com

Stan Hoeppner wrote:
> When you removed the inode64 mount option in fstab, did you change any
> other mount options on this filesystem?

No. I do have quotas enabled, but they have been enabled all during this 
time from switching 64-bit inodes on and off.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
