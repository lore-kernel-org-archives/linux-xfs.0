Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9ABLsE6173158 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 06:21:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B5C055EE8F
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 04:21:53 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	kgqJEiAC6v3mG2u6 for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 04:21:53 -0700 (PDT)
Date: Mon, 10 Oct 2011 07:21:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Changes to received review comments
Message-ID: <20111010112151.GA28627@infradead.org>
References: <4E3BA2F7.4080500@oracle.com> <4E44351D.4020202@oracle.com>
	<20110902084941.GB29054@infradead.org>
	<4E92C1D7.2010301@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E92C1D7.2010301@oracle.com>
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
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Oct 10, 2011 at 05:58:47PM +0800, Anand Jain wrote:
>  Now SCRATCH_DEV is derived from SCRATCH_DEV_POOL.
>  Moved code to delete and scan block device to common.rc and
>  updated README.

Can you resend the whole patch?   Note that xfstests is up to test 262
in the meantime, so it will also need to be renumbered.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
