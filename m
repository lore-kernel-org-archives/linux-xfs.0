Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9HF2cCH005075 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 10:02:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 139DA1CA662
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 08:02:37 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lIkGB9VffQoFHoKb for <xfs@oss.sgi.com>;
	Mon, 17 Oct 2011 08:02:37 -0700 (PDT)
Date: Mon, 17 Oct 2011 11:02:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair v3.1.6 - Segmentation fault AND XFS internal error
	xfs_btree_check_sblock
Message-ID: <20111017150236.GA7056@infradead.org>
References: <4E9C3EEF.5080609@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E9C3EEF.5080609@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

Can you send me a metadump of the filesystem?  It is generated using the
xfs_metadump tool from xfsprogs, and obsfucates the file names used.
Feel free to upload it to a private place and send the link and/or
directly send it to me if you don't want to see it on the list.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
