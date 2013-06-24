Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 30D607F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 22:32:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C9318F8037
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:32:13 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id nN7RChIkzZxbNnbT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 20:32:11 -0700 (PDT)
Message-ID: <51C7BDBE.3080107@oracle.com>
Date: Mon, 24 Jun 2013 11:32:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Remove the left function variable from
	xfs_ialloc_get_rec()
References: <51C44819.6070003@oracle.com> <20130623231414.GD29376@dastard>
In-Reply-To: <20130623231414.GD29376@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 06/24/2013 07:14 AM, Dave Chinner wrote:

> On Fri, Jun 21, 2013 at 08:33:29PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> This patch clean out the left function variable as it is
>> useless to xfs_ialloc_get_rec().
>>
>> Signed-off-by: jeff <jeff@kdev.(none)>
> 
> Patch looks OK, by the SOB is all wrong. can you repost with the
> correct SOB?

Will repost it soon, my apologies!

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
