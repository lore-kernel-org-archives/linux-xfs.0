Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3OKvloS110223 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 15:57:47 -0500
Message-ID: <4F9713C8.8080808@sgi.com>
Date: Tue, 24 Apr 2012 15:57:44 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_fsr: Get the last mount on a specific mount point
References: <1328640076-12645-1-git-send-email-cmaiolino@redhat.com>
	<20120213174240.GA3474@infradead.org> <4F3EE490.2010302@redhat.com>
	<20120424201404.GA29605@andromeda.usersys.redhat.com>
In-Reply-To: <20120424201404.GA29605@andromeda.usersys.redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 04/24/12 15:14, Carlos Maiolino wrote:
>>> What do you think about the version below?
>>>
>>> ---
>>> From: Christoph Hellwig<hch@lst.de>
>>> Subject: fsr: fix /proc/mounts parsing
>>>
>>
>> Looks ok to me, thanks for doing it properly :)
>>
>> Reviewed-by: Eric Sandeen<sandeen@redhat.com>
>>
>>> ---
>
> ping
>

The new test is much better organized.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
