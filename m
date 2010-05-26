Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4Q6D1b3065585 for <xfs@oss.sgi.com>; Wed, 26 May 2010 01:13:02 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BF87373669
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 23:15:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	A6RsIHCRSkK253lO for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 23:15:23 -0700 (PDT)
Date: Wed, 26 May 2010 16:15:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove duplicated #include
Message-ID: <20100526061521.GS2150@dastard>
References: <1274825726-4364-1-git-send-email-weiyi.huang@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274825726-4364-1-git-send-email-weiyi.huang@gmail.com>
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
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: xfs@oss.sgi.com, aelder@sgi.com

On Wed, May 26, 2010 at 06:15:26AM +0800, Huang Weiyi wrote:
> Remove duplicated #include('s) in
>   fs/xfs/linux-2.6/xfs_quotaops.c
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

Looks good, will push through the XFS tree.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
