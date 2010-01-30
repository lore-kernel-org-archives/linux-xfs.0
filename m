Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UJ7Lek230949 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 13:07:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C44921C9231B
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 11:08:28 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id At2OsDMJSe2IKRI9 for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 11:08:28 -0800 (PST)
Date: Sat, 30 Jan 2010 14:08:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: make 053 and 077 generic
Message-ID: <20100130190828.GA10181@infradead.org>
References: <4B621E11.4050609@sandeen.net>
	<20100130102639.GC32695@infradead.org>
	<4B6459A1.4060900@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B6459A1.4060900@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Sat, Jan 30, 2010 at 10:09:05AM -0600, Eric Sandeen wrote:
> > Btw, any reason _acl_requirements isn't called _require_acl?
> 
> It already existed, I just used it ... renaming is probably a good idea.

Yeah, just asking questions to myself while reading the patch..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
