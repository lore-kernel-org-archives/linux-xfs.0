Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9M8w69h075695 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 03:58:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9598711C768B
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 01:59:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id q8qRsSHb5BLJ1uYt for
	<xfs@oss.sgi.com>; Thu, 22 Oct 2009 01:59:40 -0700 (PDT)
Date: Thu, 22 Oct 2009 04:59:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20091022085937.GA2039@infradead.org>
References: <4AC60D27.9060703@news-service.com>
	<20091005214348.GA15448@infradead.org>
	<4ACB080D.3010708@news-service.com>
	<20091007011926.GB32032@infradead.org>
	<4AD18C8D.90808@news-service.com>
	<20091012233854.GA29446@infradead.org>
	<20091019011600.GO9464@discord.disaster>
	<20091019035426.GB18296@infradead.org>
	<20091020034048.GA9464@discord.disaster>
	<89c4f90c0910210245h4691cd82hd1d63f5ed72fb2e3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <89c4f90c0910210245h4691cd82hd1d63f5ed72fb2e3@mail.gmail.com>
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
To: Tommy van Leeuwen <tommy@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Patrick Schreurs <patrick@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

> This is the full patch we're using now on 2.6.31.4. (Just running btw
> so no results yet).

Yes, that looks like what you should be testing with..  Thanks a lot
again!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
