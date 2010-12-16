Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBG3ATwB259412 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 21:10:30 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 272A31CD09C7
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 19:12:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	7PqJxtTjVEPKLE8m for <xfs@oss.sgi.com>;
	Wed, 15 Dec 2010 19:12:21 -0800 (PST)
Date: Thu, 16 Dec 2010 14:12:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4] xfstests: pwrite hang when writing from mmaped
	buffer of the same page
Message-ID: <20101216031213.GK9925@dastard>
References: <1292466652-15563-1-git-send-email-xin.zhong@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292466652-15563-1-git-send-email-xin.zhong@intel.com>
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
To: "Zhong, Xin" <xin.zhong@intel.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 16, 2010 at 10:30:52AM +0800, Zhong, Xin wrote:
> The problem is found in meego testing on btrfs:
> http://bugs.meego.com/show_bug.cgi?id=6672
> 
> Reviewed-by: Hellwig, Christoph <hch@infradead.org>
> Reviewed-by: Chinner, Dave <david@fromorbit.com>
> Signed-off-by: Zhong, Xin <xin.zhong@intel.com>

Looks good now. Thanks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
