Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 653147CA2
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 16:20:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 18C92304062
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 14:20:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	C6b4rfp9m975RDPb for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2016 14:20:47 -0700 (PDT)
Date: Wed, 14 Sep 2016 07:20:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [INFO] xfs: kernel debugging with trace_printk()
Message-ID: <20160913212011.GI30497@dastard>
References: <20160906082045.GJ30056@dastard>
	<e5b07fd7-3c4e-e183-008b-877b0c237b72@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e5b07fd7-3c4e-e183-008b-877b0c237b72@gentoo.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Joshua Kinard <kumba@gentoo.org>
Cc: xfs@oss.sgi.com

On Tue, Sep 13, 2016 at 11:02:01AM -0400, Joshua Kinard wrote:
> On 09/06/2016 04:20, Dave Chinner wrote:
> [snip]
> 
> But this assumes one can even get to a working shell prompt from which one can
> run commands, like 'trace-cmd'.

Well, yes. This is, after all, a filesystem development discussion
list, not a "I've got b0rken old hardware that won't boot" support
list, so the assumption that there is a working shell available for
debugging is a pretty good one to make...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
