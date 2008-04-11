Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 00:41:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3B7f4Pn010493
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 00:41:05 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE8FF128EC7C
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 00:41:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 9vMoEyndozdRy66D for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 00:41:41 -0700 (PDT)
Date: Fri, 11 Apr 2008 03:41:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] Remove unused HAVE_SPLICE macro
Message-ID: <20080411074109.GA3936@infradead.org>
References: <20080411072832.98C2C58C4C15@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411072832.98C2C58C4C15@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 11, 2008 at 05:28:32PM +1000, Donald Douwsma wrote:
> Still more 2.4 build remnants to get rid of...
> 
> HAVE_SPLICE was part of the infrastructure for building 2.4 and 2.6
> kernels out of the same tree. Now we don't build 2.4 kernels this 
> way anymore its unused.

Looks good.
