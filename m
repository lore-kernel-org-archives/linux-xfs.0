Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q72MQAo6246205 for <xfs@oss.sgi.com>; Thu, 2 Aug 2012 17:26:10 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id rcztniOAxhUECH4B for <xfs@oss.sgi.com>;
	Thu, 02 Aug 2012 15:26:09 -0700 (PDT)
Message-ID: <501AFE80.40709@sandeen.net>
Date: Thu, 02 Aug 2012 17:26:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_db: bug in bmap command?
References: <CAH4wwdGbecJ42ONkk3WQRhqUuLUALaSHP-+Ran0Lu8aofW5M8A@mail.gmail.com>
	<501AFCF1.70804@sandeen.net>
In-Reply-To: <501AFCF1.70804@sandeen.net>
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
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On 8/2/12 5:19 PM, Eric Sandeen wrote:
> On 8/1/12 10:17 AM, Peter Watkins wrote:
>> Hello,
>>
>> If you have a moment would you be kind enough to review the test case
>> and patch below?
>>
>> I ran into this while using xfs_db to dump extents for a large,
>> fragmented file. The extents were stored in btree form.
> 
> The xfs_db change looks right.

(and I'll merge it, Reviewed-by: Eric Sandeen <sandeen@sandeen.net> )

Thanks!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
