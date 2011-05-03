Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p43HgUb2022966 for <xfs@oss.sgi.com>; Tue, 3 May 2011 12:42:31 -0500
Subject: Re: [PATCH] xfstests: fix error discard test output in 251.out.
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1303962551-14893-1-git-send-email-tm@tao.ma>
References: <1303962551-14893-1-git-send-email-tm@tao.ma>
Date: Tue, 3 May 2011 12:46:07 -0500
Message-ID: <1304444767.2853.29.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Tao Ma <tm@tao.ma>
Cc: Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, 2011-04-28 at 11:49 +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> I don't know why, but discard tests is 251 in xfs,
> but 251.out has number of 248 in it, So it fails.
> Change it to 251 now.
> 
> Cc: Lukas Czerner <lczerner@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Alex Elder <aelder@sgi.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Looks good.  I'll commit this for you.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
