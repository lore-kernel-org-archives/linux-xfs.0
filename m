Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47416 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752403AbeCBWI1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Mar 2018 17:08:27 -0500
Subject: Re: [PATCH] xfs: Change URL for the project in xfs.txt
References: <20180302133013.9744-1-standby24x7@gmail.com>
 <20180302172401.GT19312@magnolia> <20180302215731.GT30854@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <27d9f522-fa75-6766-3ca6-79f99522e861@sandeen.net>
Date: Fri, 2 Mar 2018 16:08:24 -0600
MIME-Version: 1.0
In-Reply-To: <20180302215731.GT30854@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Masanari Iida <standby24x7@gmail.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org



On 3/2/18 3:57 PM, Dave Chinner wrote:
> On Fri, Mar 02, 2018 at 09:24:01AM -0800, Darrick J. Wong wrote:
>> On Fri, Mar 02, 2018 at 10:30:13PM +0900, Masanari Iida wrote:
>>> The oss.sgi.com doesn't exist any more.
>>> Change it to current project URL, https://xfs.wiki.kernel.org/
>>>
>>> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
>>> ---
>>>  Documentation/filesystems/xfs.txt | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
>>> index 3b9b5c149f32..4d9ff0a7f8e1 100644
>>> --- a/Documentation/filesystems/xfs.txt
>>> +++ b/Documentation/filesystems/xfs.txt
>>> @@ -9,7 +9,7 @@ variable block sizes, is extent based, and makes extensive use of
>>>  Btrees (directories, extents, free space) to aid both performance
>>>  and scalability.
>>>  
>>> -Refer to the documentation at http://oss.sgi.com/projects/xfs/
>>> +Refer to the documentation at https://xfs.wiki.kernel.org/
> 
> Did I miss a memo?

About which part, the loss of oss.sgi or the addition of the kernel.org wiki?

The kernel.org wiki is pretty bare though.  OTOH xfs.org is a bit less
official.  We really need to resolve this issue.

-Eric

> Cheers,
> 
> Dave.
> 
