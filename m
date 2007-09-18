Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 08:51:54 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JFpiv2003681
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 08:51:49 -0700
Date: Tue, 18 Sep 2007 16:39:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix valid but harmless sparse warning in xfs_log_recovery.c
Message-ID: <20070918143904.GA8488@lst.de>
References: <20070916120433.GA31602@lst.de> <46EF6A6A.3080702@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EF6A6A.3080702@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Sep 18, 2007 at 04:04:26PM +1000, Lachlan McIlroy wrote:
> Ah thanks for that, my goof.

Can you and Tim make sure this goes to Linus?  I saw Tim sent out
your original fix, and I really don't want to regress on sparse warnings
in mainline.
