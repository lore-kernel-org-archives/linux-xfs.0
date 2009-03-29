Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2T9TDim123859 for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 04:29:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41DFF1D1623
	for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 02:28:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AqaXne1PYTbfCBVX for
	<xfs@oss.sgi.com>; Sun, 29 Mar 2009 02:28:49 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LnrJw-0004dz-U8
	for xfs@oss.sgi.com; Sun, 29 Mar 2009 09:28:48 +0000
Date: Sun, 29 Mar 2009 05:28:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] A couple more patches for 2.6.30
Message-ID: <20090329092848.GA16880@infradead.org>
References: <20090318094119.561416000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090318094119.561416000@bombadil.infradead.org>
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
To: xfs@oss.sgi.com

I pushed out the patches that go review, plus Hisashi Hifumi's pagecache
usage optimization and Malcolm Parsons' typo fixes to

	git://git.kernel.org/pub/scm/fs/xfs/xfs.git

I still need a couple more reviews and we also need to decide how to
pull in Dave's patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
