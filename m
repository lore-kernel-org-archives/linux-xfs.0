Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5LA6skK034328 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 05:06:54 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id jWPtFDgDSWfGZ5ky
	for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 03:06:53 -0700 (PDT)
Message-ID: <4FE2F23D.90303@hardwarefreak.com>
Date: Thu, 21 Jun 2012 05:06:53 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: [regression] stack overflow in xfs_buf_iodone_callbacks
References: <20120621091803.GB10673@dastard>
	<20120621092104.GA3621@infradead.org>
In-Reply-To: <20120621092104.GA3621@infradead.org>
Reply-To: stan@hardwarefreak.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 6/21/2012 4:21 AM, Christoph Hellwig wrote:
> On Thu, Jun 21, 2012 at 07:18:03PM +1000, Dave Chinner wrote:
>> I don't have time to come up with a fix for this right now, but it
>> needs to be fixed before 3.5 releases. I don't have time because I'm
>> going to be AFK next week, so I'd appreciate it if someone could
>> look at fixing this in the mean time?
> 
> I'll handle it.

Reading this exchange, seeing the teamwork, is really cool, and struck a
chord with me for some reason.  Especially considering that "I'll handle
it" is probably a many hour (or day) commitment, made with 3 simple
words, at the drop of a hat.

Being part of a list where both deep technical development and 'simple'
end user issues are both handled, in a team fashion, is even cooler.

We probably don't say it enough, so I'll do so now.

Thank you guys, all the XFS developers, for the work you do that
benefits us all.  And thanks to all my fellow XFS users, for helping
make this list what I think is a great community, and an example for
other lists to follow.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
