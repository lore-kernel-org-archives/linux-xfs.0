Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1N7Mdeg082484 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 01:22:40 -0600
Date: Mon, 23 Feb 2009 02:22:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs/xfsdump release process
Message-ID: <20090223072207.GA4112@infradead.org>
References: <200902221348.51905.vapier@gentoo.org>
	<200902221539.26143.vapier@gentoo.org>
	<FE09F2E2-54EC-41C8-9145-7B89C6E62AC2@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <FE09F2E2-54EC-41C8-9145-7B89C6E62AC2@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Mike Frysinger <vapier@gentoo.org>, xfs-oss <xfs@oss.sgi.com>

On Sun, Feb 22, 2009 at 11:00:45PM -0600, Felix Blyakher wrote:
> Mike, you're absolutely right here. The config files got into the
> dmapi tarball by mistake, sorry for this. I verified that neither
> xfsprogs nor xfsdump have any extra files. New (clean) dmapi tarball
> will be on the oss site shortly.

Please don't overwrite already uploaded tarballs.  Let's make a 2.2.10
release instead.  We might just use the Makepkgs script for it after
fixing it.  See the question and patch on the list for xfsprogs for
that, haven't checked dmapi works right yet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
