Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EC9E801B
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 08:38:33 -0500 (CDT)
Message-ID: <51432470.2000800@sgi.com>
Date: Fri, 15 Mar 2013 08:38:56 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfstests patches
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
	<514205DC.9040902@sgi.com> <20130315054350.GC2559@dastard>
In-Reply-To: <20130315054350.GC2559@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 03/15/2013 12:43 AM, Dave Chinner wrote:
> On Thu, Mar 14, 2013 at 12:16:12PM -0500, Rich Johnston wrote:
>> On 03/13/2013 09:57 AM, Eric Sandeen wrote:
>>> 2 pretty simple ones, and a new btrfs test
>>>
>>> [PATCH 1/3] xfstests: add 274 to the prealloc group
>>> [PATCH 2/3] xfstests: keep newlines out of SCRATCH_DEV_POOL
>>> [PATCH 3/3] xfstests: btrfs tests for basic informational commands
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>
>>
>> This series has been committed.
>
> Rich, can you please be careful to check the test numbers being used
> in patches that are sent to the list before you commit them?
>
>>> [PATCH 3/3] xfstests: btrfs tests for basic informational commands
>
> This test was numbered 313, and so now we have tests 001-306 and 313
> in the repository.  I noticed that Another of Eric's recent patches
> is numbered 315, so it will also need renumbering before commit.
>
> -Dave.
>
Yes I will, sorry it applied so cleanly and I was trying to get it 
committed before I left for the day I overlooked the numbering.  I will 
revert and recommit it with the correct number 306.  Thanks for pointing 
that out.

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
