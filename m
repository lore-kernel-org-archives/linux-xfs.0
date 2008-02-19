Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 14:57:28 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1JMvLio019381
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 14:57:22 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0C89E6A4C1
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 14:57:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 52qrln2ZQX7sR2rC for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 14:57:47 -0800 (PST)
Date: Tue, 19 Feb 2008 17:57:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, mainline-only] remove sendfile leftovers
Message-ID: <20080219225746.GA26576@infradead.org>
References: <20080208044256.GA15013@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208044256.GA15013@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Feb 08, 2008 at 05:42:57AM +0100, Christoph Hellwig wrote:
> Remove the last sendfile leftovers in mainline.  This code is already
> gone in CVS.

Any chance to pass on these three no-risk mainline-only patches to
Linus?  I'm pretty sure they'll get lost otherwise until the next
merge window..
