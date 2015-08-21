Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 37EAD7F9D
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 15:11:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 176F0304032
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 13:11:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3poFfqhxYSxiijbQ for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 13:11:19 -0700 (PDT)
Message-ID: <55D785E7.8050503@sandeen.net>
Date: Fri, 21 Aug 2015 15:11:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfsdump: fix problems in cb_add_inogrp
References: <20150821193047.661578219@gulag1.americas.sgi.com>
	<55D747FE.4070401@sandeen.net> <55D7854A.9030706@sgi.com>
In-Reply-To: <55D7854A.9030706@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com

On 8/21/15 3:08 PM, Rich Johnston wrote:
> On 08/21/2015 10:47 AM, Eric Sandeen wrote:
>> Hi -
>>
>> Are there any testcases for these?  xfsdump is alien code, I swear;
>> I'm not quite sure offhand how to tickle any of these bugs.
>>
>> Thanks,
>> -Eric
>>
> 
> Hey Eric,
> 
> Many thanks for taking the time to review these patches.
> I take a look at all your responses and get a V2 out early next week.

Sounds good.  If I was off track about the need for the extra 64-bit vars,
just educate me.  ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
