Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGTpR5005033 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:29:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21022177270A
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:29:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uFlSj9FFLgVmJJXE for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:29:49 -0800 (PST)
Date: Mon, 22 Dec 2008 11:29:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstest:  fix up test 080
Message-ID: <20081222162919.GA13657@infradead.org>
References: <494FAD2E.3070603@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <494FAD2E.3070603@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Dec 22, 2008 at 09:07:26AM -0600, Eric Sandeen wrote:
> 080 seems to run fine on linux, un-comment the quiet var to
> make the output match.  Added to auto group as well.

Looks good and matches for me.  Making the output less quiet and
updating the expected output would be a good idea for a followup patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
