Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DCwVMb061169 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 07:58:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43BDA13E4E52
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 06:03:08 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NNDcFpChuOV0oKJ1 for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2011 06:03:08 -0700 (PDT)
Date: Tue, 13 Sep 2011 08:58:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add new getdents test
Message-ID: <20110913125828.GA19796@infradead.org>
References: <1315786747-12109-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315786747-12109-1-git-send-email-notasas@gmail.com>
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
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Sep 12, 2011 at 03:19:07AM +0300, Grazvydas Ignotas wrote:
> The test checks if no duplicate d_off values are returned and that
> those values are seekable to the right inodes.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Thanks a lot!  I've applied it locally and will push it out as soon
as kernel.org is back up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
