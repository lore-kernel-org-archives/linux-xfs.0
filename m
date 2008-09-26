Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 23:29:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q6TF3a031967
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 23:29:17 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE0B21AF3773
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 23:30:50 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id SP9yvqCDx1tlNwXH for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 23:30:50 -0700 (PDT)
Date: Fri, 26 Sep 2008 02:30:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: inode64 question
Message-ID: <20080926063050.GA20516@infradead.org>
References: <alpine.DEB.1.10.0809251943420.5846@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809251943420.5846@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 25, 2008 at 07:44:33PM -0400, Justin Piszcz wrote:
> If I mount the fs with -o inode64, can I mount it again later say under  
> knoppix 32bit without any options, will the FS still mount?  The 64-bit  
> rescue cd/dvds--I have had problems with to say the least.

Not yet.  I'll hopefully get a patch for it into 2.6.28.
