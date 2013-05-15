Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D5B1C7F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 10:22:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B54BF304067
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 08:22:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CS5eSi5PymrpZElZ for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 08:22:10 -0700 (PDT)
Message-ID: <5193A823.1000303@sandeen.net>
Date: Wed, 15 May 2013 10:22:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v5] xfstests: add a new test case for ext4 indirect-based
	file
References: <1368463235-14478-1-git-send-email-wenqing.lz@taobao.com>
	<519394D8.2050005@sgi.com> <20130515153146.GA17148@gmail.com>
In-Reply-To: <20130515153146.GA17148@gmail.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com

On 5/15/13 10:31 AM, Zheng Liu wrote:
> On Wed, May 15, 2013 at 08:59:52AM -0500, Rich Johnston wrote:
> [...]
>> Hey Zheng,
>>
>> Thanks for submitting this patch. Looks like this patch does not
>> apply cleanly.
> 
> Hi Rich,
> 
> Yes, this patch bases against Eric's patch:
>   [PATCH] xfstests: automatically add -F to xfs_io on non-xfs
> 
> But his patch hasn't been applied.  So that is why this patch doesn't
> apply cleanly.  Do I need to resend a cleanly version?

My patch is now applied...

The joys of distributed development ;)

-Eric

> Thanks,
>                                                 - Zheng
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
