Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5DEDTJ6244900 for <xfs@oss.sgi.com>; Mon, 13 Jun 2011 09:13:30 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4657914EE0F9
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2011 07:13:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	baQyzXkKd4Fv32LR for <xfs@oss.sgi.com>;
	Mon, 13 Jun 2011 07:13:27 -0700 (PDT)
Date: Tue, 14 Jun 2011 00:13:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstest run result on 2.6.35.13 X86, 51 test cases failed
Message-ID: <20110613141324.GC32466@dastard>
References: <BANLkTinCvmt+=ZO9HwUWda1vkmLEqOfSwg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTinCvmt+=ZO9HwUWda1vkmLEqOfSwg@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 13, 2011 at 02:16:02PM +0530, Ajeet Yadav wrote:
> Dear All.
> I have installed the 2.6.35.13 long term valilla kernel release
> (www.kenrel.org) on my Intel core 2 duo PC, and run 11-05-2011 xfstest
> version, and run on it, below is the list of fails test cases.
> As far as I know community uses xfstest for QA, seeing so many fails,
> I am bit worried.

It shouldn't fail very many tests at all...

> Can anyone hepl me know that why so many fails, is I missed some
> config option ? or these test cases are not applicable ? or there is
> someting else

Well, without telling us why the tests are failing (i.e. copy all
the output rather than just telling us some tests failed) we have no
idea what the failures you are seeing are. Without some indication
of what they failures are nobody can really comment on your
situation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
