Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1PM33Xl132573 for <xfs@oss.sgi.com>; Thu, 25 Feb 2010 16:03:03 -0600
Subject: Re: [PATCH 00/10] quotactl fixed and cleanups
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100216084446.377980079@bombadil.infradead.org>
References: <20100216084446.377980079@bombadil.infradead.org>
Date: Thu, 25 Feb 2010 16:04:22 -0600
Message-ID: <1267135462.1905.31.camel@doink>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, swhiteho@redhat.com, xfs@oss.sgi.com

On Tue, 2010-02-16 at 03:44 -0500, Christoph Hellwig wrote:
> This is a first large batch of refactoring the generic quotactl code.
> I started looking at this for merging the FS interfaces for "VFS" and "XFS"
> style quotas now that we grow more filesystems wanting to support quota
> in a more advanced way than the generic implementation can, e.g. GFS2
> and cifs.  There will be another couple of patches do do the actual
> work which are not quite ready, but this is a large and useful enough batch
> to get review and possibly included first.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Whole series looks good to me.  I know it's late, but...

Acked-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
