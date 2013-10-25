Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 21C5D7F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 04:31:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0BC1930407B
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 02:31:56 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id L9HjgDSPbVxCMtL1 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 02:31:55 -0700 (PDT)
Date: Fri, 25 Oct 2013 02:31:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: generic/318 use symbolic namespaced ids
Message-ID: <20131025093154.GA24583@infradead.org>
References: <20131024154414.GB19055@infradead.org>
	<20131024161155.080eabad@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024161155.080eabad@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 24, 2013 at 04:11:55PM -0400, Dwight Engen wrote:
> Christoph, I think the following should fix 318 for you.

This fixes the test for me, thanks.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
