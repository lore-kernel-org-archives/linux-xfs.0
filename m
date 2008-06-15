Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jun 2008 18:52:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5F1qDbQ004043
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 18:52:13 -0700
Message-ID: <48547604.9060700@sandeen.net>
Date: Sat, 14 Jun 2008 20:53:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS errors / BUG / panic, with 2.6.25.7-queue (and older 2.6.25.y)
References: <6101e8c40806141241h4a23f7a6ka5366c84130f1291@mail.gmail.com>
In-Reply-To: <6101e8c40806141241h4a23f7a6ka5366c84130f1291@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Christoph Hellwig <hch@infradead.org>, stable@kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Miquel van Smoorenburg <mikevs@xs4all.net>, Konstantin Kletschke <lists@ku-gbr.de>

Oliver Pinter wrote:
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00775.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00776.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00777.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00778.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00779.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00780.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00781.jpg
> 
> tainted with: nvidia and madwifi
> kernel: 2.6.25.6 + queue patches (queue head on
> aa8edcb997ff605bd1424630356866b78ef06cdc)
> 

What sort of remount were you doing?

-Eric
