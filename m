Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35IMt1M009990 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 13:22:55 -0500
Received: from mail.netcenter.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6639729C1DA
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 11:24:42 -0700 (PDT)
Received: from mail.netcenter.hu (ns.netcenter.hu [195.228.254.57]) by
	cuda.sgi.com with ESMTP id QiqnmsDV9cfLaMPI for
	<xfs@oss.sgi.com>; Mon, 05 Apr 2010 11:24:42 -0700 (PDT)
Message-ID: <2bd101cad4ec$5a425f30$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
References: <03ca01cacb92$195adf50$0400a8c0@dcccs>
	<2375c9f91003242029p1efbbea1v8e313e460b118f14@mail.gmail.com>
	<20100325153110.6be9a3df.kamezawa.hiroyu@jp.fujitsu.com>
	<02c101cacbf8$d21d1650$0400a8c0@dcccs>
	<179901cad182$5f87f620$0400a8c0@dcccs>
	<t2h2375c9f91004010337p618c4d5yc739fa25b5f842fa@mail.gmail.com>
	<1fe901cad2b0$d39d0300$0400a8c0@dcccs>
	<20100402230905.GW3335@dastard>
	<22c901cad333$7a67db60$0400a8c0@dcccs>
	<20100404103701.GX3335@dastard>
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
	please!...)
Date: Mon, 5 Apr 2010 20:17:27 +0200
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
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, xiyou.wangcong@gmail.com, kamezawa.hiroyu@jp.fujitsu.com

Dave,

Thank you for your answer.
Like i sad before, this is a productive server with important service.
Can you please send the fix for me as soon as it is done even for testing 
it....
Or point me to the right direction to get it?

Thanks a lot,
Janos Haar

----- Original Message ----- 
From: "Dave Chinner" <david@fromorbit.com>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <xiyou.wangcong@gmail.com>; <linux-kernel@vger.kernel.org>; 
<kamezawa.hiroyu@jp.fujitsu.com>; <linux-mm@kvack.org>; <xfs@oss.sgi.com>; 
<axboe@kernel.dk>
Sent: Sunday, April 04, 2010 12:37 PM
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look 
please!...)


> On Sat, Apr 03, 2010 at 03:42:10PM +0200, Janos Haar wrote:
>> Hello,
>>
>> The actual version of kernel is 2.6.32.10.
>> There is any significant fixes for me in the last (.11) or in the
>> next (33.x)?
>
> The fixes for this bug are queued up already for the next
> 2.6.32.x release.
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
