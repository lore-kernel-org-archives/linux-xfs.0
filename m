Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Aug 2006 17:25:44 -0700 (PDT)
Received: from rrzmta2.rz.uni-regensburg.de (rrzmta2.rz.uni-regensburg.de [132.199.1.17])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k720PVDW020994
	for <linux-xfs@oss.sgi.com>; Tue, 1 Aug 2006 17:25:34 -0700
Date: Wed, 2 Aug 2006 01:06:48 +0200
From: Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>
Subject: Re: Review: xfs_repair fixes for dir2 corruption
Message-ID: <20060801230648.GA2736@pc51072.physik.uni-regensburg.de>
Reply-To: christian.guggenberger@physik.uni-regensburg.de
References: <20060728091735.B2196410@wobbly.melbourne.sgi.com> <200607280155.LAA12814@larry.melbourne.sgi.com> <87ac6oruqx.fsf@topper.koldfront.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ac6oruqx.fsf@topper.koldfront.dk>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Adam =?iso-8859-1?Q?Sj=F8gren?= <asjo@koldfront.dk>
Cc: linux-xfs@oss.sgi.com

On Tue, Aug 01, 2006 at 11:50:14PM +0200, Adam Sjøgren wrote:
> On Fri, 28 Jul 2006 11:58:52 +1000, Barry wrote:
> 
> > For those that are keen to fix the 16777216 problem, give this patch
> > a go.
> 
> I thought that I'd just report that the patch worked flawlessly when I
> applied it to xfsprogs from cvs and ran the the resulting xfs_repair
> on my bad filesystem (see <87veqhfmo4.fsf@topper.koldfront.dk>,
> <87fyhd1ek7.fsf@topper.koldfront.dk>).
>

I'd like to report a "me too". No problems arised while repairing a
corrupted filesystem on powerpc with the method mentioned above.

thanks.
 - Christian
