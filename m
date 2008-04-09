Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 01:53:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m398rda0002409
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 01:53:41 -0700
Date: Wed, 9 Apr 2008 04:54:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW #2] cleanup -  refactor xfs_dir2_leafn_lookup_int()
Message-ID: <20080409085416.GA10511@infradead.org>
References: <op.t9b5grqp3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t9b5grqp3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Wed, Apr 09, 2008 at 06:49:29PM +1000, Barry Naujok wrote:
> I've unified the state->extrablk info in the add and lookup paths
> and fixed a bug :)

Looks good.
