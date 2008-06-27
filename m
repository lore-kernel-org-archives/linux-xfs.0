Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 21:30:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R4UKWa006024
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 21:30:22 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09CC6D63C8D
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 21:31:20 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id ztvOWRE2zc55C5wL for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 21:31:20 -0700 (PDT)
Date: Fri, 27 Jun 2008 14:31:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS] kernel panic on halt (2.6.26-rc7)
Message-ID: <20080627043113.GZ29319@disturbed>
References: <6101e8c40806260532j3bed1c7k9a60c41ea297549f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40806260532j3bed1c7k9a60c41ea297549f@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Matthew Wilcox <matthew@wil.cx>

On Thu, Jun 26, 2008 at 02:32:19PM +0200, Oliver Pinter wrote:
> Hi Christoph, Dave,
> 
> a similar problem came out the with 2.6.26, than the was in post early
> with 2.6.25[1][2]
> 
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00807.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00808.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00809.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00810.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00811.jpg

http://lkml.org/lkml/2008/3/7/356

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
