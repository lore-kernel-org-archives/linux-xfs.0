Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 455687F37
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 08:43:13 -0500 (CDT)
Subject: Re: [PATCH V3] xfsdump: prevent segfault in cb_add_inogrp
References: <20150924193241.975348815@gulag1.americas.sgi.com>
	<77EDF3BA.60409@sgi.com> <20150826225601.GG3902@dastard>
	<55DE4492.90105@sgi.com>
From: Rich Johnston <rjohnston@sgi.com>
Message-ID: <5600094B.3090206@sgi.com>
Date: Mon, 21 Sep 2015 08:42:35 -0500
MIME-Version: 1.0
In-Reply-To: <55DE4492.90105@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/26/2015 05:58 PM, Rich Johnston wrote:
> On 08/26/2015 05:56 PM, Dave Chinner wrote:
...
>> Can't believe I missed this first two times time through - the patch
>> is missing your signed-off-by. Just reply with it, and I'll fix it
>> up on commit. :)
> Dooh my bad
>
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>>
>> Thanks, Rich!
>>
>> Cheers,
>>
>> Dave.
>>
>
Hey Dave,

Just curious when this patch are going to be committed?

Thanks
--Rich

These are also ready to go.

[PATCH V4] xfsrestore: fix fs uuid order check for incremental restores
http://oss.sgi.com/archives/xfs/2015-09/msg00185.html

[PATCH V2] xfsrestore: fix 2GB directory dump limitation for multi-stream
http://oss.sgi.com/archives/xfs/2015-09/msg00033.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
