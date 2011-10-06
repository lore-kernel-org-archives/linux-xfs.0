Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96Jq7m4198415 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 14:52:08 -0500
Date: Thu, 6 Oct 2011 15:52:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstest: fsstress add EXT2_IOC_{SET,GET}FLAGS
	operations
Message-ID: <20111006195205.GI13434@infradead.org>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
	<1316357699-22692-2-git-send-email-dmonakhov@openvz.org>
	<1317820840.2226.12.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1317820840.2226.12.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, xfs@oss.sgi.com

On Wed, Oct 05, 2011 at 08:20:40AM -0500, Alex Elder wrote:
> I have a question below.  I think this is probably
> a good addition, though it should be made so it
> works for more than EXTx.

I actually works on more than extN, but at this point it requires
the ext2 headers to compiled, which isn't too nice.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
