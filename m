Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 990A17F3F
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 03:48:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B5588F8066
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 01:48:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id BhJCGlKIedrUh0jj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Sep 2013 01:48:54 -0700 (PDT)
Date: Tue, 24 Sep 2013 01:48:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] stable_kernel_rules.txt: Exclude networking from stable
	rules
Message-ID: <20130924084842.GB11858@infradead.org>
References: <alpine.LRH.2.02.1309191229480.32035@file01.intranet.prod.int.rdu2.redhat.com>
	<20130919.135628.1201613770803318193.davem@davemloft.net>
	<alpine.LRH.2.02.1309191359300.12162@file01.intranet.prod.int.rdu2.redhat.com>
	<1379615474.22168.13.camel@joe-AO722>
	<20130922185104.GA7515@infradead.org>
	<1379968445.3575.60.camel@joe-AO722>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379968445.3575.60.camel@joe-AO722>
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
To: Joe Perches <joe@perches.com>
Cc: stephen@networkplumber.org, linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Mikulas Patocka <mpatocka@redhat.com>, Rob Landley <rob@landley.net>, netdev@vger.kernel.org, David Miller <davem@davemloft.net>

On Mon, Sep 23, 2013 at 01:34:05PM -0700, Joe Perches wrote:
> Maybe adding a mechanism to MAINTAINERS would be better.
> Maybe a default B: (backport?) of stable@vger.kernel.org
> with a per-subsystem override?

Sounds fine to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
