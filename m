Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1421D7F4C
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 07:44:15 -0500 (CDT)
Message-ID: <516BF5A7.4050100@sgi.com>
Date: Mon, 15 Apr 2013 07:42:15 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: make install support common/ and tests/ dirs
References: <51678D0D.1070002@gmail.com> <20130412074034.GC30622@dastard>
	<5168396C.6020801@gmail.com> <51685552.6030808@sgi.com>
	<20130413003829.GH30622@dastard>
In-Reply-To: <20130413003829.GH30622@dastard>
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
Cc: xfstests <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>, Wang Sheng-Hui <shhuiw@gmail.com>

On 04/12/2013 07:38 PM, Dave Chinner wrote:
> On Fri, Apr 12, 2013 at 01:41:22PM -0500, Rich Johnston wrote:
>> On 04/12/2013 11:42 AM, Wang Sheng-Hui wrote:
>>>
>>> Hi Dave,
>>>
>>> I introduces Makefile under tests/, which would return to TESTS_SUBDIRS
>>> with the
>>> $(dir function. By running find in $(shell, TEST_SUBDIRS will only get
>>> the dir names,
>>> and no Makefile.
>>>
>>> Regards,
>>> Sheng-Hui
>>
>> Thanks addressing comments and for v2 of this patch.
>>
>> I still had issues with Makefile which I corrected at commit time.
>>
>> Thanks again for the patch, it has been committed,
>
> Rich, it's great that you are picking this stuff up quickly, but as
> I asked recently, please don't commit patches while there is still
> an active review conversation going on....
>
> Cheers,
>
> Dave.
>
Dave,
I was a little quick on the draw, I will wait till all parties have 
concluded discussions.

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
