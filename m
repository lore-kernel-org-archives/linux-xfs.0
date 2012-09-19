Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JEAPZF207637 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 09:10:25 -0500
Message-ID: <5059D292.1080500@sgi.com>
Date: Wed, 19 Sep 2012 09:11:30 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix a compile warning at seek_sanity_test.c
References: <4FCA2422.90804@oracle.com> <5059CA6B.8090609@sgi.com>
	<5059D0D5.9050205@oracle.com>
In-Reply-To: <5059D0D5.9050205@oracle.com>
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
To: jeff.liu@oracle.com
Cc: xfs@oss.sgi.com

On 09/19/12 09:04, Jeff Liu wrote:
> On 09/19/2012 09:36 PM, Mark Tinguely wrote:
>
>> On 06/02/12 09:33, Jeff Liu wrote:
>>> Hello,
>>>
>>> Compiler report warning at seek_sanity_test.c:
>>> seek_sanity_test.c:46:3: warning: format '%lx' expects type 'long
>>> unsigned int', but argument 3 has type 'int'
>>>
>>> Below patch can fix it.
>>>
>>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>
>> Sorry, looks like this clean-up patch has not been committed yet.
>>
>> Looks good.
>>
>> Reviewed-by: Mark Tinguely<tinguely@sgi.com>
>
>
> Could you please also consider another patch for 286 improvements at:
> http://patchwork.xfs.org/patch/3731
>
> Thanks,
> -Jeff
>

Yes, I will make sure it gets committed; it has been already reviewed.

Did I remember correctly that there is plans for another test for the 
latest kernel features?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
