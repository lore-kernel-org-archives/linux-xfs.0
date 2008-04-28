Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 22:57:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3S5vXVI005160
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 22:57:39 -0700
Date: Mon, 28 Apr 2008 01:58:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: 980021 - fix up noattr2 mount option
Message-ID: <20080428055816.GC3192@infradead.org>
References: <480EC93D.9090103@sgi.com> <20080426063551.GA7193@infradead.org> <48151CDD.3070203@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48151CDD.3070203@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Mon, Apr 28, 2008 at 10:39:57AM +1000, Timothy Shimmin wrote:
> Good question.
> I guess I just feel with the problems we've had with attr2 so far,
> I feel it would be good to have an easy way to to go back if needed
> at this point (and the option is there though busted).
> Ideally, there would be no attr1 and no option to go back required.

It was more of a rhetorical quesiton anyway given that the option has
been around for a while.  so consider this a positive review for the
patch.
