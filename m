Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DNxoFw161604 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 18:59:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B357C2659B
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 17:01:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JyA5iB5DMnC1O7Pa for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 17:01:21 -0700 (PDT)
Date: Tue, 13 Oct 2009 20:01:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS_repair and memory
Message-ID: <20091014000120.GB18467@infradead.org>
References: <4AB9E28D.4070708@poczta.onet.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AB9E28D.4070708@poczta.onet.pl>
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
To: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
Cc: xfs@oss.sgi.com

On Wed, Sep 23, 2009 at 10:55:41AM +0200, aluno3@poczta.onet.pl wrote:
> Hello
> 
> I have question connected with xfs_repair and memory.I am wondering if
> there is any simple way to calculate minimum memory requirements for
> xfs-repair?

Not yet, we'll try to come up with some better documentation after
the full set of memory usage optimizations has made it in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
