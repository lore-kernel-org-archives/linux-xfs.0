Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 04:01:17 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9UB150x018226
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 04:01:09 -0700
Date: Tue, 30 Oct 2007 10:07:05 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Clean up bitops
Message-ID: <20071030100705.GC23489@infradead.org>
References: <20071029233635.GR995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029233635.GR995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

Looks good to me, and you also got rid of these horrible casts in Andi's patch
which is good.
