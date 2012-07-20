Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6K1bJxY065007 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 20:37:19 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id qKrWWnsoVmolKZDM for
	<xfs@oss.sgi.com>; Thu, 19 Jul 2012 18:37:16 -0700 (PDT)
Message-ID: <5008B62E.8070606@cn.fujitsu.com>
Date: Fri, 20 Jul 2012 09:36:46 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Xfstests/254: add more cases for testing btrfs snapshot
	in 254
References: <5007E0FB.9040208@cn.fujitsu.com> <20120720002433.GH23387@dastard>
In-Reply-To: <20120720002433.GH23387@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 07/20/2012 08:24 AM, Dave Chinner wrote:

> On Thu, Jul 19, 2012 at 06:27:07PM +0800, Liu Bo wrote:
>> From: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
>>
>> This patch adds more cases in 254 for testing btrfs snapshot.
>>
>> Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
> 
> I think it is better to create a new test than modify the old one.
> That way it is easy to tell the difference between a new failure and
> regression.
> 


Sure, that makes sense.

thanks,
liubo

> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
