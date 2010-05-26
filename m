Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4Q6CUvi065433 for <xfs@oss.sgi.com>; Wed, 26 May 2010 01:12:30 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 208ECA01A46
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 23:16:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	LJF7aKQD7A1ON4a9 for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 23:16:36 -0700 (PDT)
Date: Wed, 26 May 2010 16:14:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/12] xfs: xfs_trace.c: remove duplicated #include
Message-ID: <20100526061450.GR2150@dastard>
References: <1274548400-3404-1-git-send-email-weiyi.huang@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274548400-3404-1-git-send-email-weiyi.huang@gmail.com>
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

On Sun, May 23, 2010 at 01:13:20AM +0800, Huang Weiyi wrote:
> Remove duplicated #include('s) in
>   fs/xfs/linux-2.6/xfs_trace.c
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
